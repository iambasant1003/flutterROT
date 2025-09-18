import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Screens/loanApplicationPage/loanApplicationOptions/bankStatement/newBREJourney/new_breBackground.dart';
import 'package:rupeeontime/Widget/common_border_button.dart';
import '../../Constant/ColorConst/ColorConstant.dart';
import '../../Constant/FontConstant/FontConstant.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import '../../Routes/app_router_name.dart';
import '../../Utils/MysharePrefenceClass.dart';
import '../../Widget/app_bar.dart';
import '../../Widget/bottom_dashline.dart';
import '../../Widget/common_button.dart';

class SessionTimeOutLoan112 extends StatefulWidget{
  const SessionTimeOutLoan112({super.key});

  @override
  State<StatefulWidget> createState() => _SessionTimeOutLoan112();
}

class _SessionTimeOutLoan112 extends State<SessionTimeOutLoan112>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appThemeColor,
      appBar: Loan112AppBar(
        backgroundColor: ColorConstant.appThemeColor,
        customLeading: InkWell(
          onTap: () async{
            var logOutData = await MySharedPreferences.logOutFunctionData();
            if(logOutData){
              context.go(AppRouterName.login);
            }
          },
          child: Icon(
              Icons.arrow_back, color: ColorConstant.whiteColor),
        ),
        title: Text(
          "Status of Application",
          style: TextStyle(
            fontSize: FontConstants.f18,
            fontFamily: FontConstants.fontFamily,
            fontWeight: FontConstants.w700,
            color: ColorConstant.whiteColor
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(54.0),
            topRight: Radius.circular(54.0),
          )
        ),
        child:  Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 34),
                    Stack(
                      children: [
                        Container(
                          height: 252,
                          width: 252,
                          padding: EdgeInsets.all(20), // padding from all sides
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorConstant.appThemeColor, // border color
                              width: 3, // border width
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          right: 50,
                          top: 50,
                          bottom: 50,
                          child: Image.asset(
                            ImageConstants.rotSessionTimeOut,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
            HalfMoonContainer(),
            // 👇 Buttons pinned to bottom
            Container(
              color: ColorConstant.appThemeColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: FontConstants.horizontalPadding),
                    child:  Loan112BorderButton(
                      borderColor: ColorConstant.whiteColor,
                      text: "Go to Login",
                      textColor: ColorConstant.whiteColor,
                      onPressed: () async{
                        var logOutData = await MySharedPreferences.logOutFunctionData();
                        if(logOutData){
                          context.go(AppRouterName.login);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Center(
                    child: InkWell(
                      onTap: (){
                        context.push(AppRouterName.customerSupport);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Need  Help..?",
                            style: TextStyle(
                                color: ColorConstant.whiteColor,
                                fontSize: FontConstants.f14,
                                fontWeight: FontConstants.w600,
                                fontFamily: FontConstants.fontFamily
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "contact us",
                            style: TextStyle(
                                color: ColorConstant.whiteColor,
                                fontSize: FontConstants.f14,
                                fontWeight: FontConstants.w600,
                                fontFamily: FontConstants.fontFamily
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

}



class HalfMoonContainer extends StatelessWidget {
  const HalfMoonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HalfMoonClipper(),
      child: Container(
        width: double.infinity,
        height: 350, // adjust as needed
        color:  ColorConstant.appThemeColor, // your teal color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              "Session Timeout",
              style: TextStyle(
                color: ColorConstant.whiteColor,
                fontSize: FontConstants.f26,
                fontWeight: FontConstants.w700,
                fontFamily: FontConstants.fontFamily
              ),
            ),
            const SizedBox(height: 14.0),
             Text(
              "You have been logged out due to inactivity",
              style: TextStyle(
                  color: ColorConstant.whiteColor,
                  fontSize: FontConstants.f18,
                  fontWeight: FontConstants.w700,
                  fontFamily: FontConstants.fontFamily
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class HalfMoonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from bottom-left
    path.lineTo(0, size.height);

    // Bottom line
    path.lineTo(size.width, size.height);

    // Right edge up
    path.lineTo(size.width, 100);

    // Arc (half moon shape at the top)
    path.quadraticBezierTo(
      size.width / 2, // control point in center
      -100,           // curve upwards
      0, 100,         // end point left
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}






