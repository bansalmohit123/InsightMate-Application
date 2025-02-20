import 'package:flutter/material.dart';
import 'package:insightmate/utils.dart';

class WebpageChatbotForm extends StatefulWidget {
  const WebpageChatbotForm({super.key});

  @override
  State<WebpageChatbotForm> createState() => _WebpageChatbotFormState();
}

class _WebpageChatbotFormState extends State<WebpageChatbotForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _webpageLink = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Web Page Chatbot session created')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and Provide a Valid Webpage Link')),
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
        child: IntrinsicHeight( // This will remove extra empty space
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max, // This ensures it takes only required space
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Webpage Link', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a webpage link' : null,
                  onSaved: (value) => _webpageLink = value!,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center, // This ensures the button doesn't stretch unnecessarily
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color3,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    onPressed: _submitForm,
                    child: const Text('Create Session', style: TextStyle(fontSize: 16)),
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
