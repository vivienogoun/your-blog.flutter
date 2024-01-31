// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      categoryId: json['categoryId'] as String,
      userId: json['userId'] as String,
      postTitle: json['postTitle'] as String,
      postContent: json['postContent'] as String,
      postImage: json['postImage'] as String,
      likes: json['likes'] as int?,
      postDate: json['postDate'] as String?,
    )..postId = json['postId'] as String?;

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'postId': instance.postId,
      'categoryId': instance.categoryId,
      'userId': instance.userId,
      'postTitle': instance.postTitle,
      'postContent': instance.postContent,
      'postImage': instance.postImage,
      'likes': instance.likes,
      'postDate': instance.postDate,
    };
