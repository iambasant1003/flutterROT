
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import '../../Model/GetCustomerDetailsModel.dart';
import '../../Model/SendPhpOTPModel.dart';
import '../../Utils/CleverTapEventsName.dart';
import '../../Utils/CleverTapLogger.dart';
import '../../Utils/MysharePrefenceClass.dart';

class DashboardStatusPageStep extends StatefulWidget {
   DashboardStatusPageStep({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardStatusPageStep();
}

class _DashboardStatusPageStep extends State<DashboardStatusPageStep> {


  int currentStep = 0;
  final List<String> steps = [
    "Application Submitted",
    "Application in Review",
    "Sanction",
    "E-Sign Letter",
    "Disbursement",
  ];

  final List<String> icons = [
    ImageConstants.applicationSubmitted,
    ImageConstants.applicationReview,
    ImageConstants.applicationSanction,
    ImageConstants.applicationESign,
    ImageConstants.applicationDisbursement
  ];


  getCustomerDetailsApiCall() async {
    var otpModel = await MySharedPreferences.getPhpOTPModel();
    SendPhpOTPModel sendPhpOTPModel = SendPhpOTPModel.fromJson(
        jsonDecode(otpModel));
    context.read<LoanApplicationCubit>().getCustomerDetailsApiCall({
      "cust_profile_id": sendPhpOTPModel.data?.custProfileId
    });
  }


  @override
  void initState() {
    super.initState();
    getCustomerDetailsApiCall();
  }


  GetCustomerDetailsModel? model;
  Map<String, dynamic>? status;
  List<String> stepKeys = [
    "application_submitted",
    "application_in_review",
    "sanction",
    "esign",
    "disbursement"
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoanApplicationCubit,LoanApplicationState>(
        builder: (context, state) {
          if (state is GetCustomerDetailsSuccess) {
           model = state.getCustomerDetailsModel;
            status = model!.data?.applicationStatus?.toJson() ?? {};
            currentStep = getCurrentStepDynamic(status!);
          }
          return  Column(
            children: List.generate(steps.length, (index) {
              final stepKey = stepKeys[index];
              final int stepStatus = status?[stepKey] ?? 0;

              // Determine width factor
              double widthFactor = 1.0;

              // Determine colors
              Color bgColor = (stepStatus == 2)
                  ? ColorConstant.whiteColor
                  : Colors.grey.shade100;

              Color textColor = (stepStatus == 2)
                  ? Colors.black
                  : ColorConstant.greyTextColor;

              return  Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * widthFactor,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: stepStatus == 2?
                      Border.all(
                        color: ColorConstant.appThemeColor
                      ):null
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          "Step: ${index + 1}",
                          style: TextStyle(
                            fontWeight: FontConstants.w700,
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontConstants.f16,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            steps[index],
                            style: TextStyle(
                              fontWeight: FontConstants.w600,
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontConstants.f16,
                              color: textColor,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: stepStatus == 2?
                          ColorConstant.appThemeColor:Color(0xffC6C6C6),
                          radius: 14,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: ColorConstant.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  )
                ],
              );
            }),
          ); // fallback when no state
        },
        listener: (context,state){
          if(state is LoanApplicationLoading){
            EasyLoading.show(status: "Please Wait...");
          }else if(state is GetCustomerDetailsSuccess){
            EasyLoading.dismiss();
            DebugPrint.prt("Inside Check Status GetCustomerDetails Success");
            CleverTapLogger.logEvent(CleverTapEventsName.STATUS_CHECK, isSuccess: true);
          }else if(state is GetCustomerDetailsError){
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.STATUS_CHECK, isSuccess: false);
          }
        }
    );
  }


  int getCurrentStepDynamic(Map<String, dynamic> status) {
    final List<String> stepOrder = [
      "application_submitted",
      "application_in_review",
      "sanction",
      "esign",
      "disbursement"
    ];

    int step = 0;
    for (int i = 0; i < stepOrder.length; i++) {
      if (status[stepOrder[i]] == 2) {
        step = i + 1;
      }
    }
    return step;
  }

}
