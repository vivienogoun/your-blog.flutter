import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:your_blog/components/base_container.dart';
import 'package:your_blog/components/inputs/bio.dart';
import 'package:your_blog/components/inputs/email.dart';
import 'package:your_blog/components/inputs/password.dart';
import 'package:your_blog/components/main-button.dart';
import 'package:your_blog/models/user.dart';

import '../components/inputs/fullname.dart';
import '../network_handler.dart';
import '../posts/new.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool loading = false;
  final storage = const FlutterSecureStorage();
  bool dataLoaded = false;
  bool serverError = false;
  var log = Logger();
  UserModel user = UserModel(email: "", fullName: "", password: "");
  String? profilePath;

  @override
  void initState() {
    super.initState();
    getData();
  }
  void getData() async {
    String? userId = await storage.read(key: "userId");
    Response response = await networkHandler.get("/users/user.php", {
      "userId": userId
    });
    if (response.statusCode == 500) {
      setState(() {
        serverError = true;
      });
      return;
    }
    setState(() {
      user = UserModel.fromJson(json.decode(response.body));
      profilePath = user.avatarUrl;
      _fullnameController.text = user.fullName;
      _emailController.text = user.email;
      _bioController.text = user.bio ?? "";
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> output;
    Response response;

    Map<String, dynamic> body;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewPost(
                  edit: false,
                  userId: user.userId,
                ))
            );
          },
          child: const Icon(Icons.edit_note, size: 32,)
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfff6f6f6),
        foregroundColor: Colors.black,
        title: const Text('Profile'),
      ),
      body: serverError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something went wrong'),
            const Text('Check your internet connection'),
            TextButton(
              child: const Text('Refresh'),
              onPressed: () {
                setState(() {
                  serverError = false;
                  getData();
                });
              },
            )
          ],
        ),
      )
      : !dataLoaded ? const Center(
        child: CircularProgressIndicator(
          color: Colors.black54,
        ),
      ) : baseContainer(context, true,
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          Form(
              key: _globalKey,
              child: Column(
                children: [
                  profileImage(),
                  const SizedBox(
                    height: 20,
                  ),
                  fullnameInput(_fullnameController),
                  const SizedBox(
                    height: 20,
                  ),
                  emailInput(_emailController),
                  const SizedBox(
                    height: 20,
                  ),
                  PasswordInput(controller: _passwordController, update: true,),
                  const SizedBox(
                    height: 20,
                  ),
                  bioInput(_bioController),
                  const SizedBox(
                    height: 20.0,
                  ),
                  mainButton(
                      context,
                      loading,
                      "Save changes",
                      () async => {
                        setState(() {
                          loading = true;
                        }),
                        if (_globalKey.currentState!.validate()) {
                          body = {
                            "email": _emailController.text,
                            "fullName": _fullnameController.text,
                            "username": user.username,
                            "password": _passwordController.text == ""
                                ? user.password
                                : _passwordController.text,
                            "phoneNumber": user.phoneNumber,
                            "avatarUrl": profilePath,
                            "bio": _bioController.text,
                            "favoritesPosts": user.favoritesPosts,
                            "followers": user.followers,
                          },
                          response = await networkHandler.post("/users/updateuser.php", body, {
                            "userId": user.userId
                          }),
                          output = json.decode(response.body),
                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(output["message"]),
                                )
                            ),
                            setState(() {
                              loading = false;
                            }),
                          } else {
                            setState(() {
                              loading = false;
                            })
                          },
                        } else {
                          setState(() {
                            loading = false;
                          })
                        }
                      }
                  )
                ],
              )
          )
      )
    );
  }

  Widget profileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80.0,
            backgroundImage: profilePath == null
                ? const AssetImage("assets/profiles/0.jpg")
                : AssetImage(profilePath!),
          ),
          Positioned(
            bottom: -10.0,
            right: -10.0,
            child: IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                showModalBottomSheet(context: context, builder: ((builder) => bottomSheet()));
              },
            )
          )
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            "Choose profile photo",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Row(
                children: [
                  avatarChoice("assets/profiles/1.jpg"),
                  const SizedBox(
                    width: 5.0,
                  ),
                  avatarChoice("assets/profiles/2.jpg"),
                  const SizedBox(
                    width: 5.0,
                  ),
                  avatarChoice("assets/profiles/3.jpg")
                ],
              ),
              Row(
                children: [
                  avatarChoice("assets/profiles/4.jpg"),
                  const SizedBox(
                    width: 5.0,
                  ),
                  avatarChoice("assets/profiles/5.jpg"),
                  const SizedBox(
                    width: 5.0,
                  ),
                 avatarChoice("assets/profiles/6.jpg"),
                ],
              ),
              Row(
                children: [
                  avatarChoice("assets/profiles/7.jpg"),
                  const SizedBox(
                    width: 5.0,
                  ),
                  avatarChoice("assets/profiles/8.jpg"),
                  const SizedBox(
                    width: 5.0,
                  ),
                  avatarChoice("assets/profiles/9.jpg")
                ],
              )
            ],
          )
        ],
      ),
    );
  }
  
  Widget avatarChoice(String path) {
    return SizedBox(
      width: ((MediaQuery.of(context).size.width)/4)+10,
      child: InkWell(
        onTap: () {
          setState(() {
            profilePath = path;
          });
        },
        child: CircleAvatar(
            radius: 60.0,
            backgroundImage: AssetImage(path)
        ),
      ),
    );
  }
}