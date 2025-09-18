import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Model/GetLoanHistoryModel.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/common_textField.dart';
import '../../Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import '../../Model/SendPhpOTPModel.dart';
import '../../Utils/MysharePrefenceClass.dart';

class LoanListPage extends StatefulWidget {
  final GetLoanHistoryModel loanHistoryModel;
  const LoanListPage({super.key,required this.loanHistoryModel});

  @override
  State<LoanListPage> createState() => _LoanListPageState();
}

class _LoanListPageState extends State<LoanListPage> {
  int? _expandedIndex = 0;
  TextEditingController amountController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return widget.loanHistoryModel.data == null?
        SizedBox.shrink():
        ListView.builder(
      itemCount: widget.loanHistoryModel.data?.length,
      itemBuilder: (context, index) {
        bool isExpanded = _expandedIndex == index;
        var loanData = widget.loanHistoryModel.data?[index];

        return  Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_expandedIndex == index) {
                    _expandedIndex = null; // collapse if tapped again
                  } else {
                    _expandedIndex = index; // expand this one
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                decoration: BoxDecoration(
                  color: loanData?.loanActiveStatus == 1 ? ColorConstant.appThemeColor : ColorConstant.whiteColor,
                  borderRadius: isExpanded?
                      BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        topLeft: Radius.circular(12.0)
                      ):
                  BorderRadius.circular(12),
                  border: Border.all(
                    color: loanData?.loanActiveStatus == 1?
                        ColorConstant.appThemeColor:
                      ColorConstant.textFieldBorderColor,
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getLoanTitle(index,loanData?.loanActiveStatus?? 0),
                            style: TextStyle(
                                fontSize: FontConstants.f16,
                                fontWeight: FontConstants.w700,
                                fontFamily: FontConstants.fontFamily,
                                color: loanData?.loanActiveStatus == 1?
                                    ColorConstant.whiteColor:
                                    ColorConstant.blackTextColor
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "View More",
                                style: TextStyle(
                                    fontFamily: FontConstants.fontFamily,
                                    fontWeight: FontConstants.w500,
                                    fontSize: 9.0,
                                    color: loanData?.loanActiveStatus == 1?
                                        ColorConstant.whiteColor:
                                        ColorConstant.blackTextColor
                                ),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: loanData?.loanActiveStatus == 1
                                    ? Colors.white
                                    : (isExpanded ? Colors.blue : Colors.black),
                              ),

                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Divider(
                        height: 2,
                        color: ColorConstant.appThemeColor,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total Repayment Amount",
                                style: TextStyle(
                                    fontSize: FontConstants.f12,
                                    fontWeight: FontConstants.w500,
                                    fontFamily: FontConstants.fontFamily,
                                    color: loanData?.loanActiveStatus == 1?
                                    ColorConstant.whiteColor:
                                    ColorConstant.blackTextColor
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "₹${loanData?.loanTotalPayableAmount}",
                                style: TextStyle(
                                    fontSize: FontConstants.f18,
                                    fontWeight: FontConstants.w600,
                                    fontFamily: FontConstants.fontFamily,
                                    color: loanData?.loanActiveStatus == 1?
                                    ColorConstant.whiteColor:
                                    ColorConstant.blackTextColor
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Divider(
                            height: 2,
                            color: ColorConstant.greyTextColor,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Repayment Date",
                                style: TextStyle(
                                    fontSize: FontConstants.f12,
                                    fontWeight: FontConstants.w500,
                                    fontFamily: FontConstants.fontFamily,
                                    color: loanData?.loanActiveStatus == 1?
                                    ColorConstant.whiteColor:
                                        ColorConstant.blackTextColor
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "01/12/24",
                                style: TextStyle(
                                    fontSize: FontConstants.f12,
                                    fontWeight: FontConstants.w600,
                                    fontFamily: FontConstants.fontFamily,
                                    color: loanData?.loanActiveStatus == 1?
                                    ColorConstant.whiteColor:
                                    ColorConstant.blackTextColor
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (isExpanded) _buildDetailsSection(loanData, index),
          ],
        );
      },
    );
  }

  Widget _buildDetailsSection(var loanData,int index) {
    if(loanData.loanActiveStatus == 1){
      amountController.text = (loanData.loanTotalOutstandingAmount ?? 0).toString();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          border: Border.all(
            color: ColorConstant.textFieldBorderColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            children: [
              _buildRow("Loan Number", "${loanData?.loanNo ?? ""}/-"),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Sanction Loan Amount (Rs.)", "${loanData?.loanRecommended ?? ""}/-"),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Rate of Interest (%) Per Day", "${loanData?.roi ?? ""}"),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Disbursal Date", loanData?.disbursalDate),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Total Repayment Amount (Rs.)", "${loanData?.loanTotalPayableAmount ?? ""}/-"),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Tenure in Days", "${loanData?.tenure ?? ""}"),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Repayment Date", loanData?.repaymentDate ?? ""),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Panel Interest (%) Per day", "${loanData?.panelRoi ?? ""}"),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Penalty Amount", "${loanData?.loanTotalPenaltyAmount ?? ""}"),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Remaining Amount", "${loanData?.loanTotalOutstandingAmount ?? ""}"),
              Divider(
                height: 2,
                color: Color(0xffE0E0E0),
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRow("Status", "${loanData?.status ?? ""}"),
              loanData.loanActiveStatus ==1?
              SizedBox(height: 12):
              SizedBox.shrink(),
              loanData.loanActiveStatus ==1?
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffE6E4E4)
                  ),
                  color: ColorConstant.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payable Amount',
                      style: TextStyle(
                        fontWeight: FontConstants.w800,
                        fontSize: FontConstants.f12,
                        color: ColorConstant.blackTextColor,
                        fontFamily: FontConstants.fontFamily
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextField(
                            controller: amountController,
                            maxLength: 7,
                            hintText: "Enter Amount",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: ColorConstant.appThemeColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              String amountText = amountController.text.trim();
                              if (amountText.isEmpty) {
                                openSnackBar(context, "Please enter amount");
                                return;
                              }

                              int enteredAmount = int.tryParse(amountController.text.trim().toString()) ?? 0;
                              int repaymentAmount = int.tryParse(loanData?.loanTotalOutstandingAmount.toString() ?? "0") ?? 0;

                              if (enteredAmount == 0) {
                                openSnackBar(context, "Payable amount should be greater than 0");
                                return;
                              } else if (enteredAmount > repaymentAmount) {
                                openSnackBar(context, "Payable amount should be less than remaining amount");
                                return;
                              }

                              // If all validations pass → navigate
                              context.push(
                                AppRouterName.paymentOptionScreen,
                                extra: {
                                  'loanData': loanData,
                                  'amount': amountText,
                                },
                              ).then((val) {
                                amountController.clear();
                                getLoanHistory();
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'PAY NOW',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ):
              SizedBox.shrink(),
              SizedBox(height: 8)
            ]
          ),
        ),
      ),
    );
  }

