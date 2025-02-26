import 'package:flutter/material.dart';
import 'package:insightmate/forms/chat_service.dart';
import 'package:insightmate/utils.dart';

class YoutubeChatbotForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSessionCreated; // Callback for real-time update
  const YoutubeChatbotForm({super.key, required this.onSessionCreated});

  @override
  State<YoutubeChatbotForm> createState() => _YoutubeChatbotFormState();
}

class _YoutubeChatbotFormState extends State<YoutubeChatbotForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _youtubeLink = '';
  ChatService chatService = ChatService();

  /// Simple YouTube validator (checks for presence of youtube.com or youtu.be)
  String? _validateYoutubeLink(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a YouTube link';
    }
    final text = value.trim().toLowerCase();
    final uri = Uri.tryParse(text);
    if (uri == null ||
        (!text.contains('youtube.com') && !text.contains('youtu.be'))) {
      return 'Please provide a valid YouTube link';
    }
    return null; // All good
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      chatService.uploadYoutube(
        context: context,
        title: _title,
        description: _description,
        youtubeurl: _youtubeLink,
        callback: (bool success, String sessionID, String fileID) {
          if (success) {
            print("Upload Successful");
            final newSession = {
              "id": fileID,
              "title": _title,
              "description": _description,
              "sessionID": sessionID,
            };
            widget.onSessionCreated(newSession);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('YouTube Chatbot session created')),
            );
            Navigator.pop(context);
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add a valid Youtube link with Transcript')),
            );
              Navigator.pop(context);
            print("Upload Unsuccessful");
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(

      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Form(
            key: _formKey,
            child: Column(
              
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter a title'
                      : null,
                  onSaved: (value) => _title = value!.trim(),
                ),
                const SizedBox(height: 16),

                // Description field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter a description'
                      : null,
                  onSaved: (value) => _description = value!.trim(),
                ),
                const SizedBox(height: 16),

                // YouTube link field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'YouTube Video Link',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateYoutubeLink,
                  onSaved: (value) => _youtubeLink = value!.trim(),
                ),
                const SizedBox(height: 24),

                // Submit button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color3,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'Create Session',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
