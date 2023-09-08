import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/model/api/post_story.dart';
import 'package:puth_story/provider/auth_provider.dart';
import 'package:puth_story/provider/story_provider.dart';
import 'package:puth_story/screen/camera.dart';
import 'package:puth_story/utils/image_compress.dart';
import 'package:puth_story/utils/result_state.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';
import 'package:puth_story/widgets/v_margin.dart';

class StoryAddPage extends StatefulWidget {
  final Function() onUploaded;

  const StoryAddPage({super.key, required this.onUploaded});

  @override
  State<StoryAddPage> createState() => _StoryAddPageState();
}

class _StoryAddPageState extends State<StoryAddPage> {
  XFile? imageFile;
  String? imagePath;

  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        title: "Create Story",
        child: Column(
          children: [
            _previewImage(),
            const VMargin(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => _onGalleryView(),
                    child: const Text("Open Gallery")),
                ElevatedButton(
                    onPressed: () => _onCameraView(),
                    child: const Text("Open Camera")),
              ],
            ),
            const VMargin(),
            Form(
              key: ValueKey(formKey),
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    decoration: const InputDecoration(hintText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description must be filled';
                      }
                      if (value.length < 10) {
                        return 'Description is not valid';
                      }

                      return null;
                    },
                  ),
                  const VMargin(),
                  Consumer<StoryProvider>(
                    builder: (context, provider, _) {
                      switch (provider.state) {
                        case ResultState.loading:
                          return OutlinedButton(
                            onPressed: () {},
                            child: const CircularProgressIndicator(),
                          );
                        default:
                          return ElevatedButton(
                            onPressed: () => {
                              if(formKey.currentState!.validate()){
                                _postStory(context, provider)
                              }
                            },
                            child: const Text("Post"),
                          );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _previewImage() {
    return imagePath == null
        ? const Center(
            child: Icon(
              Icons.image,
              size: 100,
            ),
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }

  _onGalleryView() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
        imagePath = pickedFile.path;
      });
    }
  }

  _onCameraView() async {
    final navigator = Navigator.of(context);
    final cameras = await availableCameras();

    final XFile? resultImageFile = await navigator.push(
      MaterialPageRoute(
        builder: (context) => CameraPage(
          cameras: cameras,
        ),
      ),
    );

    if (resultImageFile != null) {
      setState(() {
        imageFile = resultImageFile;
        imagePath = resultImageFile.path;
      });
    }
  }

  _postStory(BuildContext context, StoryProvider provider) async {
    if (imageFile == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    final fileBytes = await imageFile!.readAsBytes();
    final compressedBytes = await resizeImage(fileBytes);

    final fileBody = PostStoryFileRequest(
        fileBytes: compressedBytes, filename: imageFile!.name);
    final body = PostStoryBodyRequest(description: descriptionController.text);

    final isUploaded =
        await provider.postStory(user?.token ?? "-", fileBody, body);

    if (isUploaded) widget.onUploaded();
  }
}
