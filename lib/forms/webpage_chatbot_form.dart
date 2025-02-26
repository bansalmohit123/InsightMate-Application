import 'package:flutter/material.dart';
import 'package:insightmate/forms/chat_service.dart';
import 'package:insightmate/utils.dart';

class WebpageChatbotForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSessionCreated; // Callback for real-time update
  const WebpageChatbotForm({super.key, required this.onSessionCreated});

  @override
  State<WebpageChatbotForm> createState() => _WebpageChatbotFormState();
}

class _WebpageChatbotFormState extends State<WebpageChatbotForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _webpageLink = '';
  ChatService chatService = ChatService();

  /// Simple URL validator
  String? _validateWebLink(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a webpage link';
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        (!uri.hasScheme && !uri.hasAuthority) ||
        uri.host.isEmpty) {
      return 'Please enter a valid webpage link';
    }
    return null; // All good
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      chatService.uploadWeb(
        context: context,
        title: _title,
        description: _description,
        webpageLink: _webpageLink,
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
              const SnackBar(content: Text('Web Page Chatbot session created')),
            );
            Navigator.pop(context);
          } else {
            print("Upload Unsuccessful");
          }
        },
      );
    } else {
      // Show a generic error if form is invalid
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
              mainAxisSize: MainAxisSize.max,
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
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Please enter a description'
                          : null,
                  onSaved: (value) => _description = value!.trim(),
                ),
                const SizedBox(height: 16),

                // Webpage link field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Webpage Link',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateWebLink,
                  onSaved: (value) => _webpageLink = value!.trim(),
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
