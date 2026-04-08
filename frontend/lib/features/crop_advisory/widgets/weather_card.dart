import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData;
  final bool isLoading;

  const WeatherCard({super.key, this.weatherData, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (weatherData == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('Weather data not available. Please fetch location.'),
      );
    }

    final temp = weatherData!['main']['temp'];
    final condition = weatherData!['weather'][0]['main'];
    final city = weatherData!['name'];

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.7),
                Colors.lightBlueAccent.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Current Weather',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const FaIcon(FontAwesomeIcons.cloudSun, color: Colors.white, size: 40),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '${temp.toStringAsFixed(1)}°C',
                    style: GoogleFonts.outfit(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    condition,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
