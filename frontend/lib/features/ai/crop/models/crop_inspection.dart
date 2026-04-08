import 'package:flutter/material.dart' show Color;
import 'package:intl/intl.dart';

class CropInspection {
  final String id;
  final String fieldId;
  final String cropId;
  final String? healthStatus; // HEALTHY, STRESSED, DISEASED, CRITICAL
  final String? pests;
  final String? diseases;
  final String? leafCondition; // HEALTHY, YELLOWING, WILTING, DAMAGED, OTHER
  final String? soilCondition; // GOOD, AVERAGE, POOR, WATERLOGGED, DRY
  final double? cropHeight; // cm
  final String? leafColor; // GREEN, PALE_GREEN, YELLOW, RED, BROWN
  final String? moistureLevel; // WET, ADEQUATE, DRY, VERY_DRY
  final bool wateringNeeded;
  final String? issues;
  final String? recommendation;
  final bool actionRequired;
  final String? riskLevel; // LOW, MEDIUM, HIGH, CRITICAL
  final String? imageUrl;
  final String? inspectedBy;
  final String? notes;
  final DateTime inspectedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  CropInspection({
    required this.id,
    required this.fieldId,
    required this.cropId,
    this.healthStatus,
    this.pests,
    this.diseases,
    this.leafCondition,
    this.soilCondition,
    this.cropHeight,
    this.leafColor,
    this.moistureLevel,
    this.wateringNeeded = false,
    this.issues,
    this.recommendation,
    this.actionRequired = false,
    this.riskLevel,
    this.imageUrl,
    this.inspectedBy,
    this.notes,
    required this.inspectedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CropInspection.fromJson(Map<String, dynamic> json) {
    return CropInspection(
      id: json['id'] ?? '',
      fieldId: json['fieldId'] ?? '',
      cropId: json['cropId'] ?? '',
      healthStatus: json['healthStatus'],
      pests: json['pests'],
      diseases: json['diseases'],
      leafCondition: json['leafCondition'],
      soilCondition: json['soilCondition'],
      cropHeight: json['cropHeight'] != null ? double.parse(json['cropHeight'].toString()) : null,
      leafColor: json['leafColor'],
      moistureLevel: json['moistureLevel'],
      wateringNeeded: json['wateringNeeded'] ?? false,
      issues: json['issues'],
      recommendation: json['recommendation'],
      actionRequired: json['actionRequired'] ?? false,
      riskLevel: json['riskLevel'],
      imageUrl: json['imageUrl'],
      inspectedBy: json['inspectedBy'],
      notes: json['notes'],
      inspectedAt: DateTime.parse(json['inspectedAt'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fieldId': fieldId,
      'cropId': cropId,
      'healthStatus': healthStatus,
      'pests': pests,
      'diseases': diseases,
      'leafCondition': leafCondition,
      'soilCondition': soilCondition,
      'cropHeight': cropHeight,
      'leafColor': leafColor,
      'moistureLevel': moistureLevel,
      'wateringNeeded': wateringNeeded,
      'issues': issues,
      'recommendation': recommendation,
      'actionRequired': actionRequired,
      'riskLevel': riskLevel,
      'imageUrl': imageUrl,
      'inspectedBy': inspectedBy,
      'notes': notes,
      'inspectedAt': inspectedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String getHealthStatusLabel() {
    switch (healthStatus) {
      case 'HEALTHY':
        return '🌱 Healthy';
      case 'STRESSED':
        return '⚠️ Stressed';
      case 'DISEASED':
        return '🦠 Diseased';
      case 'CRITICAL':
        return '🚨 Critical';
      default:
        return 'Unknown';
    }
  }

  String getRiskLevelLabel() {
    switch (riskLevel) {
      case 'LOW':
        return 'Low Risk';
      case 'MEDIUM':
        return 'Medium Risk';
      case 'HIGH':
        return 'High Risk';
      case 'CRITICAL':
        return 'Critical Risk';
      default:
        return 'Unknown';
    }
  }

  Color getRiskLevelColor() {
    switch (riskLevel) {
      case 'LOW':
        return const Color(0xFF4CAF50);
      case 'MEDIUM':
        return const Color(0xFFFFC107);
      case 'HIGH':
        return const Color(0xFFFF9800);
      case 'CRITICAL':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String getFormattedInspectionDate() {
    return DateFormat('MMM d, yyyy - h:mm a').format(inspectedAt);
  }
}
