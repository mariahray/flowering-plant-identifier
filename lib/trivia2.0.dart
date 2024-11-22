import 'dart:math';
import 'package:flutter/material.dart';

class Trivia extends StatefulWidget {
  @override
  _TriviaState createState() => _TriviaState();
}

class _TriviaState extends State<Trivia> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final List<String> _triviaList = [
    "Chrysanthemums are also known as mums or chrysanths.",
    "Chrysanthemums are native to Asia and northeastern Europe.",
    "The chrysanthemum is a symbol of long life and happiness in many cultures.",
    "There are over 40 species of chrysanthemum.",
    "Chrysanthemums were first cultivated in China as a flowering herb in the 15th century BC.",
    "The Flower Farm is known for its vast collection of rare flower species.",
    "At The Flower Farm, you can find a beautiful garden of chrysanthemums every spring.",
    "Chrysanthemums come in various colors including red, yellow, white, and purple.",
    "The name 'chrysanthemum' comes from the Greek words 'chrysos' (gold) and 'anthemon' (flower).",
    "Chrysanthemums are often given as gifts during the autumn festival in Japan.",
  ];

  String _currentTrivia = "";
  bool _showDefaultText = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
      lowerBound: 0.9,
      upperBound: 1.0,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    _currentTrivia = _triviaList[Random().nextInt(_triviaList.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onImageTap() {
    if (!_controller.isAnimating) {
      _controller.forward();
    }

    setState(() {
      _currentTrivia = _triviaList[Random().nextInt(_triviaList.length)];
      _showDefaultText = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/catbook.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/trivia');
              },
              child: Image.asset(
                'assets/images/back-icon.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 200),
              child: Column(
                children: [
                  if (!_showDefaultText)
                    Container(
                      width: 300,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _currentTrivia,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Mazzard-Medium",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(135, 194, 138, 0.91),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showDefaultText)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Hello, I am Flor! Please tap me",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Mazzard-Bold",
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(67, 129, 71, 0.7),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: _onImageTap,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Image.asset(
                        'assets/images/Flor.png',
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
