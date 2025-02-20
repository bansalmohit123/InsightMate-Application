import 'dart:convert';
import 'dart:io';

class WebModel {
  final String id;
  final String title;
  final String description;
  final String weburl; // Now using actual File object

  WebModel({
    required this.id,
    required this.title,
    required this.description,
    required this.weburl,
  });

  // Convert model to a Map (Cannot store File directly in JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'file': weburl // Storing only the file path
    };
  }

  // Create model from a Map
  factory WebModel.fromMap(Map<String, dynamic> map) {
    return WebModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      weburl: map['weburl'] ?? '', // Convert path back to File
    );
  }

  // Convert model to JSON (Stores file path, not actual File)
  String toJson() => json.encode(toMap());

  // Create model from a JSON string
  factory WebModel.fromJson(String source) => WebModel.fromMap(json.decode(source));

  // Copy method for immutability
  WebModel copyWith({
    String? id,
    String? title,
    String? description,
    String? weburl,
  }) {
    return WebModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      weburl: weburl ?? this.weburl,
    );
  }
}
