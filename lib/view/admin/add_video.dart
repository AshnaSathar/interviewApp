import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controller/video_controller.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({Key? key}) : super(key: key);

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveVideo() async {
    final String url = _urlController.text.trim();
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();

    if (url.isEmpty || title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }

    // Confirmation dialog: "Details can't be updated once saved."
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Save"),
        content: const Text(
            "Details cannot be updated once saved. Do you want to proceed?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<VideoController>(context, listen: false)
          .addVideo(url, title, description);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video added successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error adding video")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Video")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: "YouTube URL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveVideo,
                    child: const Text("Save Video"),
                  ),
          ],
        ),
      ),
    );
  }
}
