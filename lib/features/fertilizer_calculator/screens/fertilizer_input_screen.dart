import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../models/soil_model.dart';
import '../providers/fertilizer_provider.dart';

import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';

class FertilizerInputScreen extends ConsumerStatefulWidget {
  const FertilizerInputScreen({super.key});

  @override
  ConsumerState<FertilizerInputScreen> createState() => _FertilizerInputScreenState();
}

class _FertilizerInputScreenState extends ConsumerState<FertilizerInputScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _selectedCrop = 'Ragi';
  /// Internal keys for crops, mapping to L10n keys
  final _crops = ['Ragi', 'Wheat', 'Paddy', 'Soybean', 'Maize', 'Sugarcane'];
  
  String _areaUnit = 'Acre';
  final _units = ['Acre', 'Hectare'];

  final _areaController = TextEditingController(text: '1');
  final _nController = TextEditingController();
  final _pController = TextEditingController();
  final _kController = TextEditingController();

  @override
  void dispose() {
    _areaController.dispose();
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    super.dispose();
  }

  void _calculateFertilizer() {
    if (_formKey.currentState!.validate()) {
      final data = SoilData(
        crop: _selectedCrop,
        area: double.parse(_areaController.text),
        unit: _areaUnit,
        nitrogen: double.parse(_nController.text),
        phosphorus: double.parse(_pController.text),
        potassium: double.parse(_kController.text),
      );

      ref.read(currentSoilDataProvider.notifier).setSoilData(data);
      context.push('/fertilizer-result');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.fertilizerCalculatorTitle),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle(l10n.farmingDetails),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCrop,
                decoration: InputDecoration(
                  labelText: l10n.selectCropLabel,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.grass, color: AppColors.primaryGreen),
                ),
                items: _crops.map((String crop) {
                  return DropdownMenuItem(
                    value: crop, 
                    child: Text(L10nUtils.translateCrop(context, crop.toLowerCase())),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedCrop = newValue);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _areaController,
                      decoration: InputDecoration(
                        labelText: l10n.landArea,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.landscape, color: Colors.blueGrey),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => value == null || value.isEmpty ? l10n.requiredField : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      initialValue: _areaUnit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _units.map((String unit) {
                        return DropdownMenuItem(
                          value: unit, 
                          child: Text(unit == 'Acre' ? l10n.unitAcre : l10n.unitHectare),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => _areaUnit = newValue);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(l10n.soilHealthDataNpk),
              const SizedBox(height: 8),
              Text(
                l10n.soilHealthDataInstruction,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 16),
              
              _buildNutrientInput(l10n.nitrogenLabelKgHa, _nController, Colors.green, l10n.requiredField),
              const SizedBox(height: 16),
              _buildNutrientInput(l10n.phosphorusLabelKgHa, _pController, Colors.orange, l10n.requiredField),
              const SizedBox(height: 16),
              _buildNutrientInput(l10n.potassiumLabelKgHa, _kController, Colors.red, l10n.requiredField),
              
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _calculateFertilizer,
                icon: const Icon(Icons.calculate),
                label: Text(l10n.calculateFertilizer),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildNutrientInput(String label, TextEditingController controller, Color stripColor, String requiredMsg) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 60,
            decoration: BoxDecoration(
              color: stripColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                  suffixText: 'kg/ha',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || value.isEmpty ? requiredMsg : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
