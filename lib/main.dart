import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'catalog.dart';
import 'bookmark.dart';
import 'capture.dart';
import 'about.dart';
import 'trivia.dart';
import 'tutorial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: SplashScreen(),
      routes: {
        '/home': (context) => MainMenu(),
        '/capture': (context) => Capture(),
        '/catalog': (context) => Catalog(),
        '/bookmark': (context) => Bookmark(),
        '/trivia': (context) => TriviaIntroScreen(),
        '/about': (context) => About(),
        '/tutorial': (context) => Tutorial(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/home');
        },
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Image.asset(
                'assets/images/tff.png',
                width: screenWidth * 0.74,
                height: screenHeight * 0.33,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _refreshMainMenu() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 322,
            height: 150,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 280,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(135, 194, 138, 0.91),
                      border: Border.all(
                        color: Color.fromRGBO(26, 67, 28, 1),
                        width: 5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 19,
                  child: Text(
                    'Would you like to exit the app?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(246, 238, 238, 0.85),
                      fontFamily: "Mazzard-Bold",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CANCEL',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(246, 238, 238, 0.85),
                        fontFamily: 'Mazzard',
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 220,
                  child: GestureDetector(
                    onTap: () {
                      SystemNavigator.pop();
                    },
                    child: Text(
                      'YES',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(246, 238, 238, 0.85),
                        fontFamily: 'Mazzard',
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCustomButton(String text, String route, double topOffset, String iconPath, {VoidCallback? onTap}) {
    return Positioned(
      top: MediaQuery.of(context).size.height * topOffset,
      left: (MediaQuery.of(context).size.width - 230) / 2,
      child: MouseRegion(
        onEnter: (_) => _buttonController.forward(),
        onExit: (_) => _buttonController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: 230,
            height: 57,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(67, 129, 71, 0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: Colors.black.withOpacity(0.90),
                elevation: 6,
              ),
              onPressed: onTap ?? () {
                Navigator.pushNamed(context, route);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    iconPath,
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(width: 5),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Mazzard',
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                      height: 1,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 1,
                bottom: 1,
                left: 0,
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.95,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/homepage-bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.03,
                left: (screenWidth - (screenWidth * 0.6)) / 2,
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/tfff1.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
              buildCustomButton('CAPTURE', '/capture', 0.35, 'assets/images/camera-icon.png'),
              buildCustomButton('CATALOG', '/catalog', 0.46, 'assets/images/catalog-icon.png'),
              buildCustomButton('BOOKMARK', '/bookmark', 0.57, 'assets/images/bookmark-icon.png'),
              buildCustomButton('TRIVIA', '/trivia', 0.68, 'assets/images/trivia-icon.png'),
              buildCustomButton('ABOUT', '/about', 0.79, 'assets/images/about-icon.png'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showExitConfirmationDialog(context);
        },
        child: Icon(Icons.exit_to_app),
        backgroundColor: Color.fromRGBO(67, 129, 71, 0.7),
      ),
    );
  }
}
