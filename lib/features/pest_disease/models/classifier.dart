import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Result of a single classification from the model
class Category {
  final String label;
  final double score;

  Category(this.label, this.score);

  @override
  String toString() => 'Category(label: $label, score: $score)';
}

/// Abstract base class for TensorFlow Lite image classifiers
abstract class Classifier {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  final logger = Logger();
  late List<int> _inputShape;
  late List<int> _outputShape;
  final String _labelsFileName = 'assets/dict.txt';
  final int _labelsLength = 6;
  List<String> labels = [];

  String get modelName;

  Classifier({int numThreads = 1}) {
    _interpreterOptions = InterpreterOptions()..threads = numThreads;
    loadModel();
    loadLabels();
  }

  /// Load the TensorFlow Lite model from assets
  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(
        modelName,
        options: _interpreterOptions,
      );
      _inputShape = interpreter.getInputTensor(0).shape;
      _outputShape = interpreter.getOutputTensor(0).shape;
      logger.i('Model loaded successfully. Input shape: $_inputShape, Output shape: $_outputShape');
    } catch (e) {
      logger.e('Unable to create interpreter: $e');
    }
  }

  /// Load disease labels from assets
  Future<void> loadLabels() async {
    try {
      labels = await _loadLabelsFromAssets(_labelsFileName);
      if (labels.length == _labelsLength) {
        logger.i('Labels loaded successfully: $labels');
      } else {
        logger.w('Expected $_labelsLength labels, got ${labels.length}');
      }
    } catch (e) {
      logger.e('Unable to load labels: $e');
    }
  }

  /// Load labels from asset file
  Future<List<String>> _loadLabelsFromAssets(String filename) async {
    try {
      final labelTxt = await rootBundle.loadString(filename);
      return labelTxt
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
    } catch (e) {
      logger.e('Failed to load labels: $e');
      return [];
    }
  }

  /// Preprocess the input image - resize and normalize
  img.Image preprocessImage(img.Image image) {
    // Resize to input size (typically 224x224 for mobile nets)
    int targetHeight = _inputShape[1];
    int targetWidth = _inputShape[2];

    // Resize image to target dimensions
    img.Image resized = img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.linear,
    );

    return resized;
  }

  /// Convert image to input tensor format
  List<List<List<List<int>>>> imageToByteListMulChannel(img.Image image) {
    var convertedBytes = <List<List<List<int>>>>[];
    var rows = <List<List<int>>>[];

    for (int y = 0; y < image.height; y++) {
      var cols = <List<int>>[];
      for (int x = 0; x < image.width; x++) {
        var pixel = image.getPixelSafe(x, y);
        cols.add([pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()]);
      }
      rows.add(cols);
    }
    convertedBytes.add(rows);
    return convertedBytes;
  }

  /// Predict the disease category for the given image
  Category predict(img.Image image) {
    try {
      // Preprocess image
      img.Image processedImage = preprocessImage(image);
      List<List<List<List<int>>>> input = imageToByteListMulChannel(processedImage);

      // Prepare output buffer based on output shape
      var output = List<List<double>>.filled(
        _outputShape[0],
        List<double>.filled(_outputShape[1], 0.0),
      );

      // Run inference
      interpreter.run(input, output);

      // Find top prediction
      final predictions = output[0];
      int topIndex = 0;
      double topScore = predictions[0];

      for (int i = 1; i < predictions.length; i++) {
        if (predictions[i] > topScore) {
          topScore = predictions[i];
          topIndex = i;
        }
      }

      // Normalize score to 0-1 range if needed
      double normalizedScore = topScore;
      if (normalizedScore > 1.0) {
        normalizedScore = topScore / 255.0;
      }

      final label = labels.isNotEmpty && topIndex < labels.length
          ? labels[topIndex]
          : 'Unknown';

      logger.i(
          'Prediction: $label (${(normalizedScore * 100).toStringAsFixed(2)}%)');

      return Category(label, normalizedScore);
    } catch (e) {
      logger.e('Error during prediction: $e');
      return Category('Error', 0.0);
    }
  }

  /// Close the interpreter and free resources
  void close() {
    try {
      interpreter.close();
    } catch (e) {
      logger.e('Error closing interpreter: $e');
    }
  }
}
