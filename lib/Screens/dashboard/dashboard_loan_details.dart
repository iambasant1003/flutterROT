import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Widget/common_button.dart';

import '../../Model/DashBoarddataModel.dart';
import '../../Routes/app_router_name.dart';

class DashboardLoanDetails extends StatelessWidget {
  final  ActiveLoanDetails? activeLoanDetails;
  DashboardLoanDetails({super.key,required this.activeLoanDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Your Loan Details',
            style: TextStyle(
                fontSize: FontConstants.f18,
                fontWeight:FontConstants.w800,
                fontFamily: FontConstants.fontFamily,
                color: ColorConstant.blackTextColor
            ),
          ),
          const SizedBox(height: 10),
          // Card
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan Account Number',
                      style: TextStyle(
                          fontSize: FontConstants.f14,
                          fontWeight:FontConstants.w800,
                          fontFamily: FontConstants.fontFamily,
                          color: ColorConstant.blackTextColor
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Account row
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Text(
                            activeLoanDetails?.loanNo ?? "",
                            style: TextStyle(
                                fontSize: FontConstants.f16,
                                fontWeight:FontConstants.w500,
                                fontFamily: FontConstants.fontFamily,
                                color: ColorConstant.blackTextColor
                            ),
                          ),
                          Icon(Icons.lock_outline,color: ColorConstant.blackTextColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Info grid
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.shade100,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:  [
                                  Text(
                                      'Repay Amount',
                                      style: tabHeaderStyle
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                      'Rs. ${activeLoanDetails?.repaymentAmount}/-',
                                      style: tabValueStyle
                                  ),
                                ],
                              ),
                            )
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.shade100,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children:  [
                                  Text(
                                      'Repayment Date',
                                      style: tabHeaderStyle
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                      '${activeLoanDetails?.repaymentDate}',
                                      style: tabValueStyle
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.shade100,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:  [
                                  Text(
                                      'Total Due',
                                      style: tabHeaderStyle
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                      '${activeLoanDetails?.totalDue}',
                                      style: tabValueStyle
                                  ),
                                ],
                              ),
                            )
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.shade100,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children:  [
                                  Text(
                                      'Remaining Days',
                                      style: tabHeaderStyle
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                      '${activeLoanDetails?.remainingDays} Days',
                                      style: tabValueStyle
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              Positioned(
                bottom: -20,
                left: 50,
                right: 50,
                child: SizedBox(
                  width: 150,
                  child: Loan112Button(
                    onPressed: () {
                      context.push(AppRouterName.repaymentPage);
                    },
                    text: "REPAY LOAN",
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 40),
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
          )
        ],
      ),
    );
  }



  TextStyle tabHeaderStyle =  TextStyle(
     fontSize: FontConstants.f12,
      fontFamily: FontConstants.fontFamily,
      fontWeight: FontConstants.w700,
     color: ColorConstant.blackTextColor
  );
  TextStyle tabValueStyle = TextStyle(
     fontSize: FontConstants.f16,
      fontWeight: FontConstants.w700,
      fontFamily: FontConstants.fontFamily,
      color: Color(0xff1C6BAD)
  );

}





