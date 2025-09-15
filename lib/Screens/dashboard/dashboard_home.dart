import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Cubit/dashboard_cubit/DashboardState.dart';
import 'package:rupeeontime/Model/DashBoarddataModel.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/MysharePrefenceClass.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../Constant/ColorConst/ColorConstant.dart';
import '../../Constant/FontConstant/FontConstant.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import '../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../Utils/CleverTapEventsName.dart';
import '../../Utils/CleverTapLogger.dart';
import '../../Widget/circular_progress.dart';
import '../../Widget/common_button.dart';
import 'dashboard_loan_details.dart';

class DashBoardHome extends StatefulWidget {
  const DashBoardHome({super.key});

  @override
  State<StatefulWidget> createState() => _DashBoardHome();
}

class _DashBoardHome extends State<DashBoardHome> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().callDashBoardApi();
  }



  final PageController _controller = PageController(viewportFraction: 1.0);
  DashBoarddataModel? dashBoarddataModel;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      listenWhen: (prev, next) {
        DebugPrint.prt("Previous State $prev, Current State $next");
        return prev != next;
      },
      listener: (context, state) {
        if (state is DashBoardLoading) {
          DebugPrint.prt('DashBoard Is Loading');
          EasyLoading.show(status: "Please Wait");
        } else if (state is DashBoardSuccess) {
          EasyLoading.dismiss();
          dashBoarddataModel = state.dashBoardModel;
          MySharedPreferences.setCallUsNumber(
            dashBoarddataModel?.data?.contactUsNumber ?? "",
          );
          MySharedPreferences.setChatUsNumber(
            dashBoarddataModel?.data?.contactUsWhatsappNumber ?? "",
          );
          MySharedPreferences.setContactUsEmail(
            dashBoarddataModel?.data?.contactUsEmail ?? "",
          );
        } else if (state is DashBoardError) {
          DebugPrint.prt("DashBoard Is facing Error");
          EasyLoading.dismiss();
          openSnackBar(
            context,
            state.dashBoardModel.message ?? "Unknown Error",
          );
          if(state.dashBoardModel.status == 4){
            context.go(AppRouterName.sessionTimeOut);
          }
        } else if (state is DeleteCustomerSuccess) {
          DebugPrint.prt("Delete Customer Success");
          CleverTapLogger.logEvent(CleverTapEventsName.DELETE_ACCOUNT_OTP_SENT, isSuccess: true);
          EasyLoading.dismiss();
          Navigator.of(context).pop();
          context.push(AppRouterName.dashBoardOTP);
        } else if (state is DeleteCustomerFailed) {
          DebugPrint.prt("Delete Customer Failed");
          CleverTapLogger.logEvent(CleverTapEventsName.DELETE_ACCOUNT_OTP_SENT, isSuccess: false);
          Navigator.of(context).pop();
          EasyLoading.dismiss();
          openSnackBar(
            context,
            state.deleteCustomerModel.message ?? "Unexpected Error",
          );
        }
      },
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (dashBoarddataModel != null) {
            return commonScaffold(
              context,
              dashBoardModel: dashBoarddataModel,
              bodyPart: SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: ColorConstant.whiteColor,
                      )
                    ),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: ColorConstant.appThemeColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(70.0),
                          bottomRight: Radius.circular(70.0),
                        )
                      ),
                    ),
                    SafeArea(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        primary: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 48),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorConstant.whiteColor,
                                    borderRadius: BorderRadius.circular(24.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Loan Application",
                                                    style: TextStyle(
                                                      fontSize: FontConstants.f18,
                                                      fontWeight: FontConstants.w700,
                                                      fontFamily: FontConstants.fontFamily,
                                                      color: ColorConstant.blackTextColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    "Unlock funds instantly with a smooth and simple loan process.",
                                                    style: TextStyle(
                                                      fontSize: FontConstants.f12,
                                                      fontWeight: FontConstants.w400,
                                                      fontFamily: FontConstants.fontFamily,
                                                      color: ColorConstant.blackTextColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),

                                                  // Progress bar
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: LinearProgressIndicator(
                                                      value: 1.0, // 100%
                                                      minHeight: 8,
                                                      backgroundColor: Colors.grey.shade200,
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                        ColorConstant.appThemeColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: Text("100%"),
                                                  ),

                                                  SizedBox(height: 20),
                                                  // Button
                                                ],
                                              ),
                                            ),
                                          ),
                                          Stack(
                                            children: [
                                              // Decorative background image in top-right
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Image.asset(
                                                  ImageConstants.rotDashboardBackground, // your decorative pattern
                                                  width: 180,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                              // Person image (overlapping on design)
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Image.asset(
                                                  ImageConstants.rotDashboardBannerGirl, // replace with your person asset
                                                  height: 166,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              // Content (Text + progress bar + button)
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: FontConstants.horizontalPadding,
                                        ),
                                        child: Loan112Button(
                                          onPressed: (){
                                            var navigationData = dashBoarddataModel
                                                ?.data
                                                ?.applyLoanBanner
                                                ?.appBannerBtnGotoFlag;
                                            if (navigationData == 0 ||
                                                navigationData == 1 ||
                                                navigationData == 2) {
                                              context.push(
                                                AppRouterName.loanApplicationPage,
                                              );
                                            }
                                            if (navigationData == 3) {
                                              context.push(
                                                AppRouterName.dashBoardStatus,
                                              );
                                            } else if (navigationData == 4) {
                                              context.push(
                                                AppRouterName.repaymentPage,
                                              );
                                            }
                                          },
                                          text:
                                          dashBoarddataModel
                                              ?.data
                                              ?.applyLoanBanner
                                              ?.appBannerBtnText ??
                                              "",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12.0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            /*
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                personalLoanApplyWidget(
                                  context,
                                  dashBoarddataModel!,
                                ),
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
                                          dashBoarddataModel
                                              ?.data!
                                              .applyLoanBanner!
                                              .appBannerTitle ??
                                              "",
                                          //"Easy personal Loans",
                                          style: TextStyle(
                                            fontFamily:
                                            FontConstants.fontFamily,
                                            fontSize: FontConstants.f18,
                                            fontWeight: FontConstants.w800,
                                            color: ColorConstant.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //This 2nd Positioned Contains Button
                                Positioned(
                                  bottom: -20,
                                  left: 80,
                                  right: 80,
                                  child: GestureDetector(
                                    onTap: () {
                                      var navigationData = dashBoarddataModel
                                          ?.data
                                          ?.applyLoanBanner
                                          ?.appBannerBtnGotoFlag;
                                      if (navigationData == 0 ||
                                          navigationData == 1 ||
                                          navigationData == 2) {
                                        context.push(
                                          AppRouterName.loanApplicationPage,
                                        );
                                      }
                                      if (navigationData == 3) {
                                        context.push(
                                          AppRouterName.dashBoardStatus,
                                        );
                                      } else if (navigationData == 4) {
                                        context.push(
                                          AppRouterName.repaymentPage,
                                        );
                                      }
                                    },
                                    child: Loan112Button(
                                      onPressed: null,
                                      text:
                                      dashBoarddataModel
                                          ?.data
                                          ?.applyLoanBanner
                                          ?.appBannerBtnText ??
                                          "",
                                    ),
                                  ),
                                ),
                              ],
                            ),

                             */
                            SizedBox(height: 10.0),
                            (dashBoarddataModel?.data?.activeLoanDetails !=
                                null &&
                                (dashBoarddataModel
                                    ?.data
                                    ?.activeLoanDetails
                                    ?.loanNo !=
                                    null ||
                                    dashBoarddataModel
                                        ?.data
                                        ?.activeLoanDetails
                                        ?.loanNo !=
                                        ""))
                                ? DashboardLoanDetails(
                              activeLoanDetails: dashBoarddataModel
                                  ?.data!
                                  .activeLoanDetails,
                            )
                                : (dashBoarddataModel?.data?.showLoanHistoryBtnFlag == 1)?
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      context.push(AppRouterName.repaymentPage);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color: Colors.blue.shade100,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.shade50,
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Check Your Loan History',
                                              style: TextStyle(
                                                  fontSize: FontConstants.f14,
                                                  fontFamily: FontConstants.fontFamily,
                                                  fontWeight: FontConstants.w700,
                                                  color: ColorConstant.blackTextColor
                                              )
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: ColorConstant.blueTextColor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ):
                            SizedBox.shrink(),
                            SizedBox(height: 17.0),
                            YoutubeVideoPlayCard(
                              onTap: () {},
                            ),
                            SizedBox(height: 17.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: FontConstants.horizontalPadding,
                                  ),
                                  child: Text(
                                    "We Provide",
                                    style: TextStyle(
                                      fontSize: FontConstants.f18,
                                      fontWeight: FontConstants.w800,
                                      fontFamily: FontConstants.fontFamily,
                                      color: ColorConstant.blackTextColor,
                                    ),
                                  ),
                                ),
                                //const SizedBox(height: 16),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: FontConstants.horizontalPadding,
                                  ),
                                  child: SizedBox(
                                    height: 150,
                                    child: PageView.builder(
                                      controller: _controller,
                                      itemCount:
                                      dashBoarddataModel
                                          ?.data
                                          ?.appBanners
                                          ?.length ??
                                          0,
                                      padEnds: false,
                                      itemBuilder: (context, index) {
                                        final item = dashBoarddataModel
                                            ?.data
                                            ?.appBanners?[index];
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            0,
                                          ),
                                          child: Image.network(
                                            item?.imgUrl ?? "",
                                            height: 150,
                                            loadingBuilder:
                                                (
                                                context,
                                                child,
                                                loadingProgress,
                                                ) {
                                              if (loadingProgress == null)
                                                return child;
                                              return const Center(
                                                child:
                                                CircularProgressIndicator(),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                            const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: SmoothPageIndicator(
                                    controller: _controller,
                                    count:
                                    dashBoarddataModel
                                        ?.data
                                        ?.appBanners
                                        ?.length ??
                                        0,
                                    effect: const WormEffect(
                                      dotHeight: 8,
                                      dotWidth: 8,
                                      spacing: 8,
                                      dotColor: Colors.grey,
                                      activeDotColor: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 17.0),
                            FraudWarningCard()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else {
            return commonScaffold(
              context,
              bodyPart: SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                          color: ColorConstant.whiteColor,
                        )
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget commonScaffold(
    BuildContext context, {
    required Widget bodyPart,
    dashBoardModel,
  }) {
    return SafeArea(child: bodyPart);
  }

  Widget personalLoanApplyWidget(
    BuildContext context,
    DashBoarddataModel dashBoardModel,
  ) {
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
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            //vertical: 32,
          ),
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
              const SizedBox(height: 20),
              // other content goes here
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dashBoardModel.data?.applyLoanBanner?.appBannerText ?? "",
                      //"Discover the possibilities with an instant personal loan up to Rs 1.2 Lakh. Curious about your eligibility? There's only one way to find out",
                      style: TextStyle(
                        fontWeight: FontConstants.w600,
                        fontSize: FontConstants.f14,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.greyTextColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  CircularProgressWithText(
                    progress:
                        (dashBoardModel
                                .data
                                ?.applyLoanBanner
                                ?.appBannerProgressPercent ??
                            0) /
                        100,
                    isDrawer: false,
                  ),
                ],
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ],
    );
  }
}

class YoutubeVideoPlayCard extends StatelessWidget {
  final VoidCallback onTap;

  const YoutubeVideoPlayCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.teal, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left YouTube icon
              const Icon(Icons.play_circle_fill, color: Colors.red, size: 28),

              const SizedBox(width: 12),

              // Text inside gradient bubble
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFF00838F)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.6, 1.0],
                  ),
                ),
                child: Row(
                  children: const [
                    Text(
                      "Watch  video tutorial",
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.teal, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FraudWarningCard extends StatelessWidget {
  const FraudWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.red.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "⚠️ Warning: Beware of fraud!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Always use our secure Repayment Website for loan payments. Do not make direct bank payments. Rupee On Time is not responsible for payments made to other accounts.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
