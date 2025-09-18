import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/ConstText/ConstText.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Screens/loanApplicationPage/loanApplicationOptions/bankStatement/onlinebankStatement/online_banking_step.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/app_bar.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import '../../../../../Model/VerifyOTPModel.dart';
import '../../../../../Utils/CleverTapEventsName.dart';
import '../../../../../Utils/CleverTapLogger.dart';
import '../../../../../Utils/MysharePrefenceClass.dart';

class OnlineBankingOption extends StatefulWidget{
  const OnlineBankingOption({super.key});

  @override
  State<StatefulWidget> createState() => _OnlineBankingOption();
}

class _OnlineBankingOption extends State<OnlineBankingOption>{


  List<String> accountAggregator = [
    'Enjoy a seamless and secure process with our government-authorized partner, OneMoney.',
    'Grant consent to securely retrieve your salary bank statement.',
    'Your financial data remains confidential and protected.'
  ];

  List<String> stepToGetStarted = [
    "Log in or register with your mobile number",
    "Verify your mobile number.",
    "Select your salaried bank account.",
    "Link your bank account.",
    "Approve access to fetch your latest bank statement."
  ];


  @override
  Widget build(BuildContext context) {
    return BlocListener<LoanApplicationCubit, LoanApplicationState>(
      listenWhen: (prev,current){
        return prev != current;
      },
      listener: (context, state) {
        if (state is LoanApplicationLoading) {
          EasyLoading.show(status: "Please wait...");
        } else if (state is OnlineAccountAggregatorSuccess) {
          EasyLoading.dismiss();
          CleverTapLogger.logEvent(CleverTapEventsName.ACCOUNT_AGGREGATOR_INIT, isSuccess: true);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            context.push(AppRouterName.customerKYCWebview, extra: state.uploadOnlineBankStatementModel.data?.url).then((val) async{
              var otpModel = await MySharedPreferences.getUserSessionDataNode();
              VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
              //var leadId = verifyOtpModel.data?.leadId ?? "";
              //if (leadId == ""){
               var leadId = await MySharedPreferences.getLeadId();
             // }
              context.read<LoanApplicationCubit>().fetchBankStatementStatusApiCall(leadId, verifyOtpModel.data?.custId ?? "");
            });
          });
        } else if (state is OnlineAccountAggregatorFailed) {
          EasyLoading.dismiss();
          CleverTapLogger.logEvent(CleverTapEventsName.ACCOUNT_AGGREGATOR_INIT, isSuccess: false);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            openSnackBar(context, state.uploadOnlineBankStatementModel.message ?? "Unknown Error");
          });
        }else if(state is CheckBankStatementStatusSuccess){
          EasyLoading.dismiss();
          if(state.checkBankStatementStatusModel.data?.aaConsentStatus == 2){
            CleverTapLogger.logEvent(CleverTapEventsName.ACCOUNT_AGGREGATOR_VERIFY, isSuccess: true);
          }else{
            CleverTapLogger.logEvent(CleverTapEventsName.ACCOUNT_AGGREGATOR_VERIFY, isSuccess: false);
          }
          context.replace(AppRouterName.onlineBankStatementMessage,extra: state.checkBankStatementStatusModel);
        }else if(state is CheckBankStatementStatusFailed){
          EasyLoading.dismiss();
          CleverTapLogger.logEvent(CleverTapEventsName.ACCOUNT_AGGREGATOR_VERIFY, isSuccess: false);
          DebugPrint.prt("Online Bank Statement fetching failed ${state.checkBankStatementStatusModel.message}");
          //context.replace(AppRouterName.onlineBankStatementMessage,extra: state.checkBankStatementStatusModel);
          openSnackBar(context, state.checkBankStatementStatusModel.message ?? "Unknown Error");
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstant.appThemeColor,
        body: Container(
          color: ColorConstant.appThemeColor,
          child: SafeArea(
            child: Column(
              children: [
                /// 🔹 App Bar
                Loan112AppBar(
                  customLeading: InkWell(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back, color: ColorConstant.whiteColor),
                  ),
                  title: Text(
                    "Fetch Bank Statement",
                    style: TextStyle(
                      fontSize: FontConstants.f20,
                      fontWeight: FontConstants.w800,
                      fontFamily: FontConstants.fontFamily,
                      color: ColorConstant.whiteColor,
                    ),
                  ),
                ),

                /// 🔹 Scrollable Content
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24)
                        )
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          Padding(

                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                                "Securely share your salary statement with our authorized partner. Your data is encrypted and protected",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorConstant.blackTextColor,
                               fontSize: 12,
                              ),


                            ),
                          ),
                          SizedBox(height: 16),
                          GetStartedSteps(stepToGetStarted: stepToGetStarted),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),

                /// 🔹 Bottom Fixed Section

              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Container(
            color: ColorConstant.whiteColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BottomDashLine(), // Make sure BottomDashLine uses double.infinity width
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                  child: Loan112Button(
                    onPressed: () async {
                      var otpModel = await MySharedPreferences.getUserSessionDataNode();
                      VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
                      //var leadId = verifyOtpModel.data?.leadId ?? "";
                     // if (leadId.isEmpty) {
                       var leadId = await MySharedPreferences.getLeadId();
                     // }

                      context.read<LoanApplicationCubit>().fetchOnlineAccountAggregatorApiCall({
                        "custId": verifyOtpModel.data?.custId,
                        "leadId": leadId,
                        "docType": "bank",
                        "bankVerifyType" :  "1",
                        "requestSource" :  Platform.isIOS?
                            ConstText.requestSourceIOS:
                            ConstText.requestSource
                      });
                    },
                    text: 'INITIATE',
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

