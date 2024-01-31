// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      username: json['username'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      favoritesPosts: json['favoritesPosts'] as String?,
      followers: json['followers'] as int?,
      password: json['password'] as String,
    )..userId = json['userId'] as String?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'fullName': instance.fullName,
      'username': instance.username,
      'phoneNumber': instance.phoneNumber,
      'bio': instance.bio,
      'avatarUrl': instance.avatarUrl,
      'favoritesPosts': instance.favoritesPosts,
      'followers': instance.followers,
      'password': instance.password,
    };
