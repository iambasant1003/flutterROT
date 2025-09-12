import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/bankStatement/newBREJourney/new_breBackground.dart';
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
      appBar: Loan112AppBar(
        backgroundColor: Color(0xffE7F3FF),
        customLeading: InkWell(
          onTap: () async{
            var logOutData = await MySharedPreferences.logOutFunctionData();
            if(logOutData){
              context.go(AppRouterName.login);
            }
          },
          child: Icon(
              Icons.arrow_back_ios, color: ColorConstant.blackTextColor),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Loan112BREBackground(height: 150, containerColor: Color(0xffE0E0E0)),
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
                              child: Image.asset(
                                  ImageConstants.sessionTimeOutIcon,
                                  width: 72,
                                  height: 72,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 65),
                    Text(
                      "Session Timeout",
                      style: TextStyle(
                        fontSize: FontConstants.f22,
                        fontWeight: FontConstants.w800,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.blackTextColor,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: FontConstants.horizontalPadding),
                      child: Column(
                        children: [
                          Text(
                            "You have been logged out due to inactivity.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FontConstants.f14,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontConstants.w600,
                              color: Color(0xff4E4F50),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            // 👇 Buttons pinned to bottom
            Column(
              children: [
                BottomDashLine(),
                const SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: FontConstants.horizontalPadding),
                  child:  Loan112Button(
                    text: "Go to Login",
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
                              color: Color(0xff2B3C74),
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
                              color: Color(0xff000000),
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
          ],
        ),
      ),
    );
  }

}