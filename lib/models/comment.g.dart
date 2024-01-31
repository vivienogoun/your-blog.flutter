// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      comment: json['comment'] as String,
    )..commentId = json['commentId'] as String?;

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'postId': instance.postId,
      'userId': instance.userId,
      'comment': instance.comment,
    };
