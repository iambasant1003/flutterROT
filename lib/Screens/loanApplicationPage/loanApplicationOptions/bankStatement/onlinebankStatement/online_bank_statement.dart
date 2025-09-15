import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Constant/ColorConst/ColorConstant.dart';
import 'package:loan112_app/Constant/ConstText/ConstText.dart';
import 'package:loan112_app/Constant/FontConstant/FontConstant.dart';
import 'package:loan112_app/Constant/ImageConstant/ImageConstants.dart';
import 'package:loan112_app/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:loan112_app/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/bankStatement/onlinebankStatement/online_banking_step.dart';
import 'package:loan112_app/Utils/Debugprint.dart';
import 'package:loan112_app/Utils/snackbarMassage.dart';
import 'package:loan112_app/Widget/app_bar.dart';
import 'package:loan112_app/Widget/bottom_dashline.dart';
import 'package:loan112_app/Widget/common_button.dart';
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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstants.logInScreenBackGround),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                /// 🔹 App Bar
                Loan112AppBar(
                  customLeading: InkWell(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back_ios, color: ColorConstant.blackTextColor),
                  ),
                  centerTitle: true,
                  title: Image.asset(ImageConstants.oneMoneyIcon, width: 100, height: 100),
                  /*
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                      child: InkWell(
                        onTap: () {
                          context.replace(AppRouterName.offlineBankStatement);
                        },
                        child: Text(
                          "SKIP",
                          style: TextStyle(
                            fontSize: FontConstants.f14,
                            fontFamily: FontConstants.fontFamily,
                            fontWeight: FontConstants.w600,
                            color: ColorConstant.blueTextColor,
                          ),
                        ),
                      ),
                    )
                  ],

                   */
                ),

                /// 🔹 Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 37),
                          child: Text(
                            "Fetch Your Bank Statement via Account Aggregator",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FontConstants.f18,
                              fontWeight: FontConstants.w700,
                              fontFamily: FontConstants.fontFamily,
                              color: ColorConstant.blackTextColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        ListView.builder(
                          itemCount: accountAggregator.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 7),
                                      child: CircleAvatar(
                                        radius: 2,
                                        backgroundColor: ColorConstant.blueTextColor,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        accountAggregator[index],
                                        style: TextStyle(
                                          fontSize: FontConstants.f12,
                                          fontWeight: FontConstants.w500,
                                          fontFamily: FontConstants.fontFamily,
                                          color: Color(0xff344054),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            "Simple Steps to Get Started:",
                            style: TextStyle(
                              fontSize: FontConstants.f14,
                              fontWeight: FontConstants.w800,
                              fontFamily: FontConstants.fontFamily,
                              color: ColorConstant.blackTextColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GetStartedSteps(stepToGetStarted: stepToGetStarted),
                        SizedBox(height: 24),
                      ],
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
    );
  }

}

