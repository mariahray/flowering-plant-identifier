import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'database_helper.dart';
import 'favorite.dart';
import 'flower_info.dart';
import 'tflite_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

Future<void> _checkPermissions() async {
  await Permission.camera.request();
  await Permission.storage.request();
}

class Capture extends StatefulWidget {
  @override
  _CaptureState createState() => _CaptureState();
}

class _CaptureState extends State<Capture> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  PlantClassifier? _classifier;
  bool _isClassifierReady = false;
  bool _isLoading = true;
  bool _isFlashOn = false;

  static const IconData cameraOutlined = IconData(
      0xef23, fontFamily: 'MaterialIcons');

  @override
  void initState() {
    super.initState();
    _checkPermissions().then((_) {
      _initializeCamera();
      _initializeClassifier();
    });
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller != null) {
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.off : FlashMode.torch,
      );
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    }
  }

  Future<void> _initializeClassifier() async {
    try {
      _classifier = PlantClassifier();
      await _classifier!.initialize();
      setState(() {
        _isClassifierReady = true;
        _isLoading = false;
      });
      print('Model and labels loaded successfully');
    } catch (e) {
      print('Error initializing classifier: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _takePicture() async {
    if (!_isClassifierReady) {
      _showErrorDialog('Error: Classifier not initialized');
      return;
    }

    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      final imageBytes = await image.readAsBytes();

      final predictions = await _classifier!.predict(
          Uint8List.fromList(imageBytes));

      if (predictions.isEmpty) {
        // No predictions were made
        _showNoMatchDialog();
      } else {
        final predictedFlowerName = predictions.keys.first;
        _showResultDialog(predictedFlowerName);
      }
    } catch (e) {
      print('Error taking picture or making prediction: $e');
      _showErrorDialog('Error: $e');
    }
  }

  void _showNoMatchDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 320,
            height: 262,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 282,
                    height: 262,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(99, 156, 101, 100),
                      border: Border.all(
                        color: Color.fromRGBO(26, 67, 28, 1),
                        width: 6,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 19,
                  left: 30,
                  child: Text(
                    'NO MATCH FOUND',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(246, 238, 238, 0.85),
                      fontFamily: 'Montserrat',
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Positioned(
                  top: 108,
                  left: 35,
                  child: Text(
                    'The captured image does not match any known flower.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Positioned(
                  top: 210,
                  left: 191,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CLOSE',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(246, 238, 238, 0.85),
                        fontFamily: 'Montserrat',
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
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

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      final predictions = await _classifier!.predict(
          Uint8List.fromList(imageBytes));
      final predictedFlowerName = predictions.keys.first;

      _showResultDialog(predictedFlowerName);
    }
  }

  void _showResultDialog(String predictedFlowerName) async {
    final dbHelper = DatabaseHelper();
    final flower = await dbHelper.getFullFlowerDetailsByName(predictedFlowerName);
    print("Fetched flower data: $flower");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 320,
            height: 262,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 282,
                    height: 262,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(99, 156, 101, 100),
                      border: Border.all(
                        color: Color.fromRGBO(26, 67, 28, 1),
                        width: 6,
                      ),



                    ),
                  ),
                ),
                Positioned(
                  top: 19,
                  left: 30,
                  child: Text(
                    'IDENTIFIED FLOWER',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(246, 238, 238, 0.85),
                      fontFamily: 'Montserrat',
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Positioned(
                  top: 210,
                  left: 191,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CLOSE',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(246, 238, 238, 0.85),
                        fontFamily: 'Montserrat',
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 108,
                  left: 35,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      if (flower != null) {
                        _navigateToFlowerDetail(flower);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'No information found for "$predictedFlowerName"'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 210,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                        color: Color.fromRGBO(139, 237, 154, 100),

                      ),
                      child: Text(
                        predictedFlowerName,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
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

  void _showTutorial() {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Image.asset(
              'assets/images/tt3.png',
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToFlowerDetail(Map<String, dynamic> flower) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FlowerDetail(
              flower: flower,
              isFavorite: FavoriteManager().isFavorite(flower['image']),
              onFavoriteChanged: (isFavorite) {
                setState(() {});
              },
            ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6EEEE),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: _controller == null || !_controller!.value.isInitialized
                ? CircularProgressIndicator()
                : Container(
              width: 325,
              height: 630,
              margin: EdgeInsets.only(top: 60),
              decoration: ShapeDecoration(
                color: Color(0xE5D9D9D9),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 3,
                    color: Colors.black.withOpacity(0.31),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/images/back-icon.png',
                width: 25,
                height: 40,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 15,
            child: IconButton(
              icon: Icon(Icons.info_outline, color: Colors.green),
              onPressed: _showTutorial,
            ),
          ),
          Positioned(
            bottom: 1,
            top:550,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 299,
                  height: 290,

                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/rectangle.png'),

                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/images/image-picker.png',
                          width: 50,
                          height: 50,
                        ),
                        onPressed: _pickImageFromGallery,
                        tooltip: 'Select from Gallery',
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/capture-icon.png',
                          width: 110,
                          height: 300,
                        ),
                        onPressed: _isClassifierReady ? _takePicture : null,
                      ),

                      SizedBox(width: 5),
                      IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          size: 50,
                          color: _isFlashOn ? Colors.green : Colors.grey,
                        ),
                        onPressed: _toggleFlash,
                        tooltip: 'Toggle Flash',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Positioned(
              top: 16,
              left: 16,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
        ],
      ),
    );
  }


}