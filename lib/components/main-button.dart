import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.onPressed,
    required this.loading,
    required this.text
  });
  final void Function() onPressed;
  final bool loading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
          fixedSize: MaterialStatePropertyAll<Size>(
              Size(MediaQuery.of(context).size.width, 40.0)
          ),
          backgroundColor: const MaterialStatePropertyAll<Color>(Colors.black),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: loading ? const CircularProgressIndicator(
          color: Colors.white,
          strokeAlign: -2.0,
        ) : Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),)
    );
  }
}