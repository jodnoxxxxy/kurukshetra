import 'package:flutter/material.dart';

class Crop {
  final String id;
  final String name;
  final String icon;
  final DateTime sowingDate;
  final DateTime? expectedHarvestDate;
  final String status; // 'growing', 'ready', 'harvested'
  final double area;
  final String areaUnit;
  final List<String> notes;
  final String? imageUrl;

  Crop({
    required this.id,
    required this.name,
    required this.icon,
    required this.sowingDate,
    this.expectedHarvestDate,
    this.status = 'growing',
    required this.area,
    this.areaUnit = 'Acres',
    this.notes = const [],
    this.imageUrl,
  });

  Crop copyWith({
    String? id,
    String? name,
    String? icon,
    DateTime? sowingDate,
    DateTime? expectedHarvestDate,
    String? status,
    double? area,
    String? areaUnit,
    List<String>? notes,
    String? imageUrl,
  }) {
    return Crop(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      sowingDate: sowingDate ?? this.sowingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      status: status ?? this.status,
      area: area ?? this.area,
      areaUnit: areaUnit ?? this.areaUnit,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  int get daysSinceSowing => DateTime.now().difference(sowingDate).inDays;
  
  String get daysSinceSowingText {
    final days = daysSinceSowing;
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days < 7) return '$days days ago';
    if (days < 30) return '${(days / 7).floor()} weeks ago';
    return '${(days / 30).floor()} months ago';
  }

  String get statusDisplay {
    switch (status) {
      case 'growing':
        return '🌱 Growing';
      case 'ready':
        return '🌾 Ready to Harvest';
      case 'harvested':
        return '✅ Harvested';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'growing':
        return const Color(0xFF4CAF50);
      case 'ready':
        return const Color(0xFFFF9800);
      case 'harvested':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'sowingDate': sowingDate.toIso8601String(),
      'expectedHarvestDate': expectedHarvestDate?.toIso8601String(),
      'status': status,
      'area': area,
      'areaUnit': areaUnit,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }

  factory Crop.fromJson(Map<String, dynamic> map) {
    return Crop(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      sowingDate: DateTime.parse(map['sowingDate']),
      expectedHarvestDate: map['expectedHarvestDate'] != null 
          ? DateTime.parse(map['expectedHarvestDate']) 
          : null,
      status: map['status'] ?? 'growing',
      area: (map['area'] ?? 0.0).toDouble(),
      areaUnit: map['areaUnit'] ?? 'Acres',
      notes: List<String>.from(map['notes'] ?? []),
      imageUrl: map['imageUrl'],
    );
  }
}

class CropInfo {
  final String name;
  final String icon;
  final String description;
  final List<String> requirements;
  final int growingPeriodDays;
  final String bestSeason;
  final double waterRequirement;
  final List<String> commonPests;
  final List<String> commonDiseases;
  final List<String> fertilizers;

  CropInfo({
    required this.name,
    required this.icon,
    required this.description,
    required this.requirements,
    required this.growingPeriodDays,
    required this.bestSeason,
    required this.waterRequirement,
    required this.commonPests,
    required this.commonDiseases,
    required this.fertilizers,
  });
}

class MarketPrice {
  final String cropName;
  final double pricePerQuintal;
  final String trend; // 'up', 'down', 'stable'
  final String market;
  final DateTime lastUpdated;
  final String unit;

  MarketPrice({
    required this.cropName,
    required this.pricePerQuintal,
    required this.trend,
    required this.market,
    required this.lastUpdated,
    this.unit = 'quintal',
  });

  String get trendIcon {
    switch (trend) {
      case 'up':
        return '📈';
      case 'down':
        return '📉';
      case 'stable':
        return '➡️';
      default:
        return '➡️';
    }
  }

  Color get trendColor {
    switch (trend) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      case 'stable':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String get formattedPrice => '₹${pricePerQuintal.toInt()}';
}

class PestDiseaseAlert {
  final String id;
  final String type; // 'pest' or 'disease'
  final String name;
  final String description;
  final String severity; // 'low', 'medium', 'high'
  final List<String> affectedCrops;
  final String solution;
  final DateTime createdAt;
  final String? imageUrl;

  PestDiseaseAlert({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.severity,
    required this.affectedCrops,
    required this.solution,
    required this.createdAt,
    this.imageUrl,
  });

  String get severityIcon {
    switch (severity) {
      case 'low':
        return '🟡';
      case 'medium':
        return '🟠';
      case 'high':
        return '🔴';
      default:
        return '⚪';
    }
  }

  Color get severityColor {
    switch (severity) {
      case 'low':
        return Colors.yellow;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get typeIcon {
    return type == 'pest' ? '🐛' : '🦠';
  }
}

// Note: WeatherInfo and WeatherForecast moved to dedicated weather.dart model file.

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type; // 'weather', 'pest', 'market', 'scheme', 'order'
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  String get typeIcon {
    switch (type) {
      case 'weather':
        return '🌤️';
      case 'pest':
        return '🐛';
      case 'market':
        return '💰';
      case 'scheme':
        return '🏛️';
      case 'order':
        return '📦';
      default:
        return '📢';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${(difference.inDays / 7).floor()}w ago';
  }
}

/// Simplified crop model used by MyCropNotifier for farmer's personal crop tracking.
class CropModel {
  final String id;
  final String name;
  final DateTime sowingDate;
  final String farmerId;
  final String? stage;
  final String? status;

  CropModel({
    required this.id,
    required this.name,
    required this.sowingDate,
    required this.farmerId,
    this.stage,
    this.status,
  });

  int get daysSinceSowing => DateTime.now().difference(sowingDate).inDays;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sowingDate': sowingDate.toIso8601String(),
        'farmerId': farmerId,
        'stage': stage,
        'status': status,
      };

  factory CropModel.fromJson(Map<String, dynamic> json) => CropModel(
        id: json['id'] as String,
        name: json['name'] as String,
        sowingDate: DateTime.parse(json['sowingDate'] as String),
        farmerId: json['farmerId'] as String,
        stage: json['stage'] as String?,
        status: json['status'] as String?,
      );
}
