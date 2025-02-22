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
import 'package:provider/provider.dart'; // 👈 Import this for MIME type detection





class Sessionservice {
  Future<List<Map<String, dynamic>>> findoption({
    required BuildContext context,
    required String option,
  }) async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var userId = userProvider.user.id;

      final response = await http.post(
        Uri.parse('$uri/api/get/getoption'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'option': option,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        debugPrint("Query Successful: $jsonResponse");

       
        List<Map<String, dynamic>> sessions = jsonResponse.map((item) {
          return {
            "title": item["title"] ?? "No Title",
            "description": item["description"] ?? "No Description",
            "id": item["id"] ?? "No ID",
          };
        }).toList();

        return sessions; // ✅ Return the sessions list
      } else {
        debugPrint("Error querying file");
        return [];
      }
    } catch (e) {
      debugPrint("Error querying file: $e");
      return [];
    }
  }
}
