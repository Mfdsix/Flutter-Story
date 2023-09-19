import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/routes/page_manager.dart';

class CameraPage extends StatefulWidget {
  final Function() onSend;
  final List<CameraDescription> cameras;

  const CameraPage({super.key, required this.onSend, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {

  bool _isCameraInitialized = false;
  CameraController? controller;
  bool _isBackCameraSelected = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    onNewCameraSelected(widget.cameras.first);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Take Photo"),
          actions: [
            IconButton(
              onPressed: () => _onCameraSwitch(),
              icon: const Icon(Icons.cameraswitch),
            ),
          ],
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _isCameraInitialized
                  ? CameraPreview(controller!)
                  : const Center(child: CircularProgressIndicator()),
              Align(
                alignment: const Alignment(0, 0.95),
                child: _actionWidget(),
              ),
            ],
          ),
        ),
    );
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    await previousCameraController?.dispose();

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        controller = cameraController;
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  Widget _actionWidget() {
    return FloatingActionButton(
      heroTag: "take-picture",
      tooltip: "Take Picture",
      onPressed: () => _onCameraButtonClick(),
      child: const Icon(Icons.camera_alt),
    );
  }

  Future<void> _onCameraButtonClick() async {
    final image = await controller?.takePicture();
    _returnData(image);

    widget.onSend();
  }

  void _returnData(XFile? image) async {
    context.read<PageManager>().returnCameraData(image);
  }

  void _onCameraSwitch() {
    if (widget.cameras.length == 1) return;

    setState(() {
      _isCameraInitialized = false;
    });

    onNewCameraSelected(
      widget.cameras[_isBackCameraSelected ? 1 : 0],
    );

    setState(() {
      _isBackCameraSelected = !_isBackCameraSelected;
    });
  }

}
