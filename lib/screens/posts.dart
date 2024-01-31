import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:your_blog/components/cards/self_post.dart';
import 'package:your_blog/models/user.dart';

import '../components/base_container.dart';
import '../components/inputs/search.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../network_handler.dart';
import '../posts/new.dart';
import '../utils/types.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final storage = const FlutterSecureStorage();
  NetworkHandler network = NetworkHandler();
  List<PostWithAuthorAndComments> allSelfPosts = [];
  List<PostWithAuthorAndComments> selfPosts = [];
  var log = Logger();
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
    UserModel responseUser = UserModel.fromJson(json.decode(response1.body));
    setState(() {
      currentUser = responseUser;
    });

    Response response2 = await network.get("/posts/posts.php", {});
    setState(() {
      allSelfPosts = [];
    });
    (json.decode(response2.body) as List).map((e) => PostModel.fromJson(e)).toList().forEach((post) async {
      if (post.userId == responseUser.userId) {
        Response response1 = await network.get("/users/user.php", {
          "userId": post.userId
        });
        UserModel postAuthor = UserModel.fromJson(json.decode(response1.body));
        Response response2 = await network.get('/posts/comments.php', {
          'postId': post.postId
        });
        List<CommentModel> postComments = [];
        if (response2.statusCode == 200) {
          postComments = (json.decode(response2.body) as List).map((e) => CommentModel.fromJson(e)).toList();
        }
        setState(() {
          allSelfPosts.add(PostWithAuthorAndComments(
              post: post,
              author: postAuthor,
              comments: postComments)
          );
        });
      }
    });
    setState(() {
      selfPosts = allSelfPosts;
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
        title: const Text('My Posts'),
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
                      selfPosts = selfPosts.where((element) =>
                      element.author.fullName.toLowerCase().contains(value.toLowerCase())
                          || element.post.postTitle.toLowerCase().contains(value.toLowerCase())
                          || element.post.postContent.toLowerCase().contains(value.toLowerCase())
                      ).toList();
                    })
                  } else {
                    setState(() {
                      selfPosts = allSelfPosts;
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
      ) : allSelfPosts.isEmpty
          ? Center(
        child: Image.asset(
          'assets/no_data.png',
          height: MediaQuery.of(context).size.height,
        ),
      ) : baseContainer(
          context,
          false,
          const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 15.0,
          ),
          Column(
            children: selfPosts.map((selfPost) => Column(
              children: [
                SelfPostCard(
                  post: selfPost,
                  onEditPost: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewPost(
                          edit: true,
                          post: selfPost.post,
                        ))
                    );
                  },
                  onDeletePost: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Notice'),
                        content: const Text('The post will be definitely deleted with all its comments'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.blue
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                dataLoaded = false;
                              });
                              Navigator.of(ctx).pop();
                              Response response = await network.get('/posts/deletepost.php', {
                                'postId': selfPost.post.postId
                              });
                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Successfully deleted'),
                                    )
                                );
                                getData();
                              }
                            },
                            child: const Text(
                              'Ok',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                          )
                        ],
                      )
                    );
                  },
                ),
                const SizedBox(
                  height: 20.0,
                )
              ],
            )).toList(),
          )
      ),
    );
  }
}