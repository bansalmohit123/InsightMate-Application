import 'package:flutter/material.dart';
import 'package:insightmate/forms/chat_service.dart';
import 'package:insightmate/utils.dart';

class YoutubeChatbotForm extends StatefulWidget {
  const YoutubeChatbotForm({super.key});

  @override
  State<YoutubeChatbotForm> createState() => _YoutubeChatbotFormState();
}

class _YoutubeChatbotFormState extends State<YoutubeChatbotForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _youtubeLink = '';
  ChatService chatService = ChatService();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      chatService.uploadYoutube(
        context: context,
        title: _title,
        description: _description,
        youtubeurl: _youtubeLink,
        callback: (bool success) {
          if (success) {
            print("uploaded Succesfull");
          } else {
            print("upload unSuccesfull");
          }
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('YouTube Chatbot session created')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please fill all fields and Provide a Valid YouTube Link')),
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
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Title', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a title'
                      : null,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a description'
                      : null,
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'YouTube Video Link',
                      border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a YouTube link'
                      : null,
                  onSaved: (value) => _youtubeLink = value!,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color3,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                    ),
                    onPressed: _submitForm,
                    child: const Text('Create Session',
                        style: TextStyle(fontSize: 16)),
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
