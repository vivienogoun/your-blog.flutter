import 'package:flutter/material.dart';

Widget baseContainer(BuildContext context, bool white, EdgeInsetsGeometry padding, Widget child) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    padding: padding,
    decoration: BoxDecoration(
      color: white ? const Color(0xfff5f5f5) : Colors.black12,
    ),
    child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: child,
    )
  );
}