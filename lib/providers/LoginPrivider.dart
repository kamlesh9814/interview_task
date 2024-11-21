import 'package:flutter/material.dart';
import 'package:interview_task/model/LoginModel.dart';
import 'dart:io';
import 'package:interview_task/repository/LoginRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  final LoginRepository _loginRepository = LoginRepository();
  LoginModel? _loginModel;
  String? _errorMessage;
  bool _isLoading = false;

  LoginModel? get loginModel => _loginModel;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Add BuildContext parameter to this method
  Future<void> login(String username, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      var data = {
        'username': username.trim(),
        'password': password.trim(),
      };

      _loginModel = await _loginRepository.loginUser(data, context);
      _errorMessage = null;

      if (_loginModel?.user?.token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', _loginModel!.user!.token!);
      }
      notifyListeners();
    } on FormatException catch (e) {
      _errorMessage = 'Invalid response format: ${e.message}';
      _showErrorSnackbar(context, _errorMessage!);
    } on SocketException catch (e) {
      _errorMessage = 'No internet connection: ${e.message}';
      _showErrorSnackbar(context, _errorMessage!);
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _showErrorSnackbar(context, _errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
