
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel {
  String? userId;
  String email;
  String fullName;
  String? username;
  String? phoneNumber;
  String? bio;
  String? avatarUrl;
  String? favoritesPosts;
  int? followers;
  String password;
  UserModel({required this.email, required this.fullName, this.username, this.phoneNumber, this.bio, this.avatarUrl, this.favoritesPosts, this.followers, required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}