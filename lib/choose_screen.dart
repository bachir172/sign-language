import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'camera_screen2.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25), // Add padding to the sides
            child: Text(
              'Learn ASL and ArSL today.',
              style: TextStyle(color: Colors.black, fontSize: 37, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start, // Center align the text
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding to the sides
            child: Text(
              'Translate and become a part of a great community.',
              style: TextStyle(color: Color(0xFF424242), fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start, // Center align the text
            ),
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black,
              minimumSize: Size(320, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Alphabets',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen2()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black,
              minimumSize: Size(320, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Words',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          Flexible(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/art5.png',
                fit: BoxFit.contain,
                height: 210,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
