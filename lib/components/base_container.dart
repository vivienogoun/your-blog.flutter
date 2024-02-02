import 'package:flutter/material.dart';

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    super.key,
    required this.padding,
    required this.white,
    required this.child
  });
  final EdgeInsetsGeometry padding;
  final bool white;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
}