import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:your_blog/components/base_container.dart';
import 'package:your_blog/components/main-button.dart';
import 'package:your_blog/components/post_preview.dart';
import 'package:your_blog/models/post.dart';
import 'package:your_blog/pages/home.dart';

import '../network_handler.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key, required this.edit, this.userId, this.post});
  final bool edit;
  final String? userId;
  final PostModel? post;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _titleController = TextEditingController();
  bool loading = false;
  quill.QuillController quillController = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    if (widget.edit) {
      _titleController.text = widget.post!.postTitle;
      quillController = quill.QuillController(
        document: quill.Document.fromJson(
          jsonDecode(
            widget.post!.postContent,
          ),
        ),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> output;
    Response response;
    Map<String, dynamic> body;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfff6f6f6),
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
              if(_globalKey.currentState!.validate()) {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => PostPreview(
                    title: _titleController.text,
                    content: jsonEncode(quillController.document.toDelta().toJson()),
                  )),
                );
              }
            },
            child: const Text(
              "Preview",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black
              ),
            ),
          ),
        ],
      ),
      body: BaseContainer(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        white: true,
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              titleInput(widget.edit),
              const SizedBox(height: 20),
              quill.QuillProvider(
                configurations: quill.QuillConfigurations(
                  controller: quillController,
                  sharedConfigurations: const quill.QuillSharedConfigurations(
                    locale: Locale('en'),
                  ),
                ),
                child: Column(
                  children: [
                    const quill.QuillToolbar(),
                    quill.QuillEditor.basic(
                      configurations: const quill.QuillEditorConfigurations(
                        readOnly: false,
                        padding: EdgeInsets.all(8),
                        autoFocus: false,
                        expands: false,
                        scrollable: true,
                        placeholder: "Content...",
                      ),
                      scrollController: ScrollController(),
                      focusNode: FocusNode(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MainButton(
                text: widget.edit ? 'Publish changes' : 'Publish',
                loading: loading,
                onPressed: () async => {
                  setState(() {
                    loading = true;
                  }),
                  if (_globalKey.currentState!.validate()) {
                    body = widget.edit
                        ? {
                      'postTitle': _titleController.text,
                      'postContent': jsonEncode(quillController.document.toDelta().toJson()),
                      'postImage': widget.post!.postImage,
                      'categoryId': widget.post!.categoryId,
                      'likes': widget.post!.likes
                    }
                        : {
                      'postTitle': _titleController.text,
                      'postContent': jsonEncode(quillController.document.toDelta().toJson()),
                      'postImage': '',
                      'userId': widget.userId!,
                      'categoryId': 'PiEB7'
                    },
                    response = widget.edit
                        ? await networkHandler.post('/posts/updatepost.php', body, {
                      'postId': widget.post!.postId
                    })
                        : await networkHandler.post("/posts/post.php", body, {}),
                    if (response.statusCode == 500 && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Something went wrong. Please retry'),
                          )
                      ),
                      setState(() {
                        loading = false;
                      }),
                    } else if (response.statusCode == 200 && context.mounted) {
                      output = json.decode(response.body),
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(output["message"]),
                          )
                      ),
                      setState(() {
                        loading = false;
                      }),
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false)
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
                },
              ),
            ],
          )
        ),
      )
    );
  }

  Widget titleInput(bool edit) {
    return Column(
      children: [
        TextFormField(
          readOnly: edit ? true : false,
          controller: _titleController,
          validator: (value) {
            if (value!.isEmpty) return "Title can't be empty";
            return null;
          },
          decoration: const InputDecoration(
            border: UnderlineInputBorder(
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
}