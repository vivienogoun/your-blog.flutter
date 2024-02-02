import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:your_blog/components/main-button.dart';
import 'package:your_blog/posts/post.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../utils/functions.dart';
import '../../utils/types.dart';

class PostOverview extends StatelessWidget {
  const PostOverview({
    super.key,
    required this.postWithUser
  });
  final PostWithUser postWithUser;

  @override
  Widget build(BuildContext context) {
    String postContentString = quill.Document.fromJson(
      jsonDecode(
        postWithUser.post.postContent,
      ),
    ).toPlainText();

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xfff6f6f6),
        borderRadius: BorderRadius.circular(9.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            postWithUser.post.postTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 15.0,
                    backgroundImage: postWithUser.user.avatarUrl == null
                        ? const AssetImage("assets/profiles/0.jpg")
                        : AssetImage(postWithUser.user.avatarUrl!),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                      postWithUser.user.fullName
                  ),
                ],
              ),
              Text(
                formatDate(postWithUser.post.postDate!)
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 1,
            decoration: const BoxDecoration(
              color: Colors.black45
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(postContentString.length > 125
              ? '${postContentString.substring(0, 125)}...'
              : postContentString,
          ),
          const SizedBox(
            height: 10,
          ),
          MainButton(
            text: 'Read more',
            loading: false,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostView(
                  postId: postWithUser.post.postId!,
                  authorId: postWithUser.post.userId,
                )
              )),
          )
        ],
      ),
    );
  }
}