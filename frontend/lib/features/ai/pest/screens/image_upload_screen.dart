import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import '../providers/pest_provider.dart';

class ImageUploadScreen extends ConsumerStatefulWidget {
  final String source;

  const ImageUploadScreen({super.key, required this.source});

  @override
  ConsumerState<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends ConsumerState<ImageUploadScreen> {
  File? _image;
  Uint8List? _imageBytes;
  bool _isAnalyzing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickImage();
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: widget.source == 'camera' ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        if (mounted) setState(() => _imageBytes = bytes);
      } else {
        if (mounted) setState(() => _image = File(pickedFile.path));
      }
    } else {
      if (mounted) context.pop();
    }
  }

  Future<void> _analyzeImage() async {
    if (kIsWeb && _imageBytes == null) return;
    if (!kIsWeb && _image == null) return;
    setState(() => _isAnalyzing = true);
    try {
      final api = ref.read(pestRepositoryProvider);
      final imagePath = kIsWeb ? '' : _image!.path;
      final response = await api.detectPest(imagePath);
      if (!mounted) return;
      if (response.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.error!)));
        return;
      }
      ref.read(currentDetectionProvider.notifier).setResult(response.data!);
      context.pushReplacement('/pest-detection/result');
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: Text(l10n.cropImage, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if ((kIsWeb && _imageBytes != null) || (!kIsWeb && _image != null))
                      kIsWeb && _imageBytes != null
                          ? Image.memory(_imageBytes!, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                          : Image.file(_image!, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_search_rounded, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(l10n.waitingForImage, style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    if (_isAnalyzing)
                      Container(
                        color: Colors.black54,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(color: Colors.white),
                            const SizedBox(height: 24),
                            Text(l10n.aiAnalyzing.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2)),
                            const SizedBox(height: 8),
                            const Text('Deep Vision Analysis in progress...', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 60),
            child: Column(
              children: [
                if (((kIsWeb && _imageBytes != null) || (!kIsWeb && _image != null)) && !_isAnalyzing)
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _analyzeImage,
                      icon: const Icon(Icons.psychology_rounded),
                      label: Text(l10n.analyzeWithAI.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        shadowColor: AppColors.primaryGreen.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                if (((kIsWeb && _imageBytes != null) || (!kIsWeb && _image != null)) && !_isAnalyzing)
                  const SizedBox(height: 16),
                if (!_isAnalyzing)
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text('RETAKE PHOTO', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.shade600, fontSize: 12, letterSpacing: 1)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
