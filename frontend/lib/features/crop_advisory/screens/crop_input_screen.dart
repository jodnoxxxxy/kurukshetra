import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../models/soil_data.dart';
import '../providers/crop_advisory_provider.dart';
import '../widgets/weather_card.dart';

class CropInputScreen extends ConsumerWidget {
  const CropInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cropAdvisoryProvider);
    final notifier = ref.read(cropAdvisoryProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        title: Text(
          'Crop Advisory',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Smart Recommendations',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D5A27),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Fill in the details below to find the best crops for your farm.',
              style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            WeatherCard(
              weatherData: state.weatherData,
              isLoading: state.isLoading,
            ),
            const SizedBox(height: 16),
            if (state.weatherData == null && !state.isLoading)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => notifier.fetchLocationAndWeather(),
                  icon: const Icon(Icons.my_location),
                  label: const Text('Fetch Location & Weather'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleArray(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            _buildSectionTitle('Soil Type'),
            const SizedBox(height: 12),
            _buildSoilDropdown(state, notifier),
            const SizedBox(height: 24),
            _buildSectionTitle('Water Availability'),
            const SizedBox(height: 12),
            _buildWaterSelection(state, notifier),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : () async {
                  await notifier.generateRecommendations();
                  if (state.selectedSoil != null && state.selectedWater != null) {
                    context.push('/crop-advisory-new/recommendations');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5A27),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Analyze & Recommend',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSoilDropdown(CropAdvisoryState state, CropAdvisoryNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SoilType>(
          value: state.selectedSoil,
          hint: const Text('Select Soil Type'),
          isExpanded: true,
          onChanged: (SoilType? value) {
            if (value != null) notifier.setSoilType(value);
          },
          items: SoilType.values.map((SoilType type) {
            return DropdownMenuItem<SoilType>(
              value: type,
              child: Text(type.label),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildWaterSelection(CropAdvisoryState state, CropAdvisoryNotifier notifier) {
    return Row(
      children: WaterAvailability.values.map((availability) {
        final isSelected = state.selectedWater == availability;
        return Expanded(
          child: GestureDetector(
            onTap: () => notifier.setWaterAvailability(availability),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2D5A27) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2D5A27) : Colors.grey[300]!,
                ),
              ),
              child: Center(
                child: Text(
                  availability.label,
                  style: GoogleFonts.outfit(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Fixed RoundedRectangleArray typo from snippet
class RoundedRectangleArray extends RoundedRectangleBorder {
  const RoundedRectangleArray({super.borderRadius});
}
