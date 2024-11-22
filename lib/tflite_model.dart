import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image/image.dart' as img;

class PlantClassifier {
  List<String>? _labels;
  bool _isInitialized = false;

  PlantClassifier();

  Future<void> loadModel() async {
    try {
      print('Loading model...');
      // Load the model and labels
      await Tflite.loadModel(
        model: 'assets/models/model_unquant.tflite',
        labels: 'assets/models/labels.txt',
      );
      print('Model loaded successfully');

      // Load labels from the labels file
      final labelsData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelsData
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty) // Filter out empty lines
          .toList();

      if (_labels != null && _labels!.isNotEmpty) {
        print('Labels loaded successfully');
        print('Loaded ${_labels!.length} labels.');
        _isInitialized = true;  // Set initialized to true after both model and labels are loaded
      } else {
        throw Exception('Labels are not properly loaded');
      }
    } catch (e) {
      print('Error loading model or labels: $e');
      _isInitialized = false; // Ensure this is false on error
    }
  }

  Future<void> initialize() async {
    await loadModel(); // Load the model
  }

Future<Map<String, double>> predict(Uint8List imageBytes) async {
  if (!_isInitialized) {
    print('Prediction attempted before model initialization');
    throw StateError('Model or labels are not initialized.');
  }

  try {
    // Process the image to get Float32List format for the model
    final imageTensor = _processImage(imageBytes);

    // Run the model and get the predictions using runModelOnBinary
    var output = await Tflite.runModelOnBinary(
      binary: imageTensor,
      numResults: 1, // Limit results to 1
      threshold: 0.3, // Adjust confidence threshold
    );

    if (output == null || output.isEmpty) {
      print('No result returned from model. Try capturing the flower at a different angle or distance.');
      return {}; // Return an empty map to indicate no prediction
    }

    // Map the results to the labels and filter by confidence threshold
    final Map<String, double> predictions = {};
    final highestPrediction = output[0]; // The first result is the highest due to numResults: 1
    final label = highestPrediction['label'];
    final confidence = highestPrediction['confidence'];

    // Set your minimum confidence threshold
    const double minConfidenceThreshold = 0.1; // Adjust this value as needed

    if (confidence >= minConfidenceThreshold) {
      predictions[label] = confidence; // Only include if confidence is above threshold
    } else {
      print('Prediction confidence $confidence for "$label" is below threshold.');
    }

    return predictions;
  } catch (e) {
    print('Error during prediction: $e');
    return {};
  }
}


  Uint8List _processImage(Uint8List imageBytes) {
    // Decode the image using the image package
    final image = img.decodeImage(imageBytes)!;

    // Center crop the image and resize it to the model input size (typically 224x224)
    final int shortestSide = image.width < image.height ? image.width : image.height;
    final centerCrop = img.copyCrop(image,
                                  (image.width - shortestSide) ~/ 2,
                                  (image.height - shortestSide) ~/ 2,
                                  shortestSide,
                                  shortestSide);

    // Resize the image to 224x224 (or the size required by the model)
    final resizedImage = img.copyResize(centerCrop, width: 224, height: 224);

    // Convert the resized image to float32 and normalize the values between 0 and 1
    List<double> float32List = [];

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y);

        // Extract RGB values from the pixel and normalize them
        final r = (img.getRed(pixel) - 127.5) / 127.5;
        final g = (img.getGreen(pixel) - 127.5) / 127.5;
        final b = (img.getBlue(pixel) - 127.5) / 127.5;

        // Add normalized RGB values to the list
        float32List.addAll([r, g, b]);
      }
    }

    // Convert List<double> to Float32List and return as Uint8List
    return Float32List.fromList(float32List).buffer.asUint8List();
  }

  void dispose() {
    Tflite.close();
  }
}
