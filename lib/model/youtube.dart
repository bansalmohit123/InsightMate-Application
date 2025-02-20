import 'dart:convert';
import 'dart:io';

class YoutubeModel {
  final String id;
  final String title;
  final String description;
  final String youtubeurl; // Now using actual File object

  YoutubeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeurl,
  });

  // Convert model to a Map (Cannot store File directly in JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'file': youtubeurl // Storing only the file path
    };
  }

  // Create model from a Map
  factory YoutubeModel.fromMap(Map<String, dynamic> map) {
    return YoutubeModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      youtubeurl: map['youtubeurl'] ?? '', // Convert path back to File
    );
  }

  // Convert model to JSON (Stores file path, not actual File)
  String toJson() => json.encode(toMap());

  // Create model from a JSON string
  factory YoutubeModel.fromJson(String source) => YoutubeModel.fromMap(json.decode(source));

  // Copy method for immutability
  YoutubeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? youtubeurl,
  }) {
    return YoutubeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      youtubeurl: youtubeurl ?? this.youtubeurl,
    );
  }
}
