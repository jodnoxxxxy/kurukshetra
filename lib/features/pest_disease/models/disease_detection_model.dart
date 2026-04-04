import 'classifier.dart';

/// Concrete implementation of the disease detection model
/// Uses TensorFlow Lite for plant disease classification
/// Trained on Google Cloud AutoML Vision with 6 disease categories:
/// - Corn Common Rust
/// - Corn Gray Leaf Spot
/// - Potato Early Blight
/// - Strawberry Leaf Scorch
/// - Tomato Leaf Mold
/// - Tomato Mosaic Virus
class DiseaseDetectionModel extends Classifier {
  DiseaseDetectionModel({int numThreads = 1}) : super(numThreads: numThreads);

  @override
  String get modelName => 'model.tflite';
}

