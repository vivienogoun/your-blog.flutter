import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:your_blog/posts/post.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../utils/functions.dart';
import '../../utils/types.dart';

class SelfPostCard extends StatelessWidget {
  const SelfPostCard({
    super.key,
    required this.post,
    required this.onEditPost,
    required this.onDeletePost,
  });
  final PostWithAuthorAndComments post;
  final void Function() onEditPost;
  final void Function() onDeletePost;

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
            post.post.postTitle,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  formatDate(post.post.postDate!)
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "${post.post.likes}"
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
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "${post.comments.length}"
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      const Icon(
                        Icons.comment,
                        color: Colors.blue,
                        size: 20.0,
                      )
                    ],
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 20.0,
                    ),
                    onPressed: onEditPost,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: 20.0,
                    ),
                    onPressed: onDeletePost,
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 5,
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
                    post.post.postContent,
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
                          postId: post.post.postId!,
                          authorId: post.post.userId,
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
              child: const Text("View as guest", style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),)
          )
        ],
      ),
    );
  }
}