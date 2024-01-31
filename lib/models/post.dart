
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class PostModel {
  String? postId;
  String categoryId;
  String userId;
  String postTitle;
  String postContent;
  String postImage;
  int? likes;
  String? postDate;
  PostModel({required this.categoryId, required this.userId, required this.postTitle, required this.postContent, required this.postImage, this.likes, this.postDate});

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}