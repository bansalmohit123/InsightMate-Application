import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:insightmate/model/user.dart';
import 'package:insightmate/global_variable.dart';
import 'package:insightmate/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OtpVerificationCallback = void Function(bool success);

class AuthService {
  // Login Function
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required OtpVerificationCallback callback,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print("Login Response: $data");

        if (data['token'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);

          final userProvider = Provider.of<UserProvider>(context, listen: false);
           userProvider.setUserFromModel(User.fromMap(data)); // <-- safer parsing

          print("User Token: ${userProvider.user.token}");
          callback(true);
        } else {
          print("Token missing in response");
          callback(false);
        }
      } else {
        print("Login failed: ${response.body}");
        callback(false);
      }
    } catch (e) {
      print("Login Error: $e");
      callback(false);
    }
  }

  // Update User in Provider
  void updateUser(BuildContext context, dynamic userData) {
    Provider.of<UserProvider>(context, listen: false).setUser(userData["user"]);
  }

  // Register Function
  Future<bool> register({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        username: username,
        password: password,
        email: email,
        token: '',
      );

      final response = await http.post(
        Uri.parse('$uri/api/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );

      if (response.statusCode == 200) {
        print("Registration Success: ${response.body}");
        return true;
      } else {
        print("Registration Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Registration Error: $e");
      return false;
    }
  }

  // Get User Data Function
  Future<void> getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("No token found, skipping getUserData");
        return;
      }

      // Validate Token
      var tokenRes = await http.post(
        Uri.parse('$uri/api/auth/TokenisValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        // Fetch user data
        http.Response userRes = await http.get(
          Uri.parse('$uri/api/auth/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'token': token
          },
        );

        if (userRes.statusCode == 200) {
  print("User Data: ${userRes.body}");
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.setUserFromModel(User.fromMap(jsonDecode(userRes.body))); // <-- Safe parsing
}

        else {
          print("Failed to get user data: ${userRes.body}");
        }
      } else {
        print("Token Invalid");
      }
    } catch (e) {
      print("Error in getUserData: $e");
    }
  }
}
