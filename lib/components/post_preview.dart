import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class PostPreview extends StatelessWidget {
  const PostPreview({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      child: ListView(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            decoration: const BoxDecoration(
                color: Colors.black45
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          quill.QuillProvider(
            configurations: quill.QuillConfigurations(
              controller: quill.QuillController(
                document: quill.Document.fromJson(
                  jsonDecode(content)
                ),
                selection: const TextSelection.collapsed(offset: 0),
              ),
              sharedConfigurations: const quill.QuillSharedConfigurations(
                locale: Locale('en'),
              ),
            ),
            child: quill.QuillEditor.basic(
              configurations: const quill.QuillEditorConfigurations(
                readOnly: true,
                padding: EdgeInsets.all(8),
                autoFocus: false,
                expands: false,
                scrollable: true,
              ),
              scrollController: ScrollController(),
              focusNode: FocusNode(),
            ),
          ),
        ],
      ),
    );
  }
}