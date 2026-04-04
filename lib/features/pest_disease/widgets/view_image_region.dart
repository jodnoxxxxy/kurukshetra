import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../models/classifier.dart';
import '../models/diagnosis.dart';
import '../models/disease_detection_model.dart';

/// Widget for capturing and processing plant images for disease detection
/// Allows users to pick images from camera or gallery, crop them, and run predictions
class ViewImageRegion extends StatefulWidget {
  final Diagnosis diagnosis;
  final VoidCallback? onPredictionComplete;

  const ViewImageRegion({
    Key? key,
    required this.diagnosis,
    this.onPredictionComplete,
  }) : super(key: key);

  @override
  State<ViewImageRegion> createState() => _ViewImageRegionState();
}

class _ViewImageRegionState extends State<ViewImageRegion> {
  File? plantImage;
  late Classifier _classifier;
  final logger = Logger();
  Category? _category;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _classifier = DiseaseDetectionModel();
  }

  @override
  void dispose() {
    _classifier.close();
    super.dispose();
  }

  /// Handle image selection from camera or gallery
  void _onImageButtonPressed(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) return;

      if (kIsWeb) {
        // On web, read bytes directly from XFile
        final bytes = await pickedFile.readAsBytes();
        if (mounted) {
          setState(() {
            _imageBytes = bytes;
            plantImage = null; // Clear file reference on web
          });
        }
        await _predictFromBytes(bytes);
        widget.onPredictionComplete?.call();
      } else {
        // On mobile, use image cropper
        final File imageFile = File(pickedFile.path);

        // Crop the image
        final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.green[700],
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
          ],
        );

        if (croppedFile != null) {
          if (mounted) {
            setState(() {
              plantImage = File(croppedFile.path);
              _imageBytes = null; // Clear bytes reference on mobile
            });
          }
          await _predict(plantImage!);
          widget.onPredictionComplete?.call();
        }
      }
    } catch (e) {
      logger.e('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  /// Predict disease from the plant image
  /// Predict disease from image bytes (web)
  Future<void> _predictFromBytes(Uint8List imageBytes) async {
    try {
      img.Image? imageInput = img.decodeImage(imageBytes);

      if (imageInput == null) {
        logger.e('Failed to decode image');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to decode image')),
          );
        }
        return;
      }

      var prediction = _classifier.predict(imageInput);

      if (mounted) {
        setState(() {
          _category = prediction;
        });
      }

      // Update diagnosis based on confidence threshold
      if (_category!.score > 0.5) {
        widget.diagnosis.update(
          _category!.label,
          (_category!.score * 100).toStringAsFixed(2),
        );
      } else {
        widget.diagnosis.update('Healthy', null);
      }

      logger.i('Prediction: ${_category!.label} (${_category!.score})');
    } catch (e) {
      logger.e('Error during prediction: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prediction error: $e')),
        );
      }
    }
  }

  /// Predict disease from the plant image (mobile)
  Future<void> _predict(File image) async {
    try {
      late final Uint8List bytes;
      
      try {
        bytes = image.readAsBytesSync();
      } catch (e) {
        // On web, file operations might fail differently
        logger.w('Could not read file bytes directly: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image format not supported for analysis')),
          );
        }
        return;
      }

      img.Image? imageInput = img.decodeImage(bytes);
      
      if (imageInput == null) {
        logger.e('Failed to decode image');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to decode image')),
          );
        }
        return;
      }

      var prediction = _classifier.predict(imageInput);

      if (mounted) {
        setState(() {
          _category = prediction;
        });
      }

      // Update diagnosis based on confidence threshold
      if (_category!.score > 0.5) {
        widget.diagnosis.update(
          _category!.label,
          (_category!.score * 100).toStringAsFixed(2),
        );
      } else {
        widget.diagnosis.update('Healthy', null);
      }

      logger.i('Prediction: ${_category!.label} (${_category!.score})');
    } catch (e) {
      logger.e('Error during prediction: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prediction error: $e')),
        );
      }
    }
  }

  /// Clear the selected image
  void _cancelImage() {
    setState(() {
      plantImage = null;
      _imageBytes = null;
      _category = null;
    });
    widget.diagnosis.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Image Display Area
          Container(
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: Center(
              child: (kIsWeb && _imageBytes == null) || (!kIsWeb && plantImage == null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No image selected',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: kIsWeb && _imageBytes != null
                          ? Image.memory(
                              _imageBytes!,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              plantImage!,
                              fit: BoxFit.cover,
                            ),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // Prediction Result Display
          if (_category != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _category!.score > 0.5
                    ? Colors.red[50]
                    : Colors.green[50],
                border: Border.all(
                  color: _category!.score > 0.5
                      ? Colors.red[300]!
                      : Colors.green[300]!,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Disease: ${_category!.label}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _category!.score > 0.5
                          ? Colors.red[900]
                          : Colors.green[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Confidence: ${(_category!.score * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: _category!.score > 0.5
                          ? Colors.red[700]
                          : Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () => _onImageButtonPressed(ImageSource.camera),
              ),
              _buildActionButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () => _onImageButtonPressed(ImageSource.gallery),
              ),
              _buildActionButton(
                icon: Icons.clear,
                label: 'Clear',
                onTap: _cancelImage,
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDestructive ? Colors.red[100] : Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDestructive ? Colors.red[700] : Colors.green[700],
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDestructive ? Colors.red[700] : Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
