import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_blog/pages/welcome.dart';

import '../models/profile.dart';
import '../posts/new.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  ProfileModel profileModel = ProfileModel();

  @override
  void initState() {
    super.initState();
    getUserData();
  }
  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileModel = ProfileModel.fromJson(json.decode(prefs.getString("userData")!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: profileModel.name == null
                        ? const AssetImage("assets/graphics.png")
                        : FileImage(File(profileModel.name!)) as ImageProvider,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("@${profileModel.username}"),
                ],
              ),
            ),
            ListTile(
              title: const Text("New post"),
              trailing: const Icon(Icons.add),
              onTap: () {},
            ),
            ListTile(
              title: const Text("My posts"),
              trailing: const Icon(Icons.article),
              onTap: () {},
            ),
            ListTile(
              title: const Text("All posts"),
              trailing: const Icon(Icons.launch),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Logout"),
              trailing: const Icon(Icons.logout),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        /*title: const Text(
          "Your Blog"
        ),*/
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewPost()));
          },
          child: const Icon(Icons.edit_note, size: 32,)
      ),
      body: Center(
        child: Text(
          "Home page",
        ),
      ),
    );
  }
  
  void logout() async {
    await storage.delete(key: "id");
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const WelcomePage()), (route) => false);
  }
}