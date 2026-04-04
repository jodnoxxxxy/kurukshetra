import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import '../providers/soil_provider.dart';
import '../models/soil_model.dart';

class SoilInputScreen extends ConsumerStatefulWidget {
  const SoilInputScreen({super.key});

  @override
  ConsumerState<SoilInputScreen> createState() => _SoilInputScreenState();
}

class _SoilInputScreenState extends ConsumerState<SoilInputScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nController = TextEditingController();
  final _pController = TextEditingController();
  final _kController = TextEditingController();
  final _phController = TextEditingController();
  final _carbonController = TextEditingController();

  bool _isAnalyzing = false;

  @override
  void dispose() {
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _phController.dispose();
    _carbonController.dispose();
    super.dispose();
  }

  Future<void> _analyzeSoil() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isAnalyzing = true);

      final input = SoilNutrientInput(
        nitrogen: double.parse(_nController.text),
        phosphorus: double.parse(_pController.text),
        potassium: double.parse(_kController.text),
        phLevel: double.parse(_phController.text),
        organicCarbon: double.parse(_carbonController.text),
      );

      ref.read(currentSoilInputProvider.notifier).setInput(input);
      
      final response = await ref.read(soilRepositoryProvider).analyzeSoil(input);
      if (!mounted) return;
      
      setState(() => _isAnalyzing = false);
      
      if (response.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.error!),
            backgroundColor: Colors.red,
        ));
        return;
      }
      
      ref.read(currentSoilAnalysisProvider.notifier).setAnalysis(response.data!);
      context.push('/soil-health/analysis');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.soilHealthCard, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.enterSoilTestReport,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.soilInputInstruction,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 24),

              _buildNutrientInput(l10n.nitrogenLabel, _nController, l10n.kgHa, Colors.green),
              const SizedBox(height: 16),
              _buildNutrientInput(l10n.phosphorusLabel, _pController, l10n.kgHa, Colors.orange),
              const SizedBox(height: 16),
              _buildNutrientInput(l10n.potassiumLabel, _kController, l10n.kgHa, Colors.red),
              const SizedBox(height: 16),
              _buildNutrientInput(l10n.phLevelLabel, _phController, 'pH', Colors.blue),
              const SizedBox(height: 16),
              _buildNutrientInput(l10n.organicCarbonLabel, _carbonController, '%', Colors.brown),

              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeSoil,
                icon: _isAnalyzing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.analytics),
                label: Text(_isAnalyzing ? l10n.analyzingSoil : l10n.analyzeSoilData),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  disabledBackgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientInput(String label, TextEditingController controller, String suffix, Color stripColor) {
    final l10n = AppLocalizations.of(context)!;
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
              color: stripColor.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                  suffixText: suffix,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || value.isEmpty ? l10n.required : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
