import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import '../../../../../Constant/ColorConst/ColorConstant.dart';
import '../../../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../../../Cubit/Loan112TimerCubit.dart';
import '../../../../../Cubit/ShowBanStatementAnalyzerStatusCubit.dart';
import '../../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../../Model/SendPhpOTPModel.dart';
import '../../../../../Model/VerifyBankStatementModel.dart';
import '../../../../../Model/VerifyOTPModel.dart';
import '../../../../../Routes/app_router_name.dart';
import '../../../../../Utils/MysharePrefenceClass.dart';
import '../../../../../Widget/app_bar.dart';
import 'new_breBackground.dart';

class BankStatementAnalyzer extends StatefulWidget{
  final int timerValue;
  const BankStatementAnalyzer({super.key,required this.timerValue});

  @override
  State<StatefulWidget> createState() => _BankStatementAnalyzer();
}

class _BankStatementAnalyzer extends State<BankStatementAnalyzer>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ShowBankStatementAnalyzerStatusCubit>().hide();
    context.read<Loan112TimerCubit>().startTimer(widget.timerValue * 60);
  }

  @override
  Widget build(BuildContext context) {
   return BlocBuilder<ShowBankStatementAnalyzerStatusCubit, bool>(
        builder: (context, isStatusShow) {
           return  isStatusShow?
             bankStatementAnalyzerStatus(context):
             bankStatementAnalyzer(context);
        }
   );
  }

  Widget bankStatementAnalyzer(BuildContext context){
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
          "Bank Statement Analyzer",
          style: TextStyle(
            fontSize: FontConstants.f20,
            fontWeight: FontConstants.w800,
            fontFamily: FontConstants.fontFamily,
            color: ColorConstant.whiteColor,
          ),
        ),
      ),
      body: Column(
        children: [
          BlocListener<LoanApplicationCubit,LoanApplicationState>(
            listenWhen: (prev,next) => prev != next,
            listener: (BuildContext context, state) {
              if(state is VerifyBankStatementSuccess){
                EasyLoading.dismiss();
                if (!context.mounted) return;
                if(state.verifyBankStatementModel.data?.bankStatementFetched == 1){
                  context.pop();
                  context.pop();
                  DebugPrint.prt("Inside if status is one first");
                  context.push(AppRouterName.loanOfferPage, extra: 1);
                }
                context.read<ShowBankStatementAnalyzerStatusCubit>().show();
              }else if(state is VerifyBankStatementFailed){
                EasyLoading.dismiss();
                openSnackBar(context, state.verifyBankStatementModel.message ?? "Unexpected Error");
              }
            },
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)
                  ),
                  color: ColorConstant.whiteColor
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Loan112BREBackground(height: 150, containerColor: Color(0xffE7F3FF)),
                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: -60,
                            child: Column(
                              children: [
                                Text(
                                  "We're analyzing your bank statement.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: FontConstants.f22,
                                      fontWeight: FontConstants.w700,
                                      fontFamily: FontConstants.fontFamily,
                                      color: ColorConstant.blackTextColor
                                  ),
                                ),
                                SizedBox(
                                  height: 21,
                                ),
                                BlocBuilder<Loan112TimerCubit, int>(
                                  builder: (context, secondsLeft) {
                                    return Container(
                                      height: 130,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        color: ColorConstant.whiteColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: ColorConstant.appThemeColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "$secondsLeft", // 👈 dynamic countdown
                                              style: TextStyle(
                                                fontFamily: FontConstants.fontFamily,
                                                fontWeight: FontConstants.w800,
                                                fontSize: FontConstants.f22,
                                                color: ColorConstant.blackTextColor,
                                              ),
                                            ),
                                            Text(
                                              "Sec",
                                              style: TextStyle(
                                                fontFamily: FontConstants.fontFamily,
                                                fontWeight: FontConstants.w400,
                                                fontSize: FontConstants.f18,
                                                color: ColorConstant.blackTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 75,
                      ),
                      BlocListener<Loan112TimerCubit, int>(
                        listenWhen: (previous, current) => current == 0, // only when finished
                        listener: (context, state) async {
                          // 👇 Call your API here
                          callVerifyBankStatementApiCall();
                        },
                        child: BlocBuilder<Loan112TimerCubit, int>(
                            builder: (context, secondsLeft) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 91.0),
                                child: Text(
                                  "We will comeback with loan offer within next $secondsLeft secs",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: FontConstants.f14,
                                    fontWeight: FontConstants.w500,
                                    fontFamily: FontConstants.fontFamily,
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                        child: Loan112Button(
                          text: "CHECK ANALYZE STATUS",
                          onPressed: (){
                            callVerifyBankStatementApiCall();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: true,
            child: recommendedCard(
                title: "Want your loan instantly? Do Account Aggregator.",
                buttonText: "Account Aggregator",
                onPressed: (){
                  context.replace(AppRouterName.onlineBankStatement);
                }
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  VerifyBankStatementModel? verifyBankStatementModel;
  Widget bankStatementAnalyzerStatus(BuildContext context){
    return Scaffold(
      appBar: Loan112AppBar(
        backgroundColor: Color(0xffFFF9EC),
        customLeading: InkWell(
          onTap:() async{
            context.pop();
            context.pop();
             //await getCustomerDetailsApiCall();
          },
          child: Icon(Icons.arrow_back_ios,color: ColorConstant.blackTextColor),
        ),
      ),
      body: BlocListener<LoanApplicationCubit,LoanApplicationState>(
        listener: (BuildContext context, state) {
          if(state is VerifyBankStatementSuccess){
            EasyLoading.dismiss();
            context.read<ShowBankStatementAnalyzerStatusCubit>().show();
            if (!context.mounted) return;
            if(state.verifyBankStatementModel.data?.bankStatementFetched == 1){
              context.pop();
              context.pop();
              DebugPrint.prt("Inside if status is one first");
              context.push(AppRouterName.loanOfferPage, extra: 1);
            }
          }else if(state is VerifyBankStatementFailed){
            EasyLoading.dismiss();
            openSnackBar(context, state.verifyBankStatementModel.message ?? "Unexpected Error");
          }
        },
        child: BlocBuilder<LoanApplicationCubit,LoanApplicationState>(
          builder: (context,state){
            if(state is VerifyBankStatementSuccess){
              verifyBankStatementModel = state.verifyBankStatementModel;
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Loan112BREBackground(height: 150, containerColor: Color(0xffFFF9EC)),
                            Positioned(
                              left: 10,
                              right: 10,
                              bottom: -60,
                              child: Column(
                                children: [
                                  verifyBankStatementModel?.data?.bankStatementFetched != 1?
                                  Text(
                                    getStatementText(verifyBankStatementModel?.data?.bankStatementFetched ?? 0),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: FontConstants.f22,
                                        fontWeight: FontConstants.w700,
                                        fontFamily: FontConstants.fontFamily,
                                        color: ColorConstant.blackTextColor
                                    ),
                                  ):
                                  SizedBox.shrink(),
                                  SizedBox(
                                    height: 21,
                                  ),
                                  Container(
                                    height: 130,
                                    width: 130,
                                    decoration: BoxDecoration(
                                        color: ColorConstant.whiteColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color(0xffF8BE32)
                                        )
                                    ),
                                    child: Center(
                                        child: Image.asset(ImageConstants.bankAnalyzerFailed,height: 77,width: 77)
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 75,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            verifyBankStatementModel?.data?.message?? "",
                            //"We couldn’t move forward due to an issue with your bank statement.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FontConstants.f14,
                              fontWeight: FontConstants.w500,
                              fontFamily: FontConstants.fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                          child: Loan112Button(
                            text: (
                                verifyBankStatementModel?.data?.bankStatementFetched ==3 ||
                                    verifyBankStatementModel?.data?.bankStatementFetched ==4
                            )?
                            "Upload Bank Statement":
                            "CHECK ANALYZE STATUS",
                            onPressed: (){
                              if(verifyBankStatementModel?.data?.bankStatementFetched ==3 ||
                                  verifyBankStatementModel?.data?.bankStatementFetched ==4){
                                context.pop();
                              }else{
                                callVerifyBankStatementApiCall();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  bottom: true,
                  child:  recommendedCard(
                      title: " If you still want the loan? Do Account Aggregator.",
                      //getStatementText(verifyBankStatementModel?.data!.bankStatementFetched ?? 0),
                      buttonText: "Account Aggregator",
                      onPressed: (){
                        context.replace(AppRouterName.onlineBankStatement);
                      }
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget recommendedCard({
    required String title,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 63.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  "Recommended",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontConstants.f12,
                    fontWeight: FontConstants.w700,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 2.0),
            decoration: BoxDecoration(
              color: Color(0xff0BC615),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstant.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16,
                  ),

                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                          fontSize: FontConstants.f16,
                          fontWeight: FontConstants.w700,
                          color: ColorConstant.blackTextColor,
                          fontFamily: FontConstants.fontFamily
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  BottomDashLine(),
                  const SizedBox(height: 15),

                  // Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                    child:  Loan112Button(
                      text: buttonText,
                      onPressed: onPressed,
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void callVerifyBankStatementApiCall() async{
    var otpModel = await MySharedPreferences.getUserSessionDataNode();
    VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
    //var leadId = verifyOtpModel.data?.leadId ?? "";
   // if (leadId == "") {
    var  leadId = await MySharedPreferences.getLeadId();
   // }
    var dataObj = {
      "custId": verifyOtpModel.data?.custId ?? "",
      "leadId": leadId
    };
    context.read<LoanApplicationCubit>().verifyBankStatementApiCall(dataObj);
  }

  /*
  Future<void> getCustomerDetailsApiCall() async{
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

  String getStatementText(int fetchBankStatementVal){
    if(fetchBankStatementVal == 2){
      return "If you still want the loan? Do Account Aggregator.";
    }else if(fetchBankStatementVal == 3){
       return "Oops! Couldn’t Process Your Loan.";
    }else if(fetchBankStatementVal == 4){
      return "If you still want the loan? Do Account Aggregator.";
    }else{
      return "";
    }
  }


}

