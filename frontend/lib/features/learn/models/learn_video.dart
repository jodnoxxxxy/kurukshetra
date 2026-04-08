import 'package:cloud_firestore/cloud_firestore.dart';

class LearnVideo {
  final String id;
  final String title;
  final String category;
  final String duration;
  final int views;
  final String videoUrl;
  final DateTime createdAt;

  LearnVideo({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.views,
    required this.videoUrl,
    required this.createdAt,
  });

  factory LearnVideo.fromJson(Map<String, dynamic> json, String id) {
    return LearnVideo(
      id: id,
      title: json['title'] ?? '',
      category: json['category'] ?? 'General',
      duration: json['duration'] ?? '0:00',
      views: json['views'] ?? 0,
      videoUrl: json['videoUrl'] ?? '',
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'duration': duration,
      'views': views,
      'videoUrl': videoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
