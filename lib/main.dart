
import 'package:flutter/material.dart';
import 'package:your_blog/pages/home.dart';
import 'package:your_blog/pages/welcome.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:your_blog/network_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
 State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const WelcomePage();
  final storage = const FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? userId = await storage.read(key: "userId");
    if (userId != null) {
      setState(() {
        page = const HomePage();
      });
    } else {
      setState(() {
        page = const WelcomePage();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: page,
    );
  }
}