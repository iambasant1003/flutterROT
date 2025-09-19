import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import '../../Constant/ColorConst/ColorConstant.dart';
import '../../Constant/FontConstant/FontConstant.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import '../../Model/UpdateBankAccountModel.dart';
import '../../Utils/CleverTapEventsName.dart';
import '../../Utils/CleverTapLogger.dart';
import '../../Widget/app_bar.dart';
import '../../Widget/common_button.dart';
import '../../Widget/eligibility_status_background.dart';

class LoanApplicationSubmit extends StatefulWidget{
  final BankAccountPost bankAccountPost;
  const LoanApplicationSubmit({super.key,required this.bankAccountPost});

  @override
  State<StatefulWidget> createState() => _LoanApplicationSubmit();
}

class _LoanApplicationSubmit extends State<LoanApplicationSubmit> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CleverTapLogger.logEvent(CleverTapEventsName.APPLICATION_SUBMITTED, isSuccess: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appThemeColor,
      appBar: Loan112AppBar(
        customLeading: InkWell(
          onTap: () async{
            context.pop();
            //await getCustomerDetailsApiCall();
          },
          child: Icon(Icons.arrow_back, color: ColorConstant.whiteColor),
        ),
        title: Text(
          "Application submitted",
          style: TextStyle(
            fontSize: FontConstants.f20,
            fontWeight: FontConstants.w800,
            fontFamily: FontConstants.fontFamily,
            color: ColorConstant.whiteColor,
          ),
        ),
      ),

      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstant.whiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24)
                  )
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                     Padding(
                       padding: const EdgeInsets.all(16.0),
                       child: Image.asset(
                         ImageConstants.imgApplicationSubmit
                       ),
                     ),
                      Text(
                        "Thank you!",
                        style: TextStyle(
                          fontSize: FontConstants.f22,
                          fontWeight: FontConstants.w800,
                          fontFamily: FontConstants.fontFamily,
                          color: ColorConstant.appThemeColor,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: FontConstants.horizontalPadding),
                        child: Column(
                          children: [
                            Text(
                              "Your loan application has been submitted successfully.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: FontConstants.f14,
                                fontFamily: FontConstants.fontFamily,
                                fontWeight: FontConstants.w600,
                                color: Color(0xff4E4F50),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Your application reference number is ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: FontConstants.f14,
                                fontFamily: FontConstants.fontFamily,
                                fontWeight: FontConstants.w600,
                                color: Color(0xff4E4F50),
                              ),
                            ),
                            Center(
                              child: Text(
                                widget.bankAccountPost.reference ?? "",
                                style: TextStyle(
                                    color: ColorConstant.appThemeColor,
                                    fontSize: FontConstants.f16,
                                    fontWeight: FontConstants.w800,
                                    fontFamily: FontConstants.fontFamily
                                ),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              "We will connect with you soon.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: FontConstants.f16,
                                fontFamily: FontConstants.fontFamily,
                                fontWeight: FontConstants.w500,
                                color: ColorConstant.blackTextColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // 👇 Buttons pinned to bottom
            Container(
              color: ColorConstant.whiteColor,
              child: Column(
                children: [
                  BottomDashLine(),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: FontConstants.horizontalPadding),
                    child:  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        border: Border.all(color: ColorConstant.appThemeColor,width: 1)
                      ),
                      child: Loan112Button(
                        backGroundColor: ColorConstant.whiteColor,
                        text: "GO TO DASHBOARD",
                        textColor: ColorConstant.appThemeColor,
                        onPressed: (){
                          GoRouter.of(context).push(AppRouterName.dashboardPage);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}