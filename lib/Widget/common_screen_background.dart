import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD4EBFF), // light blue
            Color(0xFFE7F3FF), // lighter blue
            Colors.white,      // white
          ],
        ),
      ),
      child: child,
    );
  }
}
