import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
 _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const WelcomePage();
  final storage = const FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  var log = Logger();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }
  void getUserData() async {
    Response response = await networkHandler.get("users/1");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userData", response.body);
    }
  }
  void checkLogin() async {
    String? token = await storage.read(key: "id");
    if (token != null) {
      getUserData();
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