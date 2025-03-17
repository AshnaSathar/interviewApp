import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb if needed

class VideoDetailPage extends StatefulWidget {
  final String url;
  final String title;
  final String description;
  const VideoDetailPage({
    Key? key,
    required this.url,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.url);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsiveness.
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_controller != null)
              Container(
                margin: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? screenWidth * 0.1 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: isLargeScreen ? 28 : 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
