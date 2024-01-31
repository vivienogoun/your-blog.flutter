import 'package:flutter/material.dart';

Widget fullnameInput(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value!.isEmpty) return "Full name can't be empty";
      return null;
    },
    decoration: const InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          )
      ),
      labelText: "Full name",
    ),
  );
}