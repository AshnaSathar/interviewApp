import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String selectedLanguage = 'English'; // Default selection

  final List<String> languages = [
    'English',
    'Malayalam',
    'Hindi',
    'Tamil',
    'Kannada',
    'Telugu'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Selection',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          return ListTile(
            title: Text(language, style: const TextStyle(fontSize: 16)),
            trailing: selectedLanguage == language
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              setState(() {
                selectedLanguage = language;
              });
              // You can save the selection to preferences or pass it back if needed
            },
          );
        },
      ),
    );
  }
}
