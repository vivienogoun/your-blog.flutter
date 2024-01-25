import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_blog/components/overlay_card.dart';
import 'package:your_blog/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_blog/shared_prefs.dart';

import '../network_handler.dart';
import '../screens/posts.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  SharedPrefs prefs = SharedPrefs();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool loading = false;
  var logger = Logger();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    Map<String, String> data;
    Map<String, dynamic> output;
    Response response;
    PostModel newPost;
    String localImagePath;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if(_imageFile?.path == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "No image uploaded",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                    backgroundColor: Colors.white,
                  )
                );
              }
              else if(_globalKey.currentState!.validate()) {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => OverlayCard(
                    imageFile: _imageFile!,
                    title: _titleController.text,
                    content: _contentController.text,
                  )),
                );
              }
            },
            child: const Text(
              "Preview",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          children: [
            TextButton(
              onPressed: () {
                uploadImage();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.file_upload_outlined),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Upload cover image"),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(_imageFile == null
                    ? "No file chosen"
                    : _imageFile!.name,
                    style: const TextStyle(
                      color: Colors.black87
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            titleInput(),
            const SizedBox(
              height: 10,
            ),
            contentInput(),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
                onPressed: () async => {
                  setState(() {
                    loading = true;
                  }),
                  if(_imageFile?.path == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "No image uploaded",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                        backgroundColor: Colors.white,
                      )
                    ),
                    setState(() {
                      loading = false;
                    }),
                  }
                  else if (_globalKey.currentState!.validate()) {
                    localImagePath = await saveImage(_imageFile!),
                    await prefs.save('localImagePath', localImagePath),
                    newPost = PostModel(
                      imageUrl: localImagePath,
                      title: _titleController.text,
                      content: _contentController.text
                    ),
                    response = await networkHandler.post("products/add", newPost.toJson()),
                    output = json.decode(response.body),
                    if (response.statusCode == 200 || response.statusCode == 201) {
                      logger.i(output["id"]),
                      setState(() {
                        loading = false;
                      }),
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostsScreen()), (route) => false)
                    } else {
                      logger.i(output["error"]),
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
                ) : const Text("Save Draft", style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),)
            )
          ],
        ),
      ),
    );
  }

  void uploadImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = file;
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> saveImage(XFile image) async {
    final String directoryPath = await _localPath;
    final String path = directoryPath + image.name;
    await image.saveTo(path);
    return path;
  }

  Widget titleInput() {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          validator: (value) {
            if (value!.isEmpty) return "Title can't be empty";
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
                  color: Colors.black,
                  width: 2,
                )
            ),
            labelText: "Title",
          ),
          maxLength: 50,
          maxLines: null,
        )
      ],
    );
  }

  Widget contentInput() {
    return Column(
      children: [
        TextFormField(
          controller: _contentController,
          validator: (value) {
            if (value!.isEmpty) return "Content can't be empty";
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
                  color: Colors.black,
                  width: 2,
                )
            ),
            labelText: "Content",
          ),
          maxLines: null,
        )
      ],
    );
  }
}