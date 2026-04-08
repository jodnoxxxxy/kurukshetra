import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isValidVideo = true;

  @override
  void initState() {
    super.initState();
    String? videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);
    
    if (videoId == null || videoId.isEmpty) {
      _isValidVideo = false;
    } else {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title, style: const TextStyle(fontSize: 16)),
      ),
      body: Center(
        child: _isValidVideo
            ? YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              )
            : const Text(
                'Invalid YouTube URL provided.',
                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
