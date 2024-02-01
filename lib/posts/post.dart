import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:your_blog/models/post.dart';
import 'package:your_blog/models/user.dart';
import 'package:your_blog/network_handler.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:your_blog/posts/comments.dart';

import '../utils/functions.dart';

class PostView extends StatefulWidget {
  const PostView({
    super.key,
    required this.postId,
    required this.authorId,
  });
  final String postId;
  final String authorId;

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final storage = const FlutterSecureStorage();
  NetworkHandler network = NetworkHandler();
  var log = Logger();
  bool liked = false;
  bool bookmarked = false;
  int postNoComments = 0;
  PostModel post = PostModel(categoryId: "", userId: "", postTitle: "", postContent: "", postImage: "");
  UserModel author = UserModel(email: "", fullName: "", password: "");
  UserModel user = UserModel(email: "", fullName: "", password: "");
  bool dataLoaded = false;
  bool serverError = false;

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
      user = responseUser;
    });

    Response response2 = await network.get("/posts/post.php", {
      "postId": widget.postId
    });
    post = PostModel.fromJson(json.decode(response2.body));

    Response response3 = await network.get("/users/user.php", {
      "userId": widget.authorId
    });
    author = UserModel.fromJson(json.decode(response3.body));

    Response response4 = await network.get('/posts/comments.php', {
      'postId': widget.postId
    });
    int noComments = 0;
    if (response4.statusCode == 200) {
      noComments = (json.decode(response4.body) as List).length;
    }

    postNoComments = noComments;
    bookmarked = responseUser.favoritesPosts == null
        ? false
        : responseUser.favoritesPosts!.contains(widget.postId);

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context, 
                  MaterialPageRoute(
                      builder: (context) => CommentsPage(
                          postId: widget.postId
                      )
                  )
              );
            },
            child: Row(
              children: [
                Text(
                  '$postNoComments',
                  style: const TextStyle(
                    color: Colors.black
                  ),
                ),
                const SizedBox(
                  width: 2.5,
                ),
                const Icon(Icons.comment, color: Colors.black,)
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              Map<String, dynamic> body = {
                "categoryId": "PiEB7",
                "postTitle": post.postTitle,
                "postContent": post.postContent,
                "postImage": post.postImage,
                "likes": liked ? (post.likes! - 1) : (post.likes! + 1)
              };
              await network.post("/posts/updatepost.php", body, {
                "postId": post.postId,
              });
              Response response = await network.get("/posts/post.php", {
                "postId": widget.postId
              });
              setState(() {
                post = PostModel.fromJson(json.decode(response.body));
                liked = !liked;
              });
            },
            icon: Icon(
              Icons.thumb_up_sharp,
              color: liked ? Colors.blue : Colors.black,
            ),
          ),
          IconButton(
            onPressed: () async {
              Map<String, dynamic> body = {
                "email": user.email,
                "fullName": user.fullName,
                "username": user.username,
                "phoneNumber": user.phoneNumber,
                "bio": user.bio,
                "avatarUrl": user.avatarUrl,
                "favoritesPosts": user.favoritesPosts == null || user.favoritesPosts == ''
                    ? post.postId
                    : setFavoritesPosts(user.favoritesPosts!, post.postId!),
                "followers": user.followers,
                "password": user.password
              };
              await network.post("/users/updateuser.php", body, {
                "userId": user.userId,
              });
              Response response = await network.get("/users/user.php", {
                "userId": user.userId
              });
              setState(() {
                user = UserModel.fromJson(json.decode(response.body));
                bookmarked = !bookmarked;
              });
            },
            icon: Icon(
              Icons.bookmark_add,
              color: bookmarked ? Colors.blue : Colors.black,
            ),
          ),
        ],
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
      ) : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.postTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 15.0,
                      backgroundImage: author.avatarUrl == null
                          ? const AssetImage("assets/profiles/0.jpg")
                          : AssetImage(author.avatarUrl!),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                        author.fullName
                    ),
                  ],
                ),
                Text(
                    formatDate(post.postDate!)
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "${post.likes}"
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    const Icon(
                      Icons.thumb_up,
                      color: Colors.blue,
                      size: 20.0,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 1,
              decoration: const BoxDecoration(
                  color: Colors.grey
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            quill.QuillProvider(
              configurations: quill.QuillConfigurations(
                controller: quill.QuillController(
                  document: quill.Document.fromJson(
                    jsonDecode(
                      post.postContent,
                    ),
                  ),
                  selection: const TextSelection.collapsed(offset: 0),
                ),
                sharedConfigurations: const quill.QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
              ),
              child: quill.QuillEditor.basic(
                configurations: const quill.QuillEditorConfigurations(
                  readOnly: true,
                  autoFocus: false,
                  expands: false,
                  scrollable: true,
                  showCursor: false
                ),
                scrollController: ScrollController(),
                focusNode: FocusNode(),
              ),
            ),
          ],
        ),
      )
    );
  }
}