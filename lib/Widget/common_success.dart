import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import '../Constant/ColorConst/ColorConstant.dart';
import '../Constant/FontConstant/FontConstant.dart';
import '../Constant/ImageConstant/ImageConstants.dart';
import 'app_bar.dart';
import 'eligibility_status_background.dart';

class Loan112VerifyStatusPage extends StatelessWidget{
final bool isSuccess;
final String statusType;
final String statusMessage;
final String iconTypePath;
final Loan112Button loan112button;
final VoidCallback? onBackPress;

const Loan112VerifyStatusPage({
  super.key,
  this.onBackPress,
  required this.isSuccess,required this.statusType,required this.statusMessage,
  required this.iconTypePath,required this.loan112button
});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Loan112AppBar(
        backgroundColor: Color(0xffE7F3FF),
        customLeading: InkWell(
          onTap: onBackPress ??
              (){
            context.pop();
          },
          child: Icon(Icons.arrow_back_ios,color: ColorConstant.blackTextColor),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Loan112ConcaveContainer(height: 150),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: -60,
                        child: Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            color: ColorConstant.whiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isSuccess?
                            SvgPicture.asset(ImageConstants.successIcon):
                            Image.asset(ImageConstants.failedIcon),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 65),
                  Center(
                    child: Text(
                      isSuccess? "Congratulations!":"Try Again",
                      style: TextStyle(
                        fontSize: FontConstants.f22,
                        fontWeight: FontConstants.w800,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.blackTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Center(
                    child: Image.asset(
                      iconTypePath,
                      width: 104,
                      height: 67,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                    child: Center(
                      child: Text(
                        statusMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: FontConstants.f14,
                          fontFamily: FontConstants.fontFamily,
                          fontWeight: FontConstants.w500,
                          color: ColorConstant.blackTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 43.0),
                ],
              ),
            ),
          ),
          // 👇 Buttons pinned to bottom
          Column(
            children: [
              BottomDashLine(),
              SizedBox(
                height: 18.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                child: Column(
                  children: [
                    loan112button,
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

}

