import 'package:flutter/foundation.dart';

/// Model to track disease diagnosis results from the TensorFlow Lite model
/// Implements ChangeNotifier for state management with Provider
class Diagnosis extends ChangeNotifier {
  String? _disease;
  String? _confidence;

  String? get disease => _disease;
  String? get confidence => _confidence;

  /// Update the diagnosis result
  /// [disease] - The detected disease name
  /// [confidence] - The confidence score as a percentage string (e.g., "95.23")
  void update(String disease, String? confidence) {
    _disease = disease.toUpperCase();
    _confidence = confidence;
    notifyListeners();
  }

  /// Reset diagnosis
  void reset() {
    _disease = null;
    _confidence = null;
    notifyListeners();
  }

  /// Check if diagnosis is healthy (confidence is null)
  bool get isHealthy => _confidence == null;
}
