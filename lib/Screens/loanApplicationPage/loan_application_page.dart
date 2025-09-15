import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Constant/FontConstant/FontConstant.dart';
import 'package:loan112_app/Cubit/dashboard_cubit/DashboardState.dart';
import 'package:loan112_app/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:loan112_app/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:loan112_app/Model/SendPhpOTPModel.dart';
import 'package:loan112_app/Model/VerifyPHPOTPModel.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Utils/Debugprint.dart';
import 'package:loan112_app/Utils/snackbarMassage.dart';
import 'package:loan112_app/Widget/app_bar.dart';
import 'package:loan112_app/Widget/circular_progress.dart';
import '../../Constant/ColorConst/ColorConstant.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import '../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../Cubit/loan_application_cubit/JourneyUpdateCubit.dart';
import '../../Model/GetCustomerDetailsModel.dart';
import '../../Model/VerifyOTPModel.dart';
import '../../Utils/MysharePrefenceClass.dart';
import '../../Utils/validation.dart';
import '../../Widget/common_step.dart';
import '../../main.dart';

class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoanApplicationPage();
}

class _LoanApplicationPage extends State<LoanApplicationPage> with RouteAware {
  final List<String> step = [
    "check_eligibility",
    "ekyc_verified",
    "selfie_upload",
    "bank_statement_upload",
    "loan_quote",
    "residence_proof_upload",
    "customer_references",
    "banking_details",
  ];

  final List<String> stepKeys = [
    "Check Eligibility",
    "eKYC",
    "Selfie Verification",
    "Fetch Bank Statement",
    "Get Loan Offer",
    "Current Residence Proof",
    "Add References",
    "Banking Details",
  ];

  @override
  void initState() {
    super.initState();
    context.read<JourneyUpdateCubit>().updateJourneyTabs({});
    // keep if you want API also on first build
    getCustomerDetailsApiCall();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // subscribe to route observer
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }



  @override
  void didPopNext() {
    super.didPopNext();
    DebugPrint.prt("Did pop next called");
    getCustomerDetailsApiCall();
  }

  getCustomerDetailsApiCall() async {
    context.read<DashboardCubit>().callDashBoardApi();
    var nodeOtpModel = await MySharedPreferences.getUserSessionDataNode();
    VerifyOTPModel verifyOTPModel = VerifyOTPModel.fromJson(
      jsonDecode(nodeOtpModel),
    );
    var otpModel = await MySharedPreferences.getPhpOTPModel();
    SendPhpOTPModel sendPhpOTPModel = SendPhpOTPModel.fromJson(
      jsonDecode(otpModel),
    );
    context.read<LoanApplicationCubit>().getCustomerDetailsApiCall({
      "cust_profile_id": sendPhpOTPModel.data?.custProfileId,
    });
    context.read<LoanApplicationCubit>().getLeadIdApiCall({
      "custId": verifyOTPModel.data?.custId,
    });
  }

