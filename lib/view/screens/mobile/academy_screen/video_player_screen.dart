import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/video_player_controller.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoPlayerControllerProvider(videoUrl),
      child: Consumer<VideoPlayerControllerProvider>(
        builder: (context, videoProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(videoProvider.isPlaying ? 'Playing' : 'Paused'), // Update as needed
            ),
            body: Center(
              child: videoProvider.videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: videoProvider.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoProvider.videoPlayerController),
                    )
                  : const CircularProgressIndicator(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: videoProvider.togglePlayPause,
              child: Icon(
                videoProvider.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          );
        },
      ),
    );
  }
}
