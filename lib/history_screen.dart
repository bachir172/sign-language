import 'dart:io';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final String imagePath;

  const HistoryScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
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
