
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
      backgroundColor: ColorConstant.appThemeColor,
      appBar: Loan112AppBar(
        customLeading: Padding(
          padding: EdgeInsets.only(left: 0),
          child: InkWell(
            onTap: () async{
              context.pop();
              context.read<DashboardCubit>().callDashBoardApi();
            },
            child: Icon(
              Icons.arrow_back,
              color: ColorConstant.whiteColor,
            ),
          ),
        ),
        title: Text(
          "Status of Application",
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorConstant.whiteColor,
            fontSize: FontConstants.f18,
            fontWeight: FontConstants.w700
          ),
        ),
        leadingSpacing: 30,
      ),
      body: commonBackground(
        context,
        bodyPart: personalLoanApplyWidget(context)
      ),
    );
  }

  Widget personalLoanApplyWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      width: double.infinity,
      child:  Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: DashboardStatusPageStep(),
          ),
          Stack(
            children: [
              Image.asset(
                ImageConstants.rotStatusPageBackground,
              ),
              Padding(
                padding: EdgeInsets.only(top: 70.0,left: 44.0,right: 44.0),
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
            ],
          )
        ],
      ),
    );
  }

  Widget commonBackground(BuildContext context,{required Widget bodyPart}){
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: ColorConstant.appThemeColor,
            ),
          ),
          //Positioned Data
          bodyPart
        ],
      ),
    );
  }

}

