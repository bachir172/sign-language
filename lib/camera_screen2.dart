import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'result_screen2.dart'; // Ensure you import the correct file

class CameraScreen2 extends StatefulWidget {
  const CameraScreen2({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen2> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<String> _imagePaths = []; // Store the paths of the captured images
  FlashMode _flashMode = FlashMode.off;
  CameraLensDirection _currentCamera = CameraLensDirection.back;
  int? _selectedImageIndex; // Track the selected image for deletion

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
    return _controller.initialize();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      setState(() {
        if (_imagePaths.length < 10) {
          _imagePaths.add(image.path); // Store the path of the captured image
        }
      });
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

  void _deleteImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
      _selectedImageIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Sync',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen2(imagePaths: _imagePaths),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                      child: CameraPreview(_controller),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          if (_imagePaths.isNotEmpty)
            Container(
              height: 95,
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = _selectedImageIndex == index ? null : index;
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Image.file(
                              File(_imagePaths[index]),
                              width: 60,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (_selectedImageIndex == index)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => _deleteImage(index),
                              child: Container(
                                width: 24, // Fixed width for the container
                                height: 24, // Fixed height for the container
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle, // Rounder container
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
