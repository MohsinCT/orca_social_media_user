import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerControllerProvider extends ChangeNotifier {
  final String videoUrl;
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = true;

  VideoPlayerControllerProvider(this.videoUrl) {
    _initializeVideoPlayer();
  }

  VideoPlayerController get videoPlayerController => _videoPlayerController;
  bool get isPlaying => _isPlaying;

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        _videoPlayerController.setLooping(true);
        _videoPlayerController.play();
        notifyListeners(); // Notify listeners when the video is initialized
      });
  }

  void togglePlayPause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _isPlaying = false;
    } else {
      _videoPlayerController.play();
      _isPlaying = true;
    }
    notifyListeners(); // Notify listeners on play/pause toggle
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
