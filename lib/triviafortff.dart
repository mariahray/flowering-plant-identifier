import 'dart:math';
import 'package:flutter/material.dart';

class TFFTrivia extends StatefulWidget {
  @override
  _TriviaState createState() => _TriviaState();
}

class _TriviaState extends State<TFFTrivia> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final List<String> _triviaList = [
    "The Flower Farm began in 1983 as a gardening hobby of Ging de los Reyes.",
    "It transformed into a commercial enterprise and was incorporated in 1987.",
    "The Flower Farm is located in the picturesque Tagaytay City.",
    "It spans 7.2 hectares and supplies various local retailers, hotels, and florists.",
    "Over 40 varieties of chrysanthemums and 20 varieties of gerberas are cultivated.",
    "The flowers are grown in a wide range of colors including white, pink, red, and yellow.",
    "Anthuriums, amaryllis, asters, celosia, and sunflowers are also grown seasonally.",
    "The Flower Farm exports its flowers to locations like Guam and Japan.",
    "Fresh foliage, potted herbs, and ornamental plants are available alongside flowers.",
    "Customers receive first pick at the best blooms, ensuring guaranteed freshness."
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
                      "Hello, I am Fleur! Please tap me",
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
                        'assets/images/Fleur.png',
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
