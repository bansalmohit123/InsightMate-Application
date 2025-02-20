import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:insightmate/forms/chat_service.dart';
import 'package:insightmate/utils.dart';

class DocumentChatbotForm extends StatefulWidget {
  const DocumentChatbotForm({super.key});

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

  Future<void> _pickFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'csv'],
      withData: true, // Ensures file bytes are available for Web
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name; // Store file name

        if (kIsWeb) {
          // 🌐 Web: Store bytes
          _selectedFile = result.files.single.bytes;
        } else {
          // 📱 Mobile/Desktop: Store File object
          _selectedFile = File(result.files.single.path!);
        }
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error selecting file: $e")),
    );
  }
}

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedFile != null) {
      _formKey.currentState!.save();

      chatService.uploadFile(
        context: context,
        title: _title,
        description: _description,
        file: _selectedFile!,
        fileName: _fileName?? "uploaded_file",
        callback: (bool success) {
          if (success) {
            print("uploaded Succesfull");
          } else {
            print("upload unSuccesfull");
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document Chatbot session created')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select a file')),
      );
    }
  }
  String _getFileName() {
  if (_selectedFile == null) return 'No file selected';

  if (kIsWeb) {
    // Web: Use filePicker result (Uint8List does not have path, so set default name)
    return "Uploaded File"; 
  } else {
    // Mobile/Desktop: Extract file name from path
    return _selectedFile!.path.split('/').last;
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
