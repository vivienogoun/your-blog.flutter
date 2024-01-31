import 'package:your_blog/models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';

class PostWithUser {
  PostModel post;
  UserModel user;
  PostWithUser({required this.post, required this.user});
}

class PostWithAuthorAndComments {
  PostModel post;
  UserModel author;
  List<CommentModel> comments;
  PostWithAuthorAndComments({
    required this.post,
    required this.author,
    required this.comments,
  });
}

class CommentWithAuthor {
  CommentModel comment;
  UserModel author;
  CommentWithAuthor({required this.comment, required this.author});
}