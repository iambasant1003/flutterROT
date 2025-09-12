


import 'package:flutter/material.dart';

import '../Constant/ColorConst/ColorConstant.dart';

openSnackBar(BuildContext context, String message, {Color? backGroundColor}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating, // Makes it float above bottom
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16), // Add spacing
      backgroundColor: backGroundColor ?? ColorConstant.errorRedColor,
      content: Text(message.toString()),
    ),
  );
}

