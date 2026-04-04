import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/features/learn/models/learn_video.dart';

// Stream Provider for real-time video updates
final learnVideosProvider = StreamProvider.autoDispose<List<LearnVideo>>((ref) {
  return FirebaseFirestore.instance
      .collection('learn_videos')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return LearnVideo.fromJson(doc.data(), doc.id);
    }).toList();
  });
});

