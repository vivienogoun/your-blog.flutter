import 'package:flutter/material.dart';

Widget emailInput(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value!.isEmpty) return "Email can't be empty";
      if (!value.contains("@")) return "Email is invalid";
      return null;
    },
    decoration: const InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          )
      ),
      labelText: "Email",
    ),
  );
}