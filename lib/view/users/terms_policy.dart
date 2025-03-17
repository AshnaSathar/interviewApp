import 'package:flutter/material.dart';

class TermsPolicy extends StatelessWidget {
  const TermsPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Privacy Policy"),
        backgroundColor: Colors.amber,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen =
              constraints.maxWidth > 800; // Adjust for large screens

          return Center(
            child: Container(
              width: isWideScreen
                  ? 700
                  : double.infinity, // Limits width for large screens
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("1. Introduction"),
                        _buildSectionText(
                            "Welcome to our application. By using this app, you agree to abide by the following terms and policies."),
                        _buildSectionTitle("2. Data Collection"),
                        _buildSectionText(
                            "We collect user data to enhance the experience. This includes email, name, and other necessary details."),
                        _buildSectionTitle("3. Privacy Protection"),
                        _buildSectionText(
                            "We prioritize your privacy and do not share your information with third parties without your consent."),
                        _buildSectionTitle("4. Usage Restrictions"),
                        _buildSectionText(
                            "Users are prohibited from engaging in activities that compromise security or violate any laws."),
                        _buildSectionTitle("5. Changes to Terms"),
                        _buildSectionText(
                            "We reserve the right to update these terms at any time. Users will be notified of major changes."),
                        const SizedBox(height: 20),
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: ElevatedButton(
                        //     onPressed: () => Navigator.pop(context),
                        //     child: const Text("Accept & Continue"),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }
}
