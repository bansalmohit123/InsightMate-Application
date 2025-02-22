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
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required OtpVerificationCallback callback,
  }) async {
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

    Map<String, dynamic> data = json.decode(response.body);
    print(data);
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('token', data['token']);

final userProvider = Provider.of<UserProvider>(context, listen: false);

userProvider.setUser(response.body);

print(userProvider.user.token);
callback(true);
  }

  void updateUser(BuildContext context, dynamic userData) {
    Provider.of<UserProvider>(context, listen: false).setUser(userData["user"]);
  }

  Future<bool> register(
      {required BuildContext context,
      required String username,
      required String email,
      required String password,
     }) async {
    User user = User(
      id: '',
      username: username,
      password: password,
      email: email,
      token: '',
    );
    // print(user.toJson());
    final response = await http.post(
      Uri.parse('$uri/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: user.toJson(),
    );

   
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        prefs.setString('token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/api/auth/TokenisValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/api/auth/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'token': token
          },
        );
        print(userRes.body);
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      print(e);
    }
  }
}