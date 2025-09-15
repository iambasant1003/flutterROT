
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Screens/dashboard/dashboard_statusPage_Step.dart';
import 'package:rupeeontime/Widget/app_bar.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import '../../Constant/FontConstant/FontConstant.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import '../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import '../../Model/SendPhpOTPModel.dart';
import '../../Utils/MysharePrefenceClass.dart';

class DashboardStatusScreen extends StatefulWidget {
  const DashboardStatusScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardStatusScreen();
}

class _DashboardStatusScreen extends State<DashboardStatusScreen> {

  getCustomerDetailsApiCall() async {
    var otpModel = await MySharedPreferences.getPhpOTPModel();
    SendPhpOTPModel sendPhpOTPModel = SendPhpOTPModel.fromJson(
        jsonDecode(otpModel));
    context.read<LoanApplicationCubit>().getCustomerDetailsApiCall({
      "cust_profile_id": sendPhpOTPModel.data?.custProfileId
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Loan112AppBar(
        customLeading: Padding(
          padding: EdgeInsets.only(left: 0),
          child: InkWell(
            onTap: () async{
              context.pop();
              context.read<DashboardCubit>().callDashBoardApi();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: ColorConstant.blackTextColor,
            ),
          ),
        ),
        leadingSpacing: 30,
        title: Image.asset(
          ImageConstants.loan112AppNameIcon,
          height: 76,
          width: 76,
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                ImageConstants.permissionScreenBackground,
                fit: BoxFit.cover, // Optional: to scale and crop nicely
              ),
            ),

            //Positioned Data
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 37),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        personalLoanApplyWidget(context),
                        Positioned(
                          top: -2,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorConstant.appThemeColor,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(18.0),
                                  bottomRight: Radius.circular(18.0),
                                ),
                              ),
                              width: 244,
                              height: 40,
                              child: Center(
                                child: Text(
                                  "Status of Application",
                                  style: TextStyle(
                                    fontFamily: FontConstants.fontFamily,
                                    fontSize: FontConstants.f18,
                                    fontWeight: FontConstants.w800,
                                    color: ColorConstant.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: FontConstants.horizontalPadding),
          child: SizedBox(
            height: 50,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: FontConstants.horizontalPadding,
                ),
                child: Loan112Button(
                    text: "Refresh",
                    icon: Image.asset(ImageConstants.dashBoardRefresh),
                    onPressed: () {
                      getCustomerDetailsApiCall();
                    }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget personalLoanApplyWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageConstants.permissionScreenLeftPyramid,
              width: 26,
              height: 13,
            ),
            SizedBox(width: 214),
            Image.asset(
              ImageConstants.permissionScreenRightPyramid,
              width: 26,
              height: 13.0,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(FontConstants.horizontalPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30),
              DashboardStatusPageStep(),
            ],
          ),
        ),
      ],
    );
  }
}