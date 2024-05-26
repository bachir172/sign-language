import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultScreen2 extends StatefulWidget {
  final List<String> imagePaths;

  const ResultScreen2({Key? key, required this.imagePaths}) : super(key: key);

  @override
  _ResultScreen2State createState() => _ResultScreen2State();
}

class _ResultScreen2State extends State<ResultScreen2> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _nextPage() {
    if (_currentPage < widget.imagePaths.length - 1) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

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
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: widget.imagePaths.isNotEmpty
                      ? PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imagePaths.length,
                    itemBuilder: (context, index) {
                      return Image.file(
                        File(widget.imagePaths[index]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  )
                      : Center(
                    child: Text(
                      'No image available',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                if (widget.imagePaths.isNotEmpty)
                  Positioned(
                    left: 16.0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(CupertinoIcons.left_chevron, color: Colors.black),
                      onPressed: _previousPage,
                      tooltip: 'Previous Image',
                    ),
                  ),
                if (widget.imagePaths.isNotEmpty)
                  Positioned(
                    right: 16.0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(CupertinoIcons.right_chevron, color: Colors.black),
                      onPressed: _nextPage,
                      tooltip: 'Next Image',
                    ),
                  ),
              ],
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Result: ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                                  ),
                                  Text(
                                    'Hello, how are you?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Translation: ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                                  ),
                                  Text(
                                    'مرحبا، كيف حالك؟',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 23.0),
                                  ),
                                ],
                              ),
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
                            Navigator.pop(context);
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
}