  GetCustomerDetailsModel? getCustomerDetailsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Loan112AppBar(
        customLeading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.whiteColor,
          ),
        ),
        title: Text(
          "Your Loan Application",
          style: TextStyle(
            fontSize: FontConstants.f18,
            fontWeight: FontConstants.w700,
            fontFamily: FontConstants.fontFamily,
            color: ColorConstant.whiteColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstant.appThemeColor,
      ),
      body: BlocListener<LoanApplicationCubit, LoanApplicationState>(
        listenWhen: (prevState, currentState) {
          return prevState != currentState;
        },
        listener: (context, state) {
          if (state is LoanApplicationLoading) {
            EasyLoading.show(status: "Please wait...");
          } else if (state is GetCustomerDetailsSuccess) {
            EasyLoading.dismiss();
            MySharedPreferences.setCustomerDetails(
              jsonEncode(state.getCustomerDetailsModel.data?.customerDetails),
            );
            context.read<JourneyUpdateCubit>().updateJourneyTabs(
              state.getCustomerDetailsModel.data?.screenDetails!.toJson()
                  as Map<String, dynamic>,
            );
            getCustomerDetailsModel = state.getCustomerDetailsModel;
            MySharedPreferences.setEnhanceKey(
              (state.getCustomerDetailsModel.data?.screenDetails?.isEnhance ??
                      "")
                  .toString(),
            );
            setState(() {});
            // if(state.getCustomerDetailsModel.data?.screenDetails?.residenceProofUpload == 2){
            //   context.push(AppRouterName.utilityBillScreen);
            // }
          } else if (state is GetCustomerDetailsError) {
            EasyLoading.dismiss();
            openSnackBar(
              context,
              state.getCustomerDetailsModel.message ?? "Unknown Error",
            );
          } else if (state is CalculateDistanceSuccess) {
            EasyLoading.dismiss();
            //openSnackBar(context, "Distance Mapped",backGroundColor: ColorConstant.appThemeColor);
            getCustomerDetailsApiCall();
          } else if (state is CalculateDistanceFailed) {
            EasyLoading.dismiss();
            getCustomerDetailsApiCall();
          } else if (state is GetLeadIdSuccess) {
            MySharedPreferences.setLeadId(
              state.getLeadIdResponseModel.data?.leadId ?? "",
            );
            DebugPrint.prt(
              "Get Lead Id Success ${state.getLeadIdResponseModel.data?.leadId}",
            );
          } else if (state is GetLeadIdError) {
            DebugPrint.prt(
              "Get Lead Id Error ${state.getLeadIdResponseModel.message}",
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            getCustomerDetailsApiCall();
          },
          child: SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                child:   Container(
                    color: ColorConstant.appThemeColor, // 👈 background color
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 20,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: BoxDecoration(
                      color: ColorConstant.whiteColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<DashboardCubit, DashboardState>(
                          builder: (context, state) {
                            if (state is DashBoardSuccess) {
                              return Row(
                                children: [
                                  SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: CircularProgressWithText(
                                      progress:
                                          (state
                                                  .dashBoardModel
                                                  .data
                                                  ?.applyLoanBanner
                                                  ?.appBannerProgressPercent ??
                                              0) /
                                          100,
                                      isDrawer: false,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      state
                                              .dashBoardModel
                                              .data
                                              ?.applyLoanBanner
                                              ?.appBannerText ??
                                          "",
                                      //"Begin your journey to financial empowerment-provide the necessary details to initiate your loan application.",
                                      style: TextStyle(
                                        fontFamily: FontConstants.fontFamily,
                                        fontWeight: FontConstants.w500,
                                        fontSize: FontConstants.f14,
                                        color: ColorConstant.dashboardTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        // 👇 Wrap with Expanded
                        if (getCustomerDetailsModel != null) ...[
                          BlocBuilder<JourneyUpdateCubit, Map<String, dynamic>>(
                            builder: (context, state) {
                              DebugPrint.prt("All Step with key $state");
                              return


                                Expanded(
                                child: ListView.builder(
                                  itemCount: stepKeys.length,
                                  itemBuilder: (context, index) {
                                    final stepKey = step[index];
                                    final int? status = int.tryParse(
                                      state[stepKey].toString(),
                                    );
                                    DebugPrint.prt(
                                      "Status and Key $status,$stepKey",
                                    );

                                    return
                                      JourneyStepCard(
                                        stepNumber: index + 1,
                                        title: step[index],
                                        state: status!,
                                        onTap: () {
                                          DebugPrint.prt(
                                            "Current Status $status",
                                          );
                                          if (status == null) {
                                            if (stepKeys[index]
                                                .toLowerCase()
                                                .contains('eligibility')) {
                                              context.push(AppRouterName.checkEligibilityPage,
                                              );
                                            }
                                          } else {
                                            showMessageAboutStep(status);
                                            if (stepKeys[index]
                                                .toLowerCase()
                                                .contains(
                                              'eligibility',
                                            ) &&
                                                status != 1 &&
                                                status != 0) {
                                              context.push(
                                                AppRouterName
                                                    .checkEligibilityPage,
                                                extra:
                                                getCustomerDetailsModel
                                                    ?.data
                                                    ?.customerDetails
                                                    ?.existingCustomer ??
                                                    false,
                                              );
                                            } else if (stepKeys[index]
                                                .toLowerCase()
                                                .contains('statement') &&
                                                status != 1 &&
                                                status != 0) {
                                              context.push(
                                                AppRouterName.bankStatement,
                                              );
                                            } else if (stepKeys[index]
                                                .toLowerCase()
                                                .contains('ekyc') &&
                                                status != 1 &&
                                                status != 0) {
                                              context.push(
                                                AppRouterName.aaDarKYCScreen,
                                              );
                                            } else if (stepKeys[index]
                                                .toLowerCase()
                                                .contains('selfie') &&
                                                status != 1 &&
                                                status != 0) {
                                              context
                                                  .push(
                                                AppRouterName
                                                    .selfieScreenPath,
                                              )
                                                  .then((val) {});
                                            } else if (stepKeys[index]
                                                .toLowerCase()
                                                .contains("offer") &&
                                                status != 1 &&
                                                status != 0) {
                                              context
                                                  .push(
                                                AppRouterName
                                                    .loanOfferPage,
                                                extra:
                                                getCustomerDetailsModel
                                                    ?.data
                                                    ?.screenDetails
                                                    ?.isEnhance,
                                              )
                                                  .then((val) {});
                                            } else if (stepKeys[index]
                                                .toLowerCase()
                                                .contains('reference') &&
                                                status != 1 &&
                                                status != 0) {
                                              context
                                                  .push(
                                                AppRouterName
                                                    .addReference,
                                              )
                                                  .then((val) {
                                                // getCustomerDetailsApiCall();
                                              });
                                            } else if (stepKeys[index]
                                                .toLowerCase()
                                                .contains('residence') &&
                                                status != 1 &&
                                                status != 0) {
                                              context.push(
                                                AppRouterName
                                                    .utilityBillScreen,
                                              );
                                            } else if (stepKeys[index]
                                                .toLowerCase()
                                                .contains('bank') &&
                                                status != 1 &&
                                                status != 0) {
                                              context.push(
                                                AppRouterName
                                                    .bankDetailsScreen,
                                              );
                                            }
                                          }
                                        },
                                      );

                                  },
                                ),
                              );
                            },
                          ),
                        ],
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showMessageAboutStep(int stepStatus) {
    DebugPrint.prt("Status On Tap $stepStatus");
    if (stepStatus == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          openSnackBar(context, "Previous step is pending");
        }
      });
    } else if (stepStatus == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          openSnackBar(context, "Already done");
        }
      });
    }
  }
}


