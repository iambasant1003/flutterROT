import 'package:flutter/material.dart';

class Loan112BorderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;

  // Optional text style params with defaults
  final String fontFamily;
  final FontWeight fontWeight;
  final double fontSize;
  final double height;
  final double letterSpacing;
  final Color textColor;
  final Color borderColor;

  const Loan112BorderButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.borderRadius = 50.0,
    this.fontFamily = 'Manrope',
    this.fontWeight = FontWeight.w700,
    this.fontSize = 18.0,
    this.height = 1.0,
    this.letterSpacing = 0.0,
    this.textColor = const Color(0XFF667085),
    this.borderColor = const Color(0XFF667085),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.transparent,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            backgroundColor: Colors.transparent, // no fill
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontWeight: fontWeight,
              fontSize: fontSize,
              height: height,
              letterSpacing: letterSpacing,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
