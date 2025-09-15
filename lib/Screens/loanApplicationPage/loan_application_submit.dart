import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Widget/bottom_dashline.dart';
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
      appBar: Loan112AppBar(
        backgroundColor: Color(0xffE7F3FF),
        customLeading: InkWell(
          onTap: () {
            GoRouter.of(context).push(AppRouterName.dashboardPage);
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
                              child: SvgPicture.asset(ImageConstants.successIcon),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 65),
                    Text(
                      "Thank you!",
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
                          const SizedBox(height: 22.0),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorConstant.greenColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8), // rounded corners
                              color: Colors.transparent, // no fill
                            ),
                            child:  Center(
                              child: Text(
                                widget.bankAccountPost.reference ?? "",
                                style: TextStyle(
                                    color: ColorConstant.greenColor,
                                    fontSize: FontConstants.f14,
                                    fontWeight: FontConstants.w700,
                                    fontFamily: FontConstants.fontFamily
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22.0),
                          Text(
                            "We will connect with you soon.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FontConstants.f16,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontConstants.w700,
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
            // 👇 Buttons pinned to bottom
            Column(
              children: [
                BottomDashLine(),
                const SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: FontConstants.horizontalPadding),
                  child:  Loan112Button(
                    text: "GO TO DASHBOARD",
                    onPressed: (){
                      GoRouter.of(context).push(AppRouterName.dashboardPage);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

}