import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Constant/ColorConst/ColorConstant.dart';
import 'package:loan112_app/Constant/FontConstant/FontConstant.dart';
import 'package:loan112_app/Constant/ImageConstant/ImageConstants.dart';
import 'package:loan112_app/Model/UploadSelfieModel.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Widget/app_bar.dart';
import 'package:loan112_app/Widget/common_button.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import '../../../../Model/CreateLeadModel.dart';
import '../../../../Model/GenerateLoanOfferModel.dart';
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Model/VerifyOTPModel.dart';
import '../../../../Utils/MysharePrefenceClass.dart';
import '../../../../Widget/eligibility_status_background.dart';

class LoanOfferFailed extends StatefulWidget{
  final GenerateLoanOfferModel generateLoanOfferModel;
  const LoanOfferFailed({super.key,required this.generateLoanOfferModel});

  @override
  State<StatefulWidget> createState() => _LoanOfferFailed();
}

class _LoanOfferFailed extends State<LoanOfferFailed>{


/*
  getCustomerDetailsApiCall() async{
    context.read<DashboardCubit>().callDashBoardApi();
    var nodeOtpModel = await MySharedPreferences.getUserSessionDataNode();
    VerifyOTPModel verifyOTPModel = VerifyOTPModel.fromJson(jsonDecode(nodeOtpModel));
    var otpModel = await MySharedPreferences.getPhpOTPModel();
    SendPhpOTPModel sendPhpOTPModel = SendPhpOTPModel.fromJson(jsonDecode(otpModel));
    context.read<LoanApplicationCubit>().getCustomerDetailsApiCall({
      "cust_profile_id": sendPhpOTPModel.data?.custProfileId
    });
    context.read<LoanApplicationCubit>().getLeadIdApiCall({
      "custId": verifyOTPModel.data?.custId
    });
  }

 */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: Loan112AppBar(
        customLeading: InkWell(
          onTap: (){
            context.push(AppRouterName.dashboardPage);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.blackTextColor,
          ),
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
                            child: widget.generateLoanOfferModel.success == true?
                            Center(
                              child: SvgPicture.asset(ImageConstants.successIcon),
                            ):
                            Center(
                              child: Image.asset(ImageConstants.failedIcon),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 65),
                    widget.generateLoanOfferModel.success == true?
                    Text(
                      "Congratulations!",
                      style: TextStyle(
                        fontSize: FontConstants.f22,
                        fontWeight: FontConstants.w800,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.blackTextColor,
                      ),
                    ):
                    SizedBox.shrink(),
                    const SizedBox(height: 12.0),
                    Text(
                      widget.generateLoanOfferModel.success == true?
                      "Hurray! You are eligible for loan":
                      "You are not eligible for loan",
                      style: TextStyle(
                        fontSize: FontConstants.f12,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontConstants.w500,
                        color: widget.generateLoanOfferModel.success == true?
                        ColorConstant.blackTextColor:
                        ColorConstant.errorRedColor,
                      ),
                    ),
                    const SizedBox(height: 43.0),
                  ],
                ),
              ),
            ),
            // 👇 Buttons pinned to bottom
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
              child: Column(
                children: [
                  Loan112Button(
                    onPressed: () {
                      context.push(AppRouterName.dashboardPage);
                    },
                    text: "Ok",
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






