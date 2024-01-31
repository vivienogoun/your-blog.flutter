import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:your_blog/posts/post.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../utils/functions.dart';
import '../utils/types.dart';

class PostOverview extends StatelessWidget {
  const PostOverview({
    super.key,
    required this.postWithUser
  });
  final PostWithUser postWithUser;

  @override
  Widget build(BuildContext context) {
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
                    backgroundImage: postWithUser.user.avatarUrl == null || postWithUser.user.avatarUrl!.endsWith("png")
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
          quill.QuillProvider(
            configurations: quill.QuillConfigurations(
              controller: quill.QuillController(
                document: quill.Document.fromJson(
                    jsonDecode(
                      postWithUser.post.postContent,
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
                maxHeight: 67.0,
                showCursor: false
              ),
              scrollController: ScrollController(),
              focusNode: FocusNode(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostView(
                          postId: postWithUser.post.postId!,
                          authorId: postWithUser.post.userId,
                        )
                    ))
              },
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll<Size>(
                    Size(MediaQuery.of(context).size.width, 45.0)
                ),
                backgroundColor: const MaterialStatePropertyAll<Color>(Colors.black87),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: const Text("Read more", style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),)
          )
        ],
      ),
    );
  }
}