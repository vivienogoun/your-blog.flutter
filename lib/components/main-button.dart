import 'package:flutter/material.dart';

Widget mainButton(BuildContext context, bool loading, String text, void Function() onPressed) {
  return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: MaterialStatePropertyAll<Size>(
            Size(MediaQuery.of(context).size.width, 40.0)
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
      ) : Text(
        text,
        style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),)
  );
}