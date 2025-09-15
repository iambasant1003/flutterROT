import 'package:flutter/material.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';

class GetStartedSteps extends StatelessWidget {
  final List<String> stepToGetStarted;
  const GetStartedSteps({super.key,required this.stepToGetStarted});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: stepToGetStarted.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: ColorConstant.whiteColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: ColorConstant.textFieldBorderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: ColorConstant.appScreenBackgroundColor,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                          color: ColorConstant.blackTextColor,
                          fontSize: FontConstants.f14,
                          fontFamily: FontConstants.fontFamily,
                          fontWeight: FontConstants.w700
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      stepToGetStarted[index],
                      style:  TextStyle(
                          fontSize: FontConstants.f14,
                          fontWeight: FontConstants.w600,
                          fontFamily: FontConstants.fontFamily,
                          color: ColorConstant.blackTextColor
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (index != stepToGetStarted.length - 1)
               Padding(
                 padding: EdgeInsets.only(left: FontConstants.horizontalPadding+10.0),
                 child: Container(
                   width: 2,
                   height: 10,
                   color: Colors.blue,
                 ),
               ),

          ],
        );
      },
    );
  }
}
