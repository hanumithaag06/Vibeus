import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'services/sync_service.dart';


class PlayerScreen extends StatefulWidget {
  final String videoId;
  final String roomId;

  const PlayerScreen({
    super.key,
    required this.videoId,
    required this.roomId,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late YoutubePlayerController controller;

@override
void initState() {
  super.initState();

  controller = YoutubePlayerController(
    initialVideoId: widget.videoId,
    flags: YoutubePlayerFlags(autoPlay: true),
  );

  // 🔥 ADD THIS PART
  SyncService.listenSong(widget.roomId).listen((videoId) {
    if (videoId != null &&
    videoId != controller.metadata.videoId) {
      controller.load(videoId);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Now Playing 🎧")),
      body: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
      ),
    );
  }
}