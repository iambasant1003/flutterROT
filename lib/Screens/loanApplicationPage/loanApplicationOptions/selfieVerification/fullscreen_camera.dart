import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class FullScreenCameraPage extends StatefulWidget {
  const FullScreenCameraPage({Key? key}) : super(key: key);

  @override
  State<FullScreenCameraPage> createState() => _FullScreenCameraPageState();
}

class _FullScreenCameraPageState extends State<FullScreenCameraPage> {
  CameraController? _controller;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (!mounted) return;

    setState(() {
      _isCameraReady = true;
    });
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;

    EasyLoading.show(status: "Processing...");

    final directory = await getTemporaryDirectory();
    final picture = await _controller!.takePicture();
    final filePath = path.join(
      directory.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await picture.saveTo(filePath);

    // ✅ Read original bytes
    final bytes = await File(filePath).readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage != null) {
      // 📌 Only bake orientation for rear camera
      // Front camera already appears correctly in preview
      if (_controller!.description.lensDirection != CameraLensDirection.front) {
        originalImage = img.bakeOrientation(originalImage);
      }

      // 🔄 Flip front camera horizontally to match preview
      if (_controller!.description.lensDirection == CameraLensDirection.front) {
        originalImage = img.flipHorizontal(originalImage);
      }

      // 🖼 Save final image
      await File(filePath).writeAsBytes(img.encodeJpg(originalImage, quality: 100));
    }

    // 📏 Compress if needed
    File finalFile = File(filePath);
    final size = await finalFile.length();
    if (size > 5 * 1024 * 1024) {
      final compressedPath = path.join(
        directory.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );
      final compressed = await FlutterImageCompress.compressAndGetFile(
        finalFile.path,
        compressedPath,
        quality: 80,
        autoCorrectionAngle: true,
      );
      if (compressed != null) {
        finalFile = File(compressed.path);
      }
    }

    EasyLoading.dismiss();

    if (!mounted) return;
    Navigator.pop(context, finalFile.path);
  }


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: CameraPreview(_controller!),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: GestureDetector(
                onTap: _takePicture,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
