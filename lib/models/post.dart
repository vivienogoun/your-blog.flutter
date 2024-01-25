
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class PostModel {
  String? imageUrl;
  String? title;
  String? content;
  PostModel({this.imageUrl, this.title, this.content});

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}