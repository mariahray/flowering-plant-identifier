import 'package:flutter/material.dart';
import 'package:newpa/trivia2.0.dart';
import 'package:newpa/triviafortff.dart';

class TriviaIntroScreen extends StatelessWidget {
  final List<Map<String, dynamic>> triviaOptions = [
    {
      'title': 'CHRYSANTHEMUM',
      'color': Color.fromRGBO(67, 129, 71, 0.7),
      'image': 'assets/images/Flor.png',
      'screen': Trivia(),
    },
    {
      'title': 'THE FLOWER FARM',
      'color': Color.fromRGBO(67, 129, 71, 0.7),
      'image': 'assets/images/Fleur.png',
      'screen': TFFTrivia(),
    },
  ];

  void _showTutorial(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Stack(
            children: [
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
              Center(
                child: Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tt4.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: Container(
                    width: 24.8,
                    height: 39,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/back-icon.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => _showTutorial(context),
                  child: Icon(
                    Icons.info_outline,
                    size: 30,
                    color: Color.fromRGBO(67, 129, 71, 0.9),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 60,
                child: Text(
                  'TRIVIA ABOUT:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(55, 101, 58, 0.91),
                    fontFamily: 'Mazzard',
                    fontSize: 35,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
              ...List.generate(triviaOptions.length, (index) {
                final option = triviaOptions[index];
                return Positioned(
                  top: 260 + (index * 185),
                  left: 25,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => option['screen']),
                      );
                    },
                    child: Container(
                      width: 295,
                      height: 142,
                      decoration: BoxDecoration(
                        color: option['color'],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              width: 98,
                              height: 96,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(option['image']),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 130,
                            child: Text(
                              option['title'],
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Mazzard-Medium',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