  getLoanHistory() async{
    var otpModel = await MySharedPreferences.getPhpOTPModel();
    SendPhpOTPModel sendPhpOTPModel = SendPhpOTPModel.fromJson(jsonDecode(otpModel));
    context.read<LoanApplicationCubit>().getLoanHistoryApiCall({
      "cust_profile_id": sendPhpOTPModel.data?.custProfileId
    });
  }

  Widget _buildRow(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: FontConstants.f12,
                  fontWeight: FontConstants.w700,
                  fontFamily: FontConstants.fontFamily,
                  color: ColorConstant.greyTextColor
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: FontConstants.f14,
                  fontWeight: FontConstants.w700,
                  fontFamily: FontConstants.fontFamily,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0)
      ],
    );
  }

  String formatDate(String? date) {
    DebugPrint.prt("Disbursal Date $date");
    if (date == null || date.isEmpty) return '';
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return ''; // or handle error
    }
  }

  String _getLoanTitle(int index, int loanActiveStatus) {
    // Find first active loan index
    int firstActiveIndex = widget.loanHistoryModel.data
        ?.indexWhere((e) => e.loanActiveStatus == 1) ??
        -1;

    if (loanActiveStatus == 1) {
      return "Active Loan";
    } else {
      return "Loan ${index+1}";
    }
  }
}
