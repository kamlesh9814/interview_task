import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:interview_task/model/LoginModel.dart';
import 'package:interview_task/util/app_constants.dart';
import 'package:flutter/material.dart';

class LoginRepository {

  Future<LoginModel> loginUser(Map<String, String> data, BuildContext context) async {
    // Log the request body to check the format
    print("Request body: ${json.encode(data)}");

    final response = await http.post(
      Uri.parse(AppConstants.loginUri),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(data),  // Ensure this is JSON encoded
    );

    // Log the response status and body for debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      // Show a success message using a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );
      return LoginModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      // Show an error message using a Snackbar for invalid credentials
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      throw Exception('Invalid credentials. Please try again.');
    } else {
      var body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Login failed. Please try again.');
    }
  }
}
