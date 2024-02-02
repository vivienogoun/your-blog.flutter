import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:your_blog/components/base_container.dart';
import 'package:your_blog/components/cards/comment.dart';
import 'package:your_blog/components/inputs/comment.dart';
import 'package:your_blog/models/comment.dart';

import '../models/user.dart';
import '../network_handler.dart';
import '../utils/types.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key, required this.postId});
  final String postId;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final storage = const FlutterSecureStorage();
  UserModel user = UserModel(email: "", fullName: "", password: "");
  NetworkHandler network = NetworkHandler();
  List<CommentWithAuthor> comments = [];
  bool dataLoaded = false;
  bool serverError = false;
  final TextEditingController _commentController = TextEditingController();

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
    setState(() {
      user = UserModel.fromJson(json.decode(response1.body));
    });

    Response response2 = await network.get('/posts/comments.php', {
      'postId': widget.postId
    });
    if (response2.statusCode == 200) {
      (json.decode(response2.body) as List).map(
              (e) => CommentModel.fromJson(e)
      ).toList().forEach(
        (comment) async {
          Response response = await network.get('/users/user.php', {
            'userId': comment.userId
          });
          setState(() {
            comments.add(
              CommentWithAuthor(
                  comment: comment,
                  author: UserModel.fromJson(json.decode(response.body))
              )
            );
          });
        }
      );
      setState(() {
        dataLoaded = true;
      });
    }
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfff6f6f6),
        foregroundColor: Colors.black,
        title: Text('Comments (${comments.length})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomSheet: commentInput(
        _commentController,
        comments.isNotEmpty ? 'Share your thoughts' : 'Be the first to comment',
        () async {
          if (_commentController.text.isNotEmpty) {
            Map<String, dynamic> body = {
              'userId': user.userId,
              'postId': widget.postId,
              'comment': _commentController.text
            };
            await network.post('/comments/comment.php', body, {});
            Response response = await network.get('/posts/comments.php', {
              'postId': widget.postId
            });
            if (response.statusCode == 200) {
              setState(() {
                comments = [];
              });
              (json.decode(response.body) as List).map(
                      (e) => CommentModel.fromJson(e)
              ).toList().forEach(
                      (comment) async {
                      Response response = await network.get('/users/user.php', {
                        'userId': comment.userId
                      });
                      setState(() {
                        comments.add(
                            CommentWithAuthor(
                                comment: comment,
                                author: UserModel.fromJson(json.decode(response.body))
                            )
                        );
                      });
                  }
              );
            }
            _commentController.text = '';
            FocusManager.instance.primaryFocus?.unfocus();
          }
        }
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
      ) : comments.isEmpty
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
        white: true,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            children: comments.map((comment) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 0.0
                  ),
                  child: CommentCard(comment: comment),
                ),
                Container(
                  height: 1,
                  decoration: const BoxDecoration(
                      color: Colors.grey
                  ),
                ),
              ],
            )).toList(),
          ),
        ),
      )
    );
  }
}
