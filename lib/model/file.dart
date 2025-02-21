import 'dart:convert';
import 'dart:io';

class FileModel {
  final String documentId;
  final String title;
  final String description;
  

  FileModel({
    required this.documentId,
    required this.title,
    required this.description,
  });

  // Convert model to a Map (Cannot store File directly in JSON)
  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'title': title,
      'description': description,
    };
  }

  // Create model from a Map
  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      documentId: map['documentId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    
    );
  }

  // Convert model to JSON (Stores file path, not actual File)
  String toJson() => json.encode(toMap());

  // Create model from a JSON string
  factory FileModel.fromJson(String source) => FileModel.fromMap(json.decode(source));

  // Copy method for immutability
  FileModel copyWith({
    String? documentId,
    String? title,
    String? description,
    
  }) {
    return FileModel(
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
