import 'package:flutter/material.dart';

class GrowthStep {
  final String title;
  final String description;
  final Duration duration;
  final IconData icon;

  const GrowthStep({
    required this.title,
    required this.description,
    required this.duration,
    required this.icon,
  });
}
