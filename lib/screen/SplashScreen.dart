import 'dart:async';
import 'package:flutter/material.dart';
import 'package:interview_task/screen/AuthScreen/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to FakeScreen after 2 seconds
    Timer(
      const Duration(seconds: 3),
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Removes shadow for a flat design
        backgroundColor: Colors.white, // Sets the app bar color to white
        iconTheme: const IconThemeData(color: Colors.black), // Ensures icons are visible
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Image.asset(
            "assets/splash.png", // Replace with your logo file path
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
