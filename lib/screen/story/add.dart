import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/model/api/post_story.dart';
import 'package:puth_story/provider/story_provider.dart';
import 'package:puth_story/routes/page_manager.dart';
import 'package:puth_story/utils/image_compress.dart';
import 'package:puth_story/utils/result_state.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';
import 'package:puth_story/widgets/v_margin.dart';

class StoryAddPage extends StatefulWidget {
  final Function(List<CameraDescription> cameras) onOpenCamera;
  final Function() onOpenLocation;
  final Function() onUploaded;

  const StoryAddPage(
      {super.key, required this.onOpenCamera, required this.onUploaded, required this.onOpenLocation});

  @override
  State<StoryAddPage> createState() => _StoryAddPageState();
}

class _StoryAddPageState extends State<StoryAddPage> {
  XFile? imageFile;
  String? imagePath;
  LatLng? storyLocation;

  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final pageManager = context.read<PageManager>();
    if(pageManager.cameraFile != null){
      setState(() {
        imageFile = pageManager.cameraFile;
        imagePath = pageManager.cameraFile?.path;
      });
    }
    if(pageManager.location != null){
      setState(() {
        storyLocation = pageManager.location;
      });
    }

    return PlatformScaffold(
      title: "Create Story",
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              key: formKey,
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
                      switch (provider.postState) {
                        case ResultState.loading:
                          return OutlinedButton(
                            onPressed: () {},
                            child: const CircularProgressIndicator(),
                          );
                        default:
                          return ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await _postStory(context, provider);
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
        ),
      ),
    );
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
    final cameras = await availableCameras();
    widget.onOpenCamera(cameras);

    if(!mounted) return;
    await context.read<PageManager>().waitForCameraResult();
  }

  _onReadLocation() async {
    widget.onOpenLocation();

    if(!mounted) return;
    await context.read<PageManager>().waitForLocationResult();
  }

  _postStory(BuildContext context, StoryProvider provider) async {
    if (imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please choose image")));
      return;
    }

    final fileBytes = await imageFile!.readAsBytes();
    final compressedBytes = await resizeImage(fileBytes);

    final fileBody = PostStoryFileRequest(
        fileBytes: compressedBytes, filename: imageFile!.name);
    final body = PostStoryBodyRequest(
        description: descriptionController.text,
        lat: (storyLocation != null) ? storyLocation!.latitude : null,
        lon: (storyLocation != null) ? storyLocation!.longitude : null,
    );

    final isUploaded = await provider.postStory(fileBody, body);

    if (isUploaded == false) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.message ?? "Failed to Add Story")));
    }else{
      widget.onUploaded();
    }
  }

  @override
  void dispose() {
    context.read<PageManager>().removeCameraFile();
    context.read<PageManager>().removeLocation();

    super.dispose();
  }
}
