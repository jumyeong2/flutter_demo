import 'package:flutter/material.dart';

class LandingSectionLayout extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final double height;

  const LandingSectionLayout({
    super.key,
    required this.backgroundColor,
    required this.child,
    this.height = 800,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: backgroundColor,
      child: child,
    );
  }
}
