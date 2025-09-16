import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Cubit/repayment_cubit/RepaymentCubit.dart';
import 'package:rupeeontime/Cubit/repayment_cubit/RepaymentState.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Screens/Repayment/paymentGateway/cashfree_pg_service.dart';
import 'package:rupeeontime/Screens/Repayment/paymentGateway/razorpay_service.dart';
import 'package:rupeeontime/Utils/CleverTapEventsName.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Model/GetLoanHistoryModel.dart';
import '../../Utils/CleverTapLogger.dart';
import '../../Widget/app_bar.dart';

class PaymentOptionScreen extends StatefulWidget {
  final getLoanHistoryModel;
  final partAmount;

  const PaymentOptionScreen({
    super.key,
    required this.getLoanHistoryModel,
    required this.partAmount,
  });

  @override
  State<StatefulWidget> createState() => _PaymentOptionScreen();
}

class _PaymentOptionScreen extends State<PaymentOptionScreen> {
  int choosePaymentMethod = 0;
  Data apiData = Data();
  RazorpayService razorpayService = RazorpayService();

  @override
  void initState() {
    super.initState();
    apiData = widget.getLoanHistoryModel as Data;
    razorpayService.initRazorpay(
      context: context,
      onSuccess: (paymentId) {
        context.read<RePaymentCubit>().checkRazorpayPaymentStatus(
          paymentId,
          apiData.leadId!,
        );
      },
      onError: (code, message) {
        openSnackBar(context, "Payment failed: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appThemeColor,
      appBar: Loan112AppBar(
        leadingSpacing: 25,
        title: Text(
          "Loan History",
          style: TextStyle(
            fontSize: FontConstants.f18,
            fontFamily: FontConstants.fontFamily,
            fontWeight: FontConstants.w700,
            color: ColorConstant.whiteColor
          ),
        ),
        customLeading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(left:0.0),
            child: InkWell(
              onTap: () {
                context.pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: ColorConstant.whiteColor,
              ),
            ),
          ),
        ),
      ),
      body: BlocListener<RePaymentCubit, RepaymentState>(
        listener: (BuildContext context, RepaymentState state) {
          if (state is RepaymentLoading) {
            EasyLoading.show(status: "Please wait...");
          } else if (state is RazorpayPaymentInitiateSuccess) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.RAZORPAY_PAYMENT_INITIATED, isSuccess: true);
            DebugPrint.prt(
              "Razorpay Payment Initiated ${state.razorPayInitiatePaymentResponseSuccessModel}",
            );
            final model =
                state.razorPayInitiatePaymentResponseSuccessModel.data;
            if (model != null &&
                model.razorOrderId != null &&
                model.paymentAmount != null &&
                model.leadId != null) {
              razorpayService.openCheckout(
                context: context,
                orderId: model.razorOrderId!,
                amount: model.paymentAmount!,
                leadId: model.leadId!,
                key: model.gatewayKey!,
              );
            } else {
              openSnackBar(context, "Invalid payment data");
            }
          } else if (state is RazorpayPaymentInitiateFailed) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.RAZORPAY_PAYMENT_INITIATED, isSuccess: false);
            openSnackBar(
              context,
              state.razorPayInitiatePaymentResponseModel.message ??
                  "UnExpected Error",
            );
          } else if (state is CashFreeInitiateSuccess) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.CASHEFREE_PAYMENT_INITIATED, isSuccess: true);
            DebugPrint.prt(
              "CashFree initialization success ${state.cashFreePaymentInitializationResponse.data?.toJson()}",
            );
            startCashFreeDropCheckout(
              context: context,
              orderId:
                  state.cashFreePaymentInitializationResponse.data?.orderId ??
                  "",
              paymentSessionId:
                  state
                      .cashFreePaymentInitializationResponse
                      .data
                      ?.paymentSessionId ??
                  "",
              verifyPaymentStatus: (String orderId) async {
                if (orderId == "") {
                  context.read<RePaymentCubit>().checkCashFreePayment(orderId);
                  return true;
                } else {
                  return false;
                }
              },
            );
          } else if (state is CashFreeInitiateFailed) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.CASHEFREE_PAYMENT_INITIATED, isSuccess: false);
            openSnackBar(
              context,
              state.cashFreePaymentInitializationResponse.message ??
                  "UnExpected Error",
            );
          } else if (state is CheckRazorPayPaymentStatusSuccess) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.RAZORPAY_PAYMENT_DONE, isSuccess: true);
            // openSnackBar(
            //   context,
            //   state.razorPayCheckPaymentStatusModel.message!,
            //   backGroundColor: ColorConstant.appThemeColor,
            // );
            context.push(AppRouterName.paymentStatusPage);
          } else if (state is CheckRazorPayPaymentStatusFailed) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.RAZORPAY_PAYMENT_DONE, isSuccess: false);
            openSnackBar(
              context,
              state.razorPayCheckPaymentStatusModel.message!,
              backGroundColor: ColorConstant.appThemeColor,
            );
          } else if (state is CashFreePaymentStatusSuccess) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.CASHEFREE_PAYMENT_DONE, isSuccess: true);
            // openSnackBar(
            //   context,
            //   state.cashFreePaymentResponseModel.message!,
            //   backGroundColor: ColorConstant.appThemeColor,
            // );
            context.push(AppRouterName.paymentStatusPage);
          } else if (state is CashFreePaymentStatusFailed) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.CASHEFREE_PAYMENT_DONE, isSuccess: false);
            openSnackBar(
              context,
              state.cashFreePaymentResponseModel.message ?? "UnExpected Error",
            );
          }
        },
        child: Container(
          margin: EdgeInsets.only(top: 12.0),
          decoration: BoxDecoration(
              color: ColorConstant.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(54.0),
              topRight: Radius.circular(54.0),
            )
          ),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Payment With Ease",
                      style: TextStyle(
                        fontSize: FontConstants.f20,
                        fontWeight: FontConstants.w800,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.blackTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    "We are processing your loan payment. Please review the details below and confirm to proceed. Your payment will be securely processed, and you will receive a confirmation once the transaction is complete.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontConstants.w600,
                      fontSize: FontConstants.f12,
                      fontFamily: FontConstants.fontFamily,
                      color: Color(0xff494848),
                    ),
                  ),
                  SizedBox(height: 34),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: ColorConstant.appThemeColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    padding: EdgeInsets.all(FontConstants.horizontalPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pending Repayment",
                                style: TextStyle(
                                  color: ColorConstant.whiteColor,
                                  fontFamily: FontConstants.fontFamily,
                                  fontSize: FontConstants.f14,
                                  fontWeight: FontConstants.w700,
                                ),
                              ),
                              SizedBox(height: 18.0),
                              Text(
                                "${widget.partAmount} /-",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontConstants.w700,
                                  fontFamily: FontConstants.fontFamily,
                                  color: ColorConstant.whiteColor,
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Text(
                                    "REPAYMENT DATE",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xff6ECCE3),
                                      fontFamily: FontConstants.fontFamily,
                                      fontWeight: FontConstants.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    "${apiData.repaymentDate}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xff6ECCE3),
                                      fontFamily: FontConstants.fontFamily,
                                      fontWeight: FontConstants.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          ImageConstants.visaCardIcon,
                          width: 67,
                          height: 41,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 65),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: FontConstants.f16,
                          color: ColorConstant.blackTextColor,
                          fontWeight: FontConstants.w600,
                          fontFamily: FontConstants.fontFamily,
                        ),
                        children: [
                          TextSpan(text: 'Choose Your '),
                          TextSpan(
                            text: 'Payment',
                            style: TextStyle(
                              color: ColorConstant.appThemeColor,
                              fontWeight: FontConstants.w600,
                            ),
                          ),
                          TextSpan(text: ' Option'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: 0,
                            groupValue: choosePaymentMethod,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            // removes extra padding
                            visualDensity: VisualDensity.compact,
                            // makes the radio even tighter
                            onChanged: (val) {
                              setState(() {
                                choosePaymentMethod = val!;
                              });
                            },
                          ),
                          SizedBox(width: 12.0),
                          Image.asset(
                            ImageConstants.cashFreeImage,
                            width: 113,
                            height: 35,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: 1,
                            groupValue: choosePaymentMethod,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            // removes extra padding
                            visualDensity: VisualDensity.compact,
                            // makes the radio even tighter
                            onChanged: (val) {
                              setState(() {
                                choosePaymentMethod = val!;
                              });
                            },
                          ),
                          SizedBox(width: 12.0),
                          Image.asset(
                            ImageConstants.razorPayImage,
                            width: 113,
                            height: 35,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Loan112Button(
                    text: "PAY NOW",
                    onPressed: () {
                      if (choosePaymentMethod == 1) {
                        context.read<RePaymentCubit>().initiateRazorpayPayment(
                          widget.partAmount,
                          apiData.leadId ?? "",
                        );
                      } else {
                        context.read<RePaymentCubit>().initiateCashFreePayment(
                          widget.partAmount,
                          apiData.leadId ?? "",
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
