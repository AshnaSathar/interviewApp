import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/admin/add_video.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controller/video_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoManagement extends StatefulWidget {
  const VideoManagement({Key? key}) : super(key: key);

  @override
  State<VideoManagement> createState() => _VideoManagementState();
}

class _VideoManagementState extends State<VideoManagement> {
  @override
  void initState() {
    super.initState();
    // Fetch videos when the page loads.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideoController>(context, listen: false).fetchVideos();
    });
  }

  void _deleteVideo(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Video"),
        content: const Text("Are you sure you want to delete this video?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await Provider.of<VideoController>(context, listen: false)
          .deleteVideo(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video deleted successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Management")),
      body: Consumer<VideoController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.videos.isEmpty) {
            return const Center(child: Text("No videos available"));
          }
          return ListView.builder(
            itemCount: controller.videos.length,
            itemBuilder: (context, index) {
              final video = controller.videos[index];
              final String url = video['url'];
              final String title = video['title'] ?? "No Title";
              final String description =
                  video['description'] ?? "No Description";
              final videoId = YoutubePlayer.convertUrlToId(url);
              return ListTile(
                leading: videoId != null
                    ? Image.network("https://img.youtube.com/vi/$videoId/0.jpg")
                    : const Icon(Icons.video_library),
                title: Text(title),
                subtitle: Text(description),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteVideo(video['id']);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text("Delete"),
                    ),
                  ],
                ),
                onTap: () {
                  // Optionally, you can navigate to a video player screen.
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddVideoPage()),
          );
        },
      ),
    );
  }
}
