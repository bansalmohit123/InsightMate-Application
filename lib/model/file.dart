import 'dart:convert';
import 'dart:io';

class FileModel {
  final String id;
  final String title;
  final String description;
  final File file; // Now using actual File object

  FileModel({
    required this.id,
    required this.title,
    required this.description,
    required this.file,
  });

  // Convert model to a Map (Cannot store File directly in JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'file': file.path, // Storing only the file path
    };
  }

  // Create model from a Map
  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      file: File(map['file'] ?? ''), // Convert path back to File
    );
  }

  // Convert model to JSON (Stores file path, not actual File)
  String toJson() => json.encode(toMap());

  // Create model from a JSON string
  factory FileModel.fromJson(String source) => FileModel.fromMap(json.decode(source));

  // Copy method for immutability
  FileModel copyWith({
    String? id,
    String? title,
    String? description,
    File? file,
  }) {
    return FileModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      file: file ?? this.file,
    );
  }
}
