import 'package:flutter/material.dart';

Widget commentInput(TextEditingController controller, String hintText, void Function()? onPressed) {
  return Container(
    decoration: const BoxDecoration(
      boxShadow: [BoxShadow(
        color: Colors.grey,
        blurRadius: 5.0
      )]
    ),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: const Color(0xfff6f6f6),
        filled: true,
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.send,
            color: Colors.green,
          ),
          onPressed: onPressed,
        ),
        hintText: hintText,
      ),
    ),
  );
}