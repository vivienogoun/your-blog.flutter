import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key, required this.controller, required this.update});
  final TextEditingController controller;
  final bool update;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (widget.update) return null;
        if (value!.isEmpty) return "Password can't be empty";
        if (value.length < 8) return "Password should have more than 8 characters";
        return null;
      },
      obscureText: showPassword,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility)
        ),
        border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            )
        ),
        labelText: "Password"
      ),
    );
  }
}