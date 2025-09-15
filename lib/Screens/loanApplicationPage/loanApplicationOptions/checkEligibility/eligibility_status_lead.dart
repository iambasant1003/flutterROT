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
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Utils/MysharePrefenceClass.dart';
import '../../../../Widget/eligibility_status_background.dart';

class EligibilityStatusLead extends StatefulWidget{
  final CreateLeadModel createLeadModel;
  const EligibilityStatusLead({super.key,required this.createLeadModel});

  @override
  State<StatefulWidget> createState() => _EligibilityStatusLead();
}

class _EligibilityStatusLead extends State<EligibilityStatusLead>{



  /*
  getCustomerDetailsApiCall() async{
    var otpModel = await MySharedPreferences.getPhpOTPModel();
    SendPhpOTPModel sendPhpOTPModel = SendPhpOTPModel.fromJson(jsonDecode(otpModel));
    context.read<LoanApplicationCubit>().getCustomerDetailsApiCall({
      "cust_profile_id": sendPhpOTPModel.data?.custProfileId
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
            if(widget.createLeadModel.statusCode == 402){
              context.push(AppRouterName.dashboardPage);
            }else{
              context.pop();
              //getCustomerDetailsApiCall();
            }
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
                            child: widget.createLeadModel.success == true?
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
                    widget.createLeadModel.success == true?
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
                      widget.createLeadModel.success == true?
                      "Hurray! You are eligible for loan":
                      "You are not eligible for loan",
                      style: TextStyle(
                        fontSize: FontConstants.f12,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontConstants.w500,
                        color: widget.createLeadModel.success == true?
                        ColorConstant.blackTextColor:
                        ColorConstant.errorRedColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                      child: Column(
                        children: [
                          const SizedBox(height: 22),
                          eligibilityConfirmMessage(context),
                          const SizedBox(height: 22),
                        ],
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
                      if(widget.createLeadModel.statusCode == 402){
                        context.push(AppRouterName.dashboardPage);
                      }else{
                        context.replace(AppRouterName.bankStatement);
                      }
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


  Widget eligibilityConfirmMessage(BuildContext context){
    return Container(
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
          widget.createLeadModel.success ==true?
          'ELIGIBILITY CONFIRMED':'ELIGIBILITY FAILED',
          style: TextStyle(
            color: widget.createLeadModel.success ==true?
            ColorConstant.greenColor:ColorConstant.errorRedColor,
            fontSize: FontConstants.f14,
            fontWeight: FontConstants.w700,
            fontFamily: FontConstants.fontFamily
          ),
        ),
      ),
    );
  }

  Widget loanOfferUi(BuildContext context){
    return Container(
      padding:  EdgeInsets.symmetric(
          vertical: FontConstants.horizontalPadding,
          horizontal: FontConstants.horizontalPadding
      ),
      decoration: BoxDecoration(
        color:  Color(0xFFF5FBFF), // light blue background
        border: Border.all(
          color:  Color(0xFFB8DAF5), // light blue border
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12), // rounded corners
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            'We have generated your loan offer of',
            style: TextStyle(
              color: ColorConstant.blackTextColor,
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.f14,
              fontWeight: FontConstants.w400,
            ),
            textAlign: TextAlign.center,
          ),
           SizedBox(height: 12),
          Container(
            padding:  EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: ColorConstant.whiteColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child:  Text(
              'Rs 50,000',
              style: TextStyle(
                color: ColorConstant.blueTextColor, // blue text
                fontSize: FontConstants.f18,
                fontWeight: FontConstants.w700,
                fontFamily: FontConstants.fontFamily
              ),
            ),
          ),
           SizedBox(height: 12),
           Text(
            'Want to Enhance offer?',
            style: TextStyle(
              color: ColorConstant.blackTextColor,
              fontSize: FontConstants.f14,
              fontWeight: FontConstants.w700,
              fontFamily: FontConstants.fontFamily
            ),
          ),
        ],
      ),
    );
  }

}






