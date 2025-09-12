
import 'package:flutter/material.dart';

class Loan112ConcaveContainer extends StatelessWidget {
  final double height;
  const Loan112ConcaveContainer({super.key,required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ConcaveBottomClipper(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
            color: const Color(0xFFE3F4E1), // #E3F4E1
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40))
        ),
      ),
    );
  }
}

class ConcaveBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 30); // left bottom before curve

    path.quadraticBezierTo(
      size.width / 2, size.height + 30, // control point
      size.width, size.height - 30, // end point
    );

    path.lineTo(size.width, 0); // top-right
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

