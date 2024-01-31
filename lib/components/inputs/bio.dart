import 'package:flutter/material.dart';

Widget bioInput(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    maxLines: 4,
    decoration: const InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          )
      ),
      labelText: "Bio",
    ),
  );
}