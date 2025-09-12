
import 'package:flutter/material.dart';
import 'package:loan112_app/Constant/ColorConst/ColorConstant.dart';
import 'package:loan112_app/Constant/FontConstant/FontConstant.dart';

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

