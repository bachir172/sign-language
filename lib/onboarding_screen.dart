import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'choose_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomPaint(
            isComplex: true,
            painter: ArcPainter(),
            child: Container(
              height: screenSize.height / 1.4,
              width: screenSize.width,
              color: Colors.transparent,
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: tabs.length,
            itemBuilder: (BuildContext context, int index) {
              OnboardingModel tab = tabs[index];
              return Stack(
                children: [
                  Positioned(
                    top: tab.top,
                    left: tab.left,
                    right: tab.right,
                    child: Lottie.asset(
                      tab.lottieAsset,
                      width: 200,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 250,
                      child: Column(
                        children: [
                          Text(
                            tab.title,
                            style: const TextStyle(
                              fontSize: 27.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            tab.subtitle,
                            style: const TextStyle(
                              fontSize: 17.0,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            onPageChanged: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 270,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int index = 0; index < tabs.length; index++)
                        _DotIndicator(isSelected: index == _currentIndex),
                    ],
                  ),
                  const SizedBox(height: 75),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentIndex == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChooseScreen()),
            );
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          }
        },
        child: const Icon(CupertinoIcons.chevron_right, color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path orangeArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 170)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 170)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(orangeArc, Paint()..color = Colors.orange);

    Path whiteArc = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, size.height - 185)
      ..quadraticBezierTo(
          size.width / 2, size.height - 70, size.width, size.height - 185)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(whiteArc, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isSelected;

  const _DotIndicator({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 6.0,
        width: 6.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : Colors.white38,
        ),
      ),
    );
  }
}

class OnboardingModel {
  final String lottieAsset;
  final double top;
  final double left;
  final double right;
  final String title;
  final String subtitle;

  OnboardingModel(
      this.lottieAsset, {
        required this.top,
        required this.left,
        required this.right,
        required this.title,
        required this.subtitle,
      });
}

List<OnboardingModel> tabs = [
  OnboardingModel(
    'assets/lottie/onboard1.json',
    top: 225,
    left: 1,
    right: 5,
    title: 'ASL',
    subtitle: ' this application allows you \nto Learn and recognize \nthe American sign  .',
  ),
  OnboardingModel(
    'assets/lottie/board22.json',
    top: 130,
    left: 10,
    right: 10,
    title: 'ArSL',
    subtitle: 'We make it simple to find the \nfood you crave. Enter your \naddress and let',
  ),
  OnboardingModel(
    'assets/lottie/onboard3.json',
    top: 120,
    left: 0,
    right: 0,
    title: 'ASL2ArSL',
    subtitle: 'with this app , \nsimple and free - no matter if you \norder',
  ),
];
