import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OverlayCard extends StatelessWidget {
  const OverlayCard({
    super.key,
    required this.imageFile,
    required this.title,
    required this.content,
  });
  final XFile imageFile;
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
            height: 300,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(imageFile.path)),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          /*Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(imageFile!.path)),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0x55000000),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),*/
        ],
      ),
    );
  }
}