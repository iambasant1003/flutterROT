import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Widget/app_bar.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import '../../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Model/VerifyOTPModel.dart';
import '../../../../Utils/MysharePrefenceClass.dart';

class BankStatementScreen extends StatefulWidget {
  const BankStatementScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BankStatementScreen();
}

class _BankStatementScreen extends State<BankStatementScreen> {
  bool isOnlineSelected = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: ColorConstant.appThemeColor,
          ),
        ),

        /// Form + Button
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Custom AppBar
              Padding(
                padding: EdgeInsets.zero,
                child: Loan112AppBar(
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
              ),
              const SizedBox(height: 16),

              /// Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24),
                    ),
                    color: ColorConstant.whiteColor,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: FontConstants.horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32.0),
                          Text(
                            "Choose how would you like to provide your Bank Statement for verification",
                            style: TextStyle(
                              fontSize: FontConstants.f14,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontConstants.w500,
                              color: const Color(0xff344054),
                            ),
                          ),
                          const SizedBox(height: 32),

                          /// Online Option
                          _buildOptionCard(
                            label: "Account Aggregator (Recommended)",
                            description:
                            "Securely fetch your bank statement via Account aggregator",
                            isSelected: isOnlineSelected,
                            onTap: () {
                              setState(() => isOnlineSelected = true);
                            },
                            showMostUsed: true,
                          ),
                          const SizedBox(height: 20),

                          /// Offline Option
                          _buildOptionCard(
                            label: "Bank Statement PDF",
                            description:
                            "Upload a pdf of your bank statement manually",
                            isSelected: !isOnlineSelected,
                            onTap: () {
                              setState(() => isOnlineSelected = false);
                            },
                          ),

                          const SizedBox(height: 25),

                          /// Continue Button
                          Center(
                            child: SizedBox(
                              width: 170,
                              child: Loan112Button(
                                onPressed: () {
                                  if (isOnlineSelected) {
                                    context.push(AppRouterName.onlineBankStatement);
                                  } else {
                                    context.push(AppRouterName.offlineBankStatement);
                                  }
                                },
                                text: "CONTINUE",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Custom Option Widget
  Widget _buildOptionCard({
    required String label,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
    bool showMostUsed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? ColorConstant.appThemeColor
                : ColorConstant.greyTextColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
          color: ColorConstant.whiteColor,
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Radio Circle
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? ColorConstant.appThemeColor
                          : ColorConstant.greyTextColor,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: ColorConstant.appThemeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 12),

                /// Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: FontConstants.f16,
                          fontWeight: FontConstants.w600,
                          fontFamily: FontConstants.fontFamily,
                          color: ColorConstant.blackTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: FontConstants.f14,
                          fontFamily: FontConstants.fontFamily,
                          fontWeight: FontConstants.w500,
                          color: ColorConstant.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// MOST USED Tag
            if (showMostUsed)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "MOST USED",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
