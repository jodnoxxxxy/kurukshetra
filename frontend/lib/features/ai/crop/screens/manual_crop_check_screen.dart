import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/core/widgets/app_card.dart';
import 'package:kurukshetra/core/widgets/primary_button.dart';
import 'package:kurukshetra/core/widgets/section_header.dart';
import 'package:kurukshetra/features/ai/crop/repositories/crop_inspection_repository.dart';

class ManualCropCheckScreen extends ConsumerStatefulWidget {
  const ManualCropCheckScreen({
    super.key,
    this.fieldId,
    this.cropId,
  });

  final String? fieldId;
  final String? cropId;

  @override
  ConsumerState<ManualCropCheckScreen> createState() => _ManualCropCheckScreenState();
}

class _ManualCropCheckScreenState extends ConsumerState<ManualCropCheckScreen> {
  String? _healthStatus;
  String? _leafCondition;
  String? _soilCondition;
  String? _moistureLevel;

  final _fieldIdController = TextEditingController();
  final _cropIdController = TextEditingController();
  final _pestsController = TextEditingController();
  final _diseasesController = TextEditingController();
  final _issuesController = TextEditingController();
  final _recommendationController = TextEditingController();

  bool _wateringNeeded = false;
  bool _actionRequired = false;
  bool _isSaving = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fieldIdController.text = widget.fieldId ?? '';
    _cropIdController.text = widget.cropId ?? '';
  }

  @override
  void dispose() {
    _fieldIdController.dispose();
    _cropIdController.dispose();
    _pestsController.dispose();
    _diseasesController.dispose();
    _issuesController.dispose();
    _recommendationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return;
    setState(() => _imageFile = File(picked.path));
  }

  Future<void> _submit() async {
    final fieldId = _fieldIdController.text.trim();
    final cropId = _cropIdController.text.trim();

    if (fieldId.isEmpty || cropId.isEmpty || _healthStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field ID, Crop ID and Health Status are required')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(cropInspectionRepositoryProvider);
      await repo.createInspection(
        fieldId: fieldId,
        cropId: cropId,
        healthStatus: _healthStatus,
        pests: _pestsController.text.trim().isEmpty ? null : _pestsController.text.trim(),
        diseases: _diseasesController.text.trim().isEmpty ? null : _diseasesController.text.trim(),
        leafCondition: _leafCondition,
        soilCondition: _soilCondition,
        moistureLevel: _moistureLevel,
        wateringNeeded: _wateringNeeded,
        issues: _issuesController.text.trim().isEmpty ? null : _issuesController.text.trim(),
        recommendation: _recommendationController.text.trim().isEmpty ? null : _recommendationController.text.trim(),
        actionRequired: _actionRequired,
        imageUrl: _imageFile?.path,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Manual crop check saved successfully')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save inspection: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: const Text('Manual Crop Check'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(title: 'Farm Context', icon: Icons.agriculture),
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  TextField(
                    controller: _fieldIdController,
                    decoration: const InputDecoration(labelText: 'Field ID'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _cropIdController,
                    decoration: const InputDecoration(labelText: 'Crop ID'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Health Assessment', icon: Icons.monitor_heart),
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _healthStatus,
                    decoration: const InputDecoration(labelText: 'Health Status *'),
                    items: const [
                      DropdownMenuItem(value: 'HEALTHY', child: Text('Healthy')),
                      DropdownMenuItem(value: 'STRESSED', child: Text('Stressed')),
                      DropdownMenuItem(value: 'DISEASED', child: Text('Diseased')),
                      DropdownMenuItem(value: 'CRITICAL', child: Text('Critical')),
                    ],
                    onChanged: (v) => setState(() => _healthStatus = v),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _leafCondition,
                    decoration: const InputDecoration(labelText: 'Leaf Condition'),
                    items: const [
                      DropdownMenuItem(value: 'HEALTHY', child: Text('Healthy')),
                      DropdownMenuItem(value: 'YELLOWING', child: Text('Yellowing')),
                      DropdownMenuItem(value: 'WILTING', child: Text('Wilting')),
                      DropdownMenuItem(value: 'DAMAGED', child: Text('Damaged')),
                    ],
                    onChanged: (v) => setState(() => _leafCondition = v),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _soilCondition,
                    decoration: const InputDecoration(labelText: 'Soil Condition'),
                    items: const [
                      DropdownMenuItem(value: 'GOOD', child: Text('Good')),
                      DropdownMenuItem(value: 'AVERAGE', child: Text('Average')),
                      DropdownMenuItem(value: 'POOR', child: Text('Poor')),
                      DropdownMenuItem(value: 'WATERLOGGED', child: Text('Waterlogged')),
                      DropdownMenuItem(value: 'DRY', child: Text('Dry')),
                    ],
                    onChanged: (v) => setState(() => _soilCondition = v),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _moistureLevel,
                    decoration: const InputDecoration(labelText: 'Moisture Level'),
                    items: const [
                      DropdownMenuItem(value: 'WET', child: Text('Wet')),
                      DropdownMenuItem(value: 'ADEQUATE', child: Text('Adequate')),
                      DropdownMenuItem(value: 'DRY', child: Text('Dry')),
                      DropdownMenuItem(value: 'VERY_DRY', child: Text('Very Dry')),
                    ],
                    onChanged: (v) => setState(() => _moistureLevel = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Observations', icon: Icons.visibility),
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  TextField(
                    controller: _pestsController,
                    decoration: const InputDecoration(labelText: 'Observed Pests'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _diseasesController,
                    decoration: const InputDecoration(labelText: 'Observed Diseases'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _issuesController,
                    decoration: const InputDecoration(labelText: 'Issues Noticed'),
                    minLines: 2,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _recommendationController,
                    decoration: const InputDecoration(labelText: 'Recommended Action'),
                    minLines: 2,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _wateringNeeded,
              onChanged: (v) => setState(() => _wateringNeeded = v),
              title: const Text('Watering Needed'),
            ),
            SwitchListTile(
              value: _actionRequired,
              onChanged: (v) => setState(() => _actionRequired = v),
              title: const Text('Immediate Action Required'),
            ),
            const SizedBox(height: 10),
            AppCard(
              onTap: _pickImage,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _imageFile == null
                      ? const Icon(Icons.camera_alt, size: 28, color: AppColors.primaryGreen)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_imageFile!, height: 160, fit: BoxFit.cover),
                        ),
                  const SizedBox(height: 8),
                  Text(
                    _imageFile == null ? 'Tap to capture crop photo' : 'Photo attached',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              text: _isSaving ? 'Saving...' : 'Save Manual Check',
              isLoading: _isSaving,
              icon: Icons.check_circle,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}