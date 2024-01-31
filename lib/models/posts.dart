import 'package:json_annotation/json_annotation.dart';
import 'package:your_blog/models/post.dart';

part 'posts.g.dart';

@JsonSerializable()
class PostsModel {
  List<PostModel>? posts;
  PostsModel({this.posts});

  factory PostsModel.fromJson(Map<String, dynamic> json) => _$PostsModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostsModelToJson(this);
}