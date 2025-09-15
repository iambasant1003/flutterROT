
import 'package:flutter/material.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';

class StepItem extends StatelessWidget {
  final String title;
  final int status; // 0, 1, or 2

  const StepItem({
    super.key,
    required this.title,
    this.status = 0,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = status == 1 || status == 2 ? Colors.blue : Colors.grey.shade300;

    Gradient? gradient = status == 1
        ? const LinearGradient(
      colors: [
        Color(0xFF2B3C74), // dark blue
        Color(0xFF5171DA), // light blue
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    )
        : null;

    Color bgColor = status == 2
        ? Colors.white
        : Colors.grey.shade100;

    Widget leadingIcon = status == 1
        ? const Icon(Icons.check_circle, color: Colors.white)
        : Icon(Icons.arrow_forward, color: Color(0xFF2B3C74));

    TextStyle textStyle = (status == 1 || status == 2)
        ? TextStyle(
      color: status == 1 ? Colors.white : ColorConstant.blackTextColor,
      fontWeight: FontConstants.w700,
      fontFamily: FontConstants.fontFamily,
      fontSize: FontConstants.f16,
    )
        : TextStyle(
      color: ColorConstant.dashboardTextColor,
      fontWeight: FontConstants.w500,
      fontFamily: FontConstants.fontFamily,
      fontSize: FontConstants.f16,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12.0),
      decoration: BoxDecoration(
        color: gradient == null ? bgColor : null,
        gradient: gradient,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          leadingIcon,
          SizedBox(
            width: 12,
          ),
          Text(title, style: textStyle),
        ],
      )

      // ListTile(
      //   leading: leadingIcon,
      //   title: Text(title, style: textStyle),
      // ),
    );
  }
}



class JourneyStepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final int state; // 0 - current, 1 - done, 2 - upcoming
  final VoidCallback? onTap;

  const JourneyStepCard({
    Key? key,
    required this.stepNumber,
    required this.title,
    required this.state,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;
    Color textColor;
    Icon? trailingIcon;

    switch (state) {
      case 1: // Done
        borderColor = ColorConstant.permissionPageTextColor;
        bgColor = Colors.white;
        textColor = Colors.black;
        trailingIcon = const Icon(Icons.check_circle, color: ColorConstant.appThemeColor);
        break;
      case 2: // Current
        borderColor = Colors.black12;
        bgColor = Colors.white;
        textColor = Colors.black;
        trailingIcon = const Icon(Icons.pause_circle_filled_outlined, color: Colors.teal);
        break;
      default: // Upcoming
        borderColor = Colors.grey.shade300;
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey;
        trailingIcon = const Icon(Icons.check_circle, color: Colors.grey);
    }

    return GestureDetector(
      onTap: state == 0 ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Text(
              "Step: $stepNumber",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailingIcon,
          ],
        ),
      ),
    );
  }
}

