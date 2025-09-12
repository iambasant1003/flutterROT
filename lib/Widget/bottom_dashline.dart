import 'package:flutter/material.dart';

class BottomDashLine extends StatelessWidget {
  const BottomDashLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      decoration: BoxDecoration(
        color: const Color(0xFFD1EAFF),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD1EAFF).withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
