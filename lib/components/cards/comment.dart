import 'package:flutter/material.dart';
import 'package:your_blog/utils/types.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});
  final CommentWithAuthor comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 15.0,
              backgroundImage: comment.author.avatarUrl == null
                  ? const AssetImage("assets/profiles/0.jpg")
                  : AssetImage(comment.author.avatarUrl!),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
                comment.author.fullName
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(comment.comment.comment)
      ],
    );
  }
}