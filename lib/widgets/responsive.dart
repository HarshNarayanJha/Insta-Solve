import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const Responsive({super.key, required this.child, this.maxWidth = 600});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
