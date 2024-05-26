import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pytorch_lite/pigeon.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:translateappp/ui/box_widget.dart';
import 'package:translateappp/ui/camera_view.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String _imagePath; // Store the path of the captured image
  FlashMode _flashMode = FlashMode.off;
  CameraLensDirection _currentCamera = CameraLensDirection.back;

  List<ResultObjectDetection>? results;
  String letter="";
  late int index;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    return _controller?.initialize();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      setState(() {
        _imagePath = image.path; // Store the path of the captured image
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(imagePath: _imagePath,results: results,letter: letter,index:index),
        ),
      );
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void _toggleFlash() {
    setState(() {
      _flashMode = _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
      _controller.setFlashMode(_flashMode);
    });
  }

  Future<void> _flipCamera() async {
    final cameras = await availableCameras();
    CameraDescription newCameraDescription;
    if (_currentCamera == CameraLensDirection.back) {
      newCameraDescription = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
      _currentCamera = CameraLensDirection.front;
    } else {
      newCameraDescription = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
      _currentCamera = CameraLensDirection.back;
    }
    await _controller.dispose(); // Dispose the current controller
    _controller = CameraController(
      newCameraDescription,
      ResolutionPreset.medium,
    );
    setState(() {
      _initializeControllerFuture = _controller.initialize();
    }); // Re-render the camera preview
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camera Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child:
                Stack(children: [
                  CameraView(resultsCallback),
                  boundingBoxes2(results)

                ]),

                // CameraPreview(_controller),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                _flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
                color: Colors.white,
              ),
              onPressed: _toggleFlash,
              iconSize: 36,
            ),
            IconButton(
              icon: Icon(
                Icons.panorama_fish_eye,
                color: Colors.white,
              ),
              onPressed: _takePicture,
              iconSize: 100,
            ),
            IconButton(
              icon: Icon(
                Icons.flip_camera_ios,
                color: Colors.white,
              ),
              onPressed: _flipCamera,
              iconSize: 36,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  void resultsCallback(List<ResultObjectDetection> results) {
    if (!mounted) {
      return;
    }
    setState(() {
      this.results = results;

      for (var element in results) {
        letter=element.className!;
        index = element.classIndex;
        print({
          "rect": {
            "left": element.rect.left,
            "top": element.rect.top,
            "width": element.rect.width,
            "height": element.rect.height,
            "right": element.rect.right,
            "bottom": element.rect.bottom,
            "className": element.className,
          },
        });
      }
    });
  }

  Widget boundingBoxes2(List<ResultObjectDetection>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoxWidget(result: e)).toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
