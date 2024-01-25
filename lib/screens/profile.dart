import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_blog/models/profile.dart';

import '../network_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  bool loading = false;
  final storage = const FlutterSecureStorage();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool dataLoaded = false;
  var log = Logger();
  ProfileModel profileModel = ProfileModel();

  @override
  void initState() {
    super.initState();
    getUserData();
  }
  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileModel = ProfileModel.fromJson(json.decode(prefs.getString("userData")!));
      _usernameController.text = profileModel.username!;
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> data;
    Map<String, dynamic> output;
    Response response;

    StreamedResponse imageResponse;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: () {},
        ),
      ),
      body: !dataLoaded ? const Center(
        child: CircularProgressIndicator(
          color: Colors.black54,
        ),
      ) : Container(
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
          child: Form(
              key: _globalKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                children: [
                  profileImage(),
                  const SizedBox(
                    height: 20,
                  ),
                  usernameInput(),
                  const SizedBox(
                    height: 20,
                  ),
                  nameInput(),
                  const SizedBox(
                    height: 20,
                  ),
                  aboutInput(),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: FilledButton(
                        onPressed: () async => {
                          setState(() {
                            loading = true;
                          }),
                          if (_globalKey.currentState!.validate()) {
                            data = {
                              "username": _usernameController.value.text,
                              "name": _nameController.value.text,
                              "about": _aboutController.value.text,
                            },
                            print(data),
                            response = await networkHandler.post("products/add", data),
                            output = json.decode(response.body),
                            if (response.statusCode == 200 || response.statusCode == 201) {
                              if(_imageFile!.path != null) {
                                imageResponse = await networkHandler.patchImage("url", _imageFile!.path)
                              },
                              print(output["id"]),
                              await storage.write(key: "id", value: '$output["id"]'),
                              setState(() {
                                loading = false;
                              }),
                              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false)
                            } else {
                              print(output["error"]),
                              setState(() {
                                loading = false;
                              })
                            },
                          } else {
                            setState(() {
                              loading = false;
                            })
                          }
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStatePropertyAll<Size>(
                              Size(MediaQuery.of(context).size.width, 60.0)
                          ),
                          backgroundColor: const MaterialStatePropertyAll<Color>(Colors.black87),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: loading ? const CircularProgressIndicator(
                          color: Colors.white,
                        ) : const Text("Save changes", style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),)
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }

  Widget profileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80.0,
            backgroundImage: _imageFile == null
                ? const AssetImage("assets/graphics.png")
                : FileImage(File(_imageFile!.path)) as ImageProvider,
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
      height: 100,
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
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt),
                tooltip: "Camera",
              ),
              const Text(
                "Camera"
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: const Icon(Icons.image),
                tooltip: "Gallery",
              ),
              const Text(
                "Gallery"
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = file;
    });
  }

  Widget usernameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Username",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _usernameController,
          validator: (value) {
            if (value!.isEmpty) return "Username can't be empty";
            // verify if username is unique
            return null;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2,
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2,
              )
            ),
          ),
        )
      ],
    );
  }

  Widget nameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Name",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _nameController,
          validator: (value) {
            if (value!.isEmpty) return "Name can't be empty";
            return null;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2,
                )
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2,
                )
            ),
          ),
        )
      ],
    );
  }

  Widget aboutInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "About",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLines: 4,
          controller: _aboutController,
          /*validator: (value) {
            if (value!.isEmpty) return "Name can't be empty";
            return null;
          },*/
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2,
                )
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2,
                )
            ),
          ),
        )
      ],
    );
  }
}