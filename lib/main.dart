import 'package:flutter/material.dart';
import 'package:interview_task/providers/FakeModelProvider.dart';
import 'package:interview_task/providers/LoginPrivider.dart';
import 'package:interview_task/screen/SplashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FakeModelProvider()..fetchData()),
        ChangeNotifierProvider(create: (_) => LoginProvider()), // Add LoginProvider here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const SplashScreen(),   // You can navigate from here to other screens
      ),
    );
  }
}
