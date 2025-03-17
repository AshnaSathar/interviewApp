import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/view/users/video_details_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListPage extends StatelessWidget {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to adjust padding and sizing for responsiveness.
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Videos",
          style: TextStyles.normalText.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('videos')
            .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No videos found"));
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? screenWidth * 0.2 : 8.0,
                vertical: 8.0),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final String videoUrl = data['url'];
              final String title = data['title'] ?? "No Title";
              final String description =
                  data['description'] ?? "No Description";
              final videoId = YoutubePlayer.convertUrlToId(videoUrl);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(isLargeScreen ? 16.0 : 8.0),
                  leading: videoId != null
                      ? Image.network(
                          "https://img.youtube.com/vi/$videoId/0.jpg",
                          width: isLargeScreen ? 150 : 100,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.video_library, size: 40),
                  title: Text(
                    title,
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 16),
                  ),
                  subtitle: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: isLargeScreen ? 18 : 14),
                  ),
                  onTap: () {
                    // Navigate to the detail page.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoDetailPage(
                          url: videoUrl,
                          title: title,
                          description: description,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
