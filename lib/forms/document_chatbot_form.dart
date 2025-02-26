import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:insightmate/forms/chat_service.dart';
import 'package:insightmate/utils.dart';

class DocumentChatbotForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSessionCreated; // ✅ Callback for real-time update

  const DocumentChatbotForm({super.key, required this.onSessionCreated});

  @override
  State<DocumentChatbotForm> createState() => _DocumentChatbotFormState();
}

class _DocumentChatbotFormState extends State<DocumentChatbotForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _fileName = '';
  dynamic _selectedFile;
  ChatService chatService = ChatService();

  /// Picks a file from the device or web
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'csv'],
        withData: true, // Ensures file bytes are available for Web
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
          _selectedFile = kIsWeb
              ? result.files.single.bytes
              : File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting file: $e")),
      );
    }
  }

  /// Submits the form and creates a new session
  void _submitForm() {
    // First, validate form fields (title & description)
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
        ),
      );
      return;
    }
    // Then, check if file is selected
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file.')),
      );
      return;
    }

    // If everything is valid, save & upload
    _formKey.currentState!.save();

    chatService.uploadFile(
      context: context,
      title: _title,
      description: _description,
      file: _selectedFile!,
      fileName: _fileName.isNotEmpty ? _fileName : "uploaded_file",
      callback: (bool success, String sessionID, String fileID) {
        if (success) {
          print("Upload Successful");

          // Create a map with new session details
          Map<String, dynamic> newSession = {
            "id": fileID,
            "title": _title,
            "description": _description,
            "sessionID": sessionID,
          };

          widget.onSessionCreated(newSession);
          Navigator.pop(context, newSession);
        } else {
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload failed. Please try again or upload a valid format file.')),
          );
          Navigator.pop(context);
          print("Upload Unsuccessful");
        }
      },
    );
  }

  /// Gets the selected file name
  String _getFileName() {
    return _fileName.isNotEmpty ? _fileName : 'No file selected';
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
              mainAxisSize: MainAxisSize.min, // Prevent empty space at bottom
              children: [
                // Title field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!.trim(),
                ),
                const SizedBox(height: 16),

                // File picker
                OutlinedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: Text(
                    _selectedFile == null
                        ? 'Select File'
                        : 'File: ${_getFileName()}',
                  ),
                  onPressed: _pickFile,
                ),
                const SizedBox(height: 24),

                // Submit button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color3,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
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
