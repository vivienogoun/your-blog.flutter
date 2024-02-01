import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:your_blog/components/base_container.dart';
import 'package:your_blog/components/inputs/search.dart';
import 'package:your_blog/pages/welcome.dart';

import '../components/post_overview.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../network_handler.dart';
import '../posts/new.dart';
import '../utils/types.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  UserModel user = UserModel(email: "", fullName: "", password: "");
  NetworkHandler networkHandler = NetworkHandler();
  List<PostWithUser> allPosts = [];
  List<PostWithUser> postsWithUsers = [];
  var log = Logger();
  bool dataLoaded = false;
  bool serverError = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    String? userId = await storage.read(key: "userId");
    Response response1 = await networkHandler.get("/users/user.php", {
      "userId": userId
    });
    if (response1.statusCode == 500) {
      setState(() {
        serverError = true;
      });
      return;
    }
    setState(() {
      user = UserModel.fromJson(json.decode(response1.body));
    });

    Response response2 = await networkHandler.get("/posts/posts.php", {});
    (json.decode(response2.body) as List).map((e) => PostModel.fromJson(e)).toList().forEach((post) async {
      Response response = await networkHandler.get("/users/user.php", {
        "userId": post.userId
      });
      setState(() {
        allPosts.add(PostWithUser(post: post, user: UserModel.fromJson(json.decode(response.body))));
      });
    });
    setState(() {
      postsWithUsers = allPosts;
    });

    setState(() {
      dataLoaded = true;
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
                    backgroundImage: user.avatarUrl == null
                        ? const AssetImage("assets/profiles/0.jpg")
                        : AssetImage(user.avatarUrl!),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(user.fullName),
                ],
              ),
            ),
            ListTile(
              title: const Text("New post"),
              trailing: const Icon(Icons.add),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewPost(
                      edit: false,
                      userId: user.userId,
                    ))
                );
              },
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
        backgroundColor: Colors.black12,
        foregroundColor: Colors.black,
        title: const Text(
          "Home"
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifications are not implemented yet'),
                  )
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0,
                top: 0.0,
                right: 15.0,
                bottom: 10.0
            ),
            child: searchInput(
                    (String? value) => {
                  if (value != null && value != "") {
                    setState(() {
                      postsWithUsers = postsWithUsers.where((element) =>
                      element.user.fullName.toLowerCase().contains(value.toLowerCase())
                          || element.post.postTitle.toLowerCase().contains(value.toLowerCase())
                          || element.post.postContent.toLowerCase().contains(value.toLowerCase())
                      ).toList();
                    })
                  } else {
                    setState(() {
                      postsWithUsers = allPosts;
                    })
                  }
                }),
          ),
        ),
      ),
      body: serverError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something went wrong'),
            const Text('Check your internet connection'),
            TextButton(
              child: const Text('Refresh'),
              onPressed: () {
                setState(() {
                  serverError = false;
                  getData();
                });
              },
            )
          ],
        ),
      )
          : !dataLoaded ? const Center(
        child: CircularProgressIndicator(
          color: Colors.black54,
        ),
      ) : baseContainer(
          context,
          false,
          const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 15.0,
          ),
          Column(
            children: postsWithUsers.map((postWithUser) => Column(
              children: [
                PostOverview(postWithUser: postWithUser,),
                const SizedBox(
                  height: 20.0,
                )
              ],
            )).toList(),
          )
      ),
    );
  }
  
  void logout() async {
    await storage.delete(key: "user");
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const WelcomePage()), (route) => false);
  }
}