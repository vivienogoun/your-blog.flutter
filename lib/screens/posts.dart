import 'dart:io';

import 'package:flutter/material.dart';
import 'package:your_blog/posts/new.dart';
import 'package:your_blog/shared_prefs.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  SharedPrefs prefs = SharedPrefs();
  String path = "";

  @override
  void initState() {
    super.initState();
    getImage();
  }

  void getImage() async {
    final pathh = await prefs.read("localImagePath");
    setState(() {
      path = pathh;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewPost()));
        },
        child: const Icon(Icons.edit_note, size: 32,)
      ),
      body: CircleAvatar(
        radius: 100.0,
        backgroundImage: FileImage(File(path)),
      )
    );
  }
}