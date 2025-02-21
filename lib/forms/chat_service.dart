import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:insightmate/providers/file.dart';
import 'package:path/path.dart' as path;
import 'package:insightmate/global_variable.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart'; // 👈 Import this for MIME type detection
class ChatService {
  Future<void> uploadFile({
    required BuildContext context,
    required String title,
    required String description,
    required dynamic file, // Can be File (Mobile) or Uint8List (Web)
    required String fileName, // Pass filename separately
    required void Function(bool success) callback,
  }) async {
    try {
       String fileExtension = path.extension(fileName); // Example: ".pdf"
       print(fileExtension);
      var request = http.MultipartRequest('POST', Uri.parse('$uri/api/document/upload'));
      
      String? mimeType = lookupMimeType(fileName); // Detect MIME type dynamically
    List<String> mimeParts = mimeType?.split('/') ?? ['application', 'octet-stream'];
      if (kIsWeb) {
        // 🌐 Web: File is Uint8List (Binary Data)
        Uint8List fileBytes = file as Uint8List;

        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            fileBytes,
            filename: fileName, // Use stored file name
            contentType: MediaType('application', fileExtension.replaceAll('.', '')), // Force mimetype
          ),
        );
      } else {
        // 📱 Mobile/Desktop: File is a regular File object
        request.files.add(
          await http.MultipartFile.fromPath(
          'file',
          (file as File).path,
          contentType: MediaType(mimeParts[0], mimeParts[1]), // 👈 Fix MIME type issue
        ),
        );
      }

      // Add metadata (title & description)
      request.fields['title'] = title;
      request.fields['description'] = description;

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        debugPrint("Upload Successful: ${response.body}");
        callback(true);
      } else {
        debugPrint("Upload Failed: ${response.body}");
        callback(false);
      }
    } catch (e) {
      debugPrint("Error uploading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
      );
      callback(false);
    }
  }
   Future<void> QueryFile({
      required BuildContext context,
      required String question,
      required int fileId
   }) async {
      final response = await http.post(
        Uri.parse('$uri/api/document/query'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'question': question,
          'documentId': fileId,
        }),
      );
      
      print(response.body);
      // if(response.statusCode == 200) {
      //   final fileProvider = Provider.of<FileProvider>(context, listen: false);
      //   fileProvider.setFile(response.body);
      // }
      // else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Error querying file")),
      //   );
      // }
      
   }

   Future<void> uploadWeb({
    required BuildContext context,
    required String title,
    required String description,
    required String webpageLink,
    required void Function(bool success) callback,
   })async{
      try{
        var response = await http.post(
          Uri.parse('$uri/api/url/upload'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'title': title,
            'description': description,
            'url': webpageLink,
          }),
        );
        // if(response.statusCode == 200){
        //   debugPrint("Upload Successful: ${response.body}");
        //   callback(true);
        // }
        print(response.body);
        callback(true);
      }catch(e){
        debugPrint("Error uploading file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
        callback(false);
      }
   }

   Future<void> queryWeb({
    required BuildContext context,
    required String question,
    required String webId,
    required void Function(bool success) callback,
   })async{
      try{
        var response = await http.post(
          Uri.parse('$uri/api/url/query'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'question': question,
            'urlId': webId,
          }),
        );
        if(response.statusCode == 200){
          debugPrint("Upload Successful: ${response.body}");
          callback(true);
        }
      }catch(e){
        debugPrint("Error uploading file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
        callback(false);
      }
   }

   Future<void> uploadYoutube({
    required BuildContext context,
    required String title,
    required String description,
    required String youtubeLink,
    required void Function(bool success) callback,
   })async{
      try{
        var response = await http.post(
          Uri.parse('$uri/api/youtube/upload'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'title': title,
            'description': description,
            'videoUrl': youtubeLink,
          }),
        );
        if(response.statusCode == 200){
          debugPrint("Upload Successful: ${response.body}");
          callback(true);
        }
      }catch(e){
        debugPrint("Error uploading file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
        callback(false);
      }
   }

   Future<void> queryYoutube({
    required BuildContext context,
    required String question,
    required String youtubeId,
    required void Function(bool success) callback,
   })async{
      try{
        var response = await http.post(
          Uri.parse('$uri/api/youtube/query'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'question': question,
            'videoId': youtubeId,
          }),
        );
        if(response.statusCode == 200){
          debugPrint("Upload Successful: ${response.body}");
          callback(true);
        }
      }catch(e){
        debugPrint("Error uploading file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
        callback(false);
      }
   }
}
