import 'package:flutter/material.dart';

class LandingSectionLayout extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final double? height;

  const LandingSectionLayout({
    super.key,
    required this.backgroundColor,
    required this.child,
    this.height = 800,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallMobile = screenWidth <= 480;

    Widget container = Container(
      width: double.infinity,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isVerySmallMobile ? 20 : 0),
        child: child,
      ),
    );

    if (height != null) {
      return SizedBox(
        height: height,
        child: container,
      );
    }

    return container;
  }
}
