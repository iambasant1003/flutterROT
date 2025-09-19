import 'package:flutter/material.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';

class CircularProgressWithText extends StatelessWidget {
  final double progress; // 0.1 for 10%
  final bool isDrawer;

  const CircularProgressWithText({super.key, required this.progress,required this.isDrawer});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress arc with incomplete part in lightBlue
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: Colors.lightBlue.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(ColorConstant.appThemeColor),
            ),
          ),
          if(isDrawer)...[
            Image.asset(ImageConstants.drawerProfile)
          ]else...[
            // Inner white circle with shadow
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.appThemeColor,
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
