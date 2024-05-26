import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pytorch_lite/pigeon.dart';
import 'package:translateappp/ui/box_widget.dart';


class ResultScreen extends StatelessWidget {
  final String? imagePath;
  final String manuallyProvidedImagePath = 'assets/images/simple.png';
  final List<ResultObjectDetection>? results;
  final String letter ;
  final int index;

  ResultScreen({Key? key, required this.imagePath, required this.results, required  this.letter, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.white,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    manuallyProvidedImagePath,
                    fit: BoxFit.cover,
                  ),
                  if (imagePath != null && File(imagePath!).existsSync())
                    Positioned(
                      left: 8,
                      bottom: 20, // Adjust this value to move the camera image up
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.24,
                          child: Image.file(
                            File(imagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 115.0, // Adjust this value to move the orange container up or down
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  child: Container(
                    color: Colors.orange,
                    width: double.infinity,
                    height: 110.0, // Adjust the height as needed
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(20.0),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 8.0),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Result : ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                                ),
                                Text(
                                  letter,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Translation : ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                                ),
                                Text(
                                  translateToArabic(letter) as String ,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 23.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 80.0),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: FloatingActionButton(
                          onPressed: () {
                          },
                          child: const Icon(CupertinoIcons.chevron_left, color: Colors.white),
                          backgroundColor: Colors.transparent,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<String> arabicAlphabet = [
    'أ', 'ب', 'س', 'د', 'null', 'ف', 'ج', 'ه-ح', 'ي', 'ج', 'ك', 'ل', 'م',
    'ن', 'و', 'ب', 'ق', 'ر', 'س-ص-ز', 'ت', 'null', 'ف', 'و', 'null', 'ي', 'ز'
  ];



  String translateToArabic(String input) {
    String? arabicLetter = arabicAlphabet[index];
    return arabicLetter.toString();
  }


  Future<void> _drawBoundingBoxesAndSave(BuildContext context) async {
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@s");
    if (imagePath == null || !File(imagePath!).existsSync() || results == null) return;

    // Load the image
    final File originalImageFile = File(imagePath!);
    final ui.Image originalImage = await _loadImage(originalImageFile);

    // Create a picture recorder to draw the image and bounding boxes
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(originalImage.width.toDouble(), originalImage.height.toDouble())));
    final paint = Paint();

    // Draw the original image
    canvas.drawImage(originalImage, Offset.zero, paint);

    // Draw the bounding boxes
    for (var result in results!) {
      final rect = Rect.fromLTWH(
        result.rect.left * originalImage.width,
        result.rect.top * originalImage.height,
        result.rect.width * originalImage.width,
        result.rect.height * originalImage.height,
      );

      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // End recording and create a new image
    final picture = recorder.endRecording();
    final newImage = await picture.toImage(originalImage.width, originalImage.height);
    final ByteData? byteData = await newImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_with_boxes.png';
      var directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/$fileName';
      print("---------------------------------------------------------");
      print(filePath);
      await File(filePath).writeAsBytes(byteData.buffer.asUint8List());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryScreen(imagePath: filePath),
        ),
      );
    }
  }

  Future<ui.Image> _loadImage(File file) async {
    final Completer<ui.Image> completer = Completer();
    final Uint8List imgBytes = await file.readAsBytes();
    ui.decodeImageFromList(imgBytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  Widget boundingBoxes2(List<ResultObjectDetection>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoxWidget(result: e)).toList(),
    );
  }
}


void _takeScreenshotAndNavigateToHistory(BuildContext context) async {
    RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      var directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/$fileName';
      File(filePath).writeAsBytesSync(byteData.buffer.asUint8List());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryScreen(imagePath: filePath),
        ),
      );
    }
  }


class HistoryScreen extends StatelessWidget {
  final String imagePath;

  const HistoryScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ManuallyProvidedImageView extends StatelessWidget {
  final String imagePath;

  const ManuallyProvidedImageView({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 59,
      right: 3,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
