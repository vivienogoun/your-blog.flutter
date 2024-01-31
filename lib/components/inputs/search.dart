import 'package:flutter/material.dart';

Widget searchInput(void Function(String)? onChanged) {
  return TextFormField(
    //controller: controller,
    onChanged: onChanged,
    decoration: const InputDecoration(
      fillColor: Color(0xfff6f6f6),
      filled: true,
      suffixIcon: Icon(Icons.search),
      hintText: "Search"
    ),
  );
}