import 'package:flutter/material.dart';
import 'package:main_project/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main Project',
      theme: ThemeData(primarySwatch: Colors.teal),  // Use a predefined MaterialColor
      home: LoginPage(),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:main_project/login.dart';
// ignore: duplicate_import
import 'login.dart';
import 'sign_up.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main Project',
      theme: ThemeData(primarySwatch: const Color.fromARGB(255, 4, 92, 73)), // Adjust to your theme
      home: LoginPage(),
    );
  }
}
*/
