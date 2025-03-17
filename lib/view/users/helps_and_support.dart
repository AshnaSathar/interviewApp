import 'package:flutter/material.dart';

class HelpsAndSupport extends StatelessWidget {
  const HelpsAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.amber,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return Center(
            child: Container(
              width: isWideScreen
                  ? 700
                  : double.infinity, // Limit width for large screens
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("FAQs"),
                    _buildFAQItem(
                      "How can I reset my password?",
                      "You can reset your password by clicking on 'Forgot Password' on the login screen and following the instructions.",
                    ),
                    _buildFAQItem(
                      "How do I contact customer support?",
                      "You can contact our support team via email or phone. See the contact details below.",
                    ),
                    _buildFAQItem(
                      "Why am I not receiving notifications?",
                      "Ensure that you have enabled notifications in your device settings for this app.",
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle("Contact Support"),
                    _buildContactItem(
                        Icons.email, "Email", "support@example.com"),
                    _buildContactItem(Icons.phone, "Phone", "+91 98765 43210"),
                    const SizedBox(height: 20),
                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // Implement contact action
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 20, vertical: 12),
                    //     ),
                    //     child: const Text("Contact Us"),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
