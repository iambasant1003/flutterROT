import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Constant/FontConstant/FontConstant.dart';
import 'package:loan112_app/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:loan112_app/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:loan112_app/Model/GetLoanHistoryModel.dart';
import 'package:loan112_app/Widget/app_bar.dart';
import '../../Constant/ColorConst/ColorConstant.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import '../../Model/SendPhpOTPModel.dart';
import '../../Model/VerifyOTPModel.dart';
import '../../Utils/MysharePrefenceClass.dart';
import 'loan_list_page.dart';


class RepaymentPage extends StatefulWidget{
  const RepaymentPage({super.key});

  @override
  State<StatefulWidget> createState() => _RepaymentPage();
}

class _RepaymentPage extends State<RepaymentPage>{


  GetLoanHistoryModel? getLoanHistoryModel = GetLoanHistoryModel();

  @override
  void initState() {
    super.initState();
    getLoanHistoryModel = GetLoanHistoryModel();
    getLoanHistory();
  }

  getLoanHistory() async{
    var otpModel = await MySharedPreferences.getUserSessionDataNode();
    VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
    context.read<LoanApplicationCubit>().getLoanHistoryApiCall({
      "cust_profile_id": verifyOtpModel.data?.custId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Loan112AppBar(
          leadingSpacing: 25,
          title: Image.asset(
            ImageConstants.loan112AppNameIcon,
            height: 76,
            width: 76,
          ),
          customLeading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: InkWell(
                onTap: () {
                  context.pop();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorConstant.blackTextColor,
                ),
              ),
            ),
          ),
        ),
        body: BlocListener<LoanApplicationCubit,LoanApplicationState>(
          listener: (context,state){
            if(state is LoanApplicationLoading){
              EasyLoading.show(status: "Please wait...");
            }else if(state is GetLoanHistorySuccess){
              EasyLoading.dismiss();
            }else if(state is GetLoanHistoryFailed){
              EasyLoading.dismiss();
            }
          },
          child: BlocBuilder<LoanApplicationCubit,LoanApplicationState>(
            builder: (context,state){
              if(state is GetLoanHistorySuccess){
               // setState(() {
                  getLoanHistoryModel = state.getLoanHistoryModel;
               // });
              }
              return SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        ImageConstants.permissionScreenBackground,
                        fit: BoxFit.cover, // Optional: to scale and crop nicely
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: loanHistoryContainerWidget(context),
                    ),
                  ],
                ),
              );
            },
          )
        )
    );
  }

  Widget loanHistoryContainerWidget(BuildContext context){
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 15),
          Text(
            "Loan History",
            style: TextStyle(
              fontSize: FontConstants.f20,
              fontFamily: FontConstants.fontFamily,
              fontWeight: FontConstants.w800,
              color: ColorConstant.blackTextColor
            ),
          ),
          SizedBox(height: 14.0),
          Expanded(    // 🔷 Added
            child: LoanListPage(loanHistoryModel: getLoanHistoryModel ?? GetLoanHistoryModel()),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

}

