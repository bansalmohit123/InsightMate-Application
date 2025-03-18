import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:insightmate/providers/file.dart';
import 'package:insightmate/providers/userProvider.dart';
import 'package:insightmate/providers/web.dart';
import 'package:insightmate/providers/youtube.dart';
import 'package:path/path.dart' as path;
import 'package:insightmate/global_variable.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 👈 Import this for MIME type detection


class ChatService {
  Future<void> uploadFile({
    required BuildContext context,
    required String title,
    required String description,
    required dynamic file, // Can be File (Mobile) or Uint8List (Web)
    required String fileName, // Pass filename separately
    required void Function(bool success,String sessionID,String fileID) callback,
  }) async {
    try {
       String fileExtension = path.extension(fileName); // Example: ".pdf"
       SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
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
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      request.fields['userId'] = userProvider.user.id;
      request.fields['title'] = title;
      request.fields['description'] = description;

      // Add header token
      request.headers['token'] = token!;

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        debugPrint("Upload Successful: ${response.body}");
        Map<String, dynamic> responseBody = jsonDecode(response.body);
          String sessionID = responseBody['sessionID'];
          String fileID = responseBody['documentId'];
        FileProvider fileProvider = Provider.of<FileProvider>(context, listen: false);
        fileProvider.setFile(response.body);
        callback(true,sessionID,fileID);
      } else {
        debugPrint("Upload Failed: ${response.body}");
        callback(false,"","");
      }
    } catch (e) {
      debugPrint("Error uploading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
      );
      callback(false,"","");
    }
  }
   Future<void> QueryFile({
      required BuildContext context,
      required String question,
      required String documentId,
      required void Function(String success) callback,
   }) async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? token = prefs.getString('token');
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String token = userProvider.user.token;
      final response = await http.post(
        Uri.parse('$uri/api/document/query'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token!,
        },
        body: jsonEncode(<String, dynamic>{
          'question': question,
          'documentId': documentId,
        }),
      );
      
     
      if(response.statusCode == 200) {
        debugPrint("Query Successful: ${response.body}");
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String answer = responseBody['answer'];
        callback(answer);
      }
      else {
        debugPrint("Error querying file");
        callback("false");
      }
      
   }

   Future<void> uploadWeb({
    required BuildContext context,
    required String title,
    required String description,
    required String webpageLink,
    required void Function(bool success,String sessionI,String fileID) callback,
   })async{
      try{
      //    SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? token = prefs.getString('token');
      //     UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
       UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String token = userProvider.user.token;
        var response = await http.post(
          Uri.parse('$uri/api/url/upload'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'token': token,
          },
          body: jsonEncode(<String, String>{
            'title': title,
            'description': description,
            'url': webpageLink,
            'userId': userProvider.user.id,
          }),
        );
        if(response.statusCode == 200){
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          String sessionID = responseBody['sessionID'];
          String fileID = responseBody['id'];
          debugPrint("Upload Successful: ${response.body}");
          WebProvider webProvider = Provider.of<WebProvider>(context, listen: false);
          webProvider.setWeb(response.body);
          callback(true,sessionID,fileID);
        }
        
        
      }catch(e){
        debugPrint("Error uploading file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
        callback(false,"","");
      }
   }

   Future<void> queryWeb({
    required BuildContext context,
    required String question,
    required String webId,
    required void Function(String success) callback,
   })async{
      try{
         UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String token = userProvider.user.token;
        var response = await http.post(
          Uri.parse('$uri/api/url/query'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'token': token,
          },
          body: jsonEncode(<String, String>{
            'question': question,
            'urlId': webId,
          }),
        );
        if(response.statusCode == 200){
          debugPrint("Upload Successful: ${response.body}");
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          String answer = responseBody['answer'];
          callback(answer);
        }
      }catch(e){
        debugPrint("Error uploading file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
        callback("false");
      }
   }

   Future<void> uploadYoutube({
    required BuildContext context,
    required String title,
    required String description,
    required String youtubeurl,
    required void Function(bool success,String sessionID,String fileID) callback,
   })async{
      try{
      //    SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? token = prefs.getString('token');
      //     UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
       UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String token = userProvider.user.token;
        var response = await http.post(
          Uri.parse('$uri/api/youtube/upload'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'token': token,
          },
          body: jsonEncode(<String, String>{
            'title': title,
            'description': description,
            'videoUrl': youtubeurl,
            'userId': userProvider.user.id,
          }),
        );
        if(response.statusCode == 200){
          debugPrint("Upload Successful: ${response.body}");
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          String sessionID = responseBody['sessionID'];
          String fileID = responseBody['id'];
          YoutubeProvider youtubeProvider = Provider.of<YoutubeProvider>(context, listen: false);
          youtubeProvider.setYoutube(response.body);
          callback(true,sessionID,fileID);
        }
      }catch(e){
        debugPrint("Error uploading file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
        callback(false,"","");
      }
   }

   Future<void> queryYoutube({
    required BuildContext context,
    required String question,
    required String youtubeId,
    required void Function(String success) callback,
   })async{
      try{
       UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String token = userProvider.user.token;
        var response = await http.post(
          Uri.parse('$uri/api/youtube/query'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'token': token,
          },
          body: jsonEncode(<String, String>{
            'question': question,
            'videoId': youtubeId,
          }),
        );
        if(response.statusCode == 200){
          debugPrint("Upload Successful: ${response.body}");
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          String answer = responseBody['answer'];
          callback(answer);
        }
        
      }catch(e){
        debugPrint("Error uploading file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
        callback("false");
      }
   }


   Future<List<Map<String, dynamic>>> getMessages(String sessionId) async {
    try {
      final response = await http.get(Uri.parse('$uri/api/chat/get/$sessionId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return jsonResponse.map((item) {
          return {
            "sender": item["sender"],
            "message": item["message"],
            "timestamp": item["timestamp"],
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // ✅ Save chat messages (User + Bot)
  Future<void> sendMessage({
    required BuildContext context,
    required String sessionId,
    required String sender,
    required String message,
  }) async {
    try {
       UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String token = userProvider.user.token;
      final response = await http.post(
        Uri.parse('$uri/api/chat/save'),
        headers: {
          "Content-Type": "application/json",
            "token": token
        },
        body: jsonEncode({
          "sessionId": sessionId,
          "sender": sender,
          "message": message,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Message failed to send.");
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }
}
