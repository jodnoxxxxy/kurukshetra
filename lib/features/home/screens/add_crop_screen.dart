import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/home/models/crop.dart';
import 'package:kurukshetra/features/home/providers/crop_provider.dart';

class AddCropScreen extends ConsumerStatefulWidget {
  final Crop? crop;

  const AddCropScreen({super.key, this.crop});

  @override
  ConsumerState<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends ConsumerState<AddCropScreen> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  
  String? _selectedCrop;
  DateTime _sowingDate = DateTime.now();
  bool _isLoading = false;

  final List<Map<String, String>> availableCrops = [
    {'name': 'Wheat', 'icon': '🌾'},
    {'name': 'Rice', 'icon': '🌾'},
    {'name': 'Soybean', 'icon': '🫘'},
    {'name': 'Cotton', 'icon': '🌿'},
    {'name': 'Sugarcane', 'icon': '🎋'},
    {'name': 'Maize', 'icon': '🌽'},
    {'name': 'Ragi', 'icon': '🌱'},
    {'name': 'Bajra', 'icon': '🌾'},
    {'name': 'Jowar', 'icon': '🌾'},
    {'name': 'Pulses', 'icon': '🫘'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.crop != null) {
      _initializeFields();
    }
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  void _initializeFields() {
    final crop = widget.crop!;
    _selectedCrop = crop.name;
    _areaController.text = crop.area.toString();
    _sowingDate = crop.sowingDate;
  }

  Future<void> _saveCrop() async {
    if (!_formKey.currentState!.validate() || _selectedCrop == null) return;

    setState(() => _isLoading = true);

    try {
      final selectedCropData = availableCrops.firstWhere((c) => c['name'] == _selectedCrop);

      if (widget.crop == null) {
        // Add to myCropProvider (home screen My Crops list)
        await ref.read(myCropProvider.notifier).addCrop(_selectedCrop!, _sowingDate);
        // Add to detailed cropProvider as well
        await ref.read(cropProvider.notifier).addCrop(
          name: _selectedCrop!,
          icon: selectedCropData['icon']!,
          sowingDate: _sowingDate,
          area: double.parse(_areaController.text),
        );
      } else {
        // Update existing crop in detailed cropProvider
        final updatedCrop = widget.crop!.copyWith(
          name: _selectedCrop!,
          icon: selectedCropData['icon']!,
          sowingDate: _sowingDate,
          area: double.parse(_areaController.text),
        );
        await ref.read(cropProvider.notifier).updateCrop(updatedCrop);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.crop == null
                ? 'Crop added successfully!'
                : 'Crop updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save crop: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crop == null ? 'Add Crop' : 'Edit Crop'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crop Selection
              const Text(
                'Select Crop',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildCropSelection(),
              
              const SizedBox(height: 24),
              
              // Sowing Date
              const Text(
                'Sowing Date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDateSelector(),
              
              const SizedBox(height: 24),
              
              // Area
              const Text(
                'Farm Area',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(
                  labelText: 'Area in Acres',
                  prefixIcon: const Icon(Icons.agriculture),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixText: 'Acres',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter area';
                  }
                  final area = double.tryParse(value);
                  if (area == null || area <= 0) {
                    return 'Please enter a valid area';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCrop,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.crop == null ? 'Add Crop' : 'Update Crop',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropSelection() {
    return SizedBox(
      height: 120,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: availableCrops.length,
        itemBuilder: (context, index) {
          final crop = availableCrops[index];
          final isSelected = _selectedCrop == crop['name'];
          
          return InkWell(
            onTap: () => setState(() => _selectedCrop = crop['name']),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.1) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    crop['icon']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    crop['name']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primaryGreen : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sowing Date',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${_sowingDate.day}/${_sowingDate.month}/${_sowingDate.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _sowingDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _sowingDate) {
      setState(() {
        _sowingDate = picked;
      });
    }
  }
}
