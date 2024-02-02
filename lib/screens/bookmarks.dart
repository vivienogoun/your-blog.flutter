import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:your_blog/components/cards/favorite_post.dart';
import 'package:your_blog/models/user.dart';

import '../components/base_container.dart';
import '../components/inputs/search.dart';
import '../models/post.dart';
import '../network_handler.dart';
import '../posts/new.dart';
import '../utils/functions.dart';
import '../utils/types.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final storage = const FlutterSecureStorage();
  NetworkHandler network = NetworkHandler();
  List<PostWithUser> allFavoritesPosts = [];
  List<PostWithUser> favoritesPosts = [];
  bool dataLoaded = false;
  bool serverError = false;
  UserModel currentUser = UserModel(email: "", fullName: "", password: "");

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    String? userId = await storage.read(key: "userId");
    Response response1 = await network.get("/users/user.php", {
      "userId": userId
    });
    if (response1.statusCode == 500) {
      setState(() {
        serverError = true;
      });
      return;
    }
    UserModel user = UserModel.fromJson(json.decode(response1.body));
    setState(() {
      currentUser = user;
    });

    Response response2 = await network.get("/posts/posts.php", {});
    setState(() {
      allFavoritesPosts = [];
    });
    (json.decode(response2.body) as List).map((e) => PostModel.fromJson(e)).toList().forEach((post) async {
      if (user.favoritesPosts != null && user.favoritesPosts!.contains(post.postId!)) {
        Response response = await network.get("/users/user.php", {
          "userId": post.userId
        });
        setState(() {
          allFavoritesPosts.add(PostWithUser(post: post, user: UserModel.fromJson(json.decode(response.body))));
        });
      }
    });
    setState(() {
      favoritesPosts = allFavoritesPosts;
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black12,
        foregroundColor: Colors.black,
        title: const Text('Favorites'),
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
                      favoritesPosts = favoritesPosts.where((element) =>
                      element.user.fullName.toLowerCase().contains(value.toLowerCase())
                          || element.post.postTitle.toLowerCase().contains(value.toLowerCase())
                          || element.post.postContent.toLowerCase().contains(value.toLowerCase())
                      ).toList();
                    })
                  } else {
                    setState(() {
                      favoritesPosts = allFavoritesPosts;
                    })
                  }
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewPost(
                  edit: false,
                  userId: currentUser.userId,
                ))
            );
          },
          child: const Icon(Icons.edit_note, size: 32,)
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
      ) : allFavoritesPosts.isEmpty
          ? Center(
        child: Image.asset(
          'assets/no_data.png',
          height: MediaQuery.of(context).size.height,
        ),
      )
          : BaseContainer(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 15.0,
        ),
        white: false,
        child: Column(
          children: favoritesPosts.map((postWithUser) => Column(
            children: [
              FavoritePostCard(
                postWithUser: postWithUser,
                removePost: () async {
                  setState(() {
                    dataLoaded = false;
                  });
                  Map<String, dynamic> body = {
                    "email": currentUser.email,
                    "fullName": currentUser.fullName,
                    "username": currentUser.username,
                    "phoneNumber": currentUser.phoneNumber,
                    "bio": currentUser.bio,
                    "avatarUrl": currentUser.avatarUrl,
                    "favoritesPosts": setFavoritesPosts(currentUser.favoritesPosts!, postWithUser.post.postId!),
                    "followers": currentUser.followers,
                    "password": currentUser.password
                  };
                  await network.post("/users/updateuser.php", body, {
                    "userId": currentUser.userId,
                  });
                  getData();
                },
              ),
              const SizedBox(
                height: 20.0,
              )
            ],
          )).toList(),
        ),
      )
    );
  }
}