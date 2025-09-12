
import 'package:loan112_app/Model/CashFreePaymentResponseModel.dart';
import 'package:loan112_app/Model/RazorPayCheckPaymentStatusModel.dart';
import '../../Model/CashFreePaymentInitializationResponse.dart';
import '../../Model/RazorPayInitiatePaymentResponseSuccessModel.dart';


abstract class RepaymentState {}

class RepaymentInitial extends RepaymentState {}

class RepaymentLoading extends RepaymentState{}

class RazorpayPaymentInitiateSuccess extends RepaymentState{
  final RazorPayInitiatePaymentResponseSuccessModel razorPayInitiatePaymentResponseSuccessModel;
  RazorpayPaymentInitiateSuccess(this.razorPayInitiatePaymentResponseSuccessModel);
}

class RazorpayPaymentInitiateFailed extends RepaymentState{
  final RazorPayInitiatePaymentResponseSuccessModel razorPayInitiatePaymentResponseModel;
  RazorpayPaymentInitiateFailed(this.razorPayInitiatePaymentResponseModel);
}


class CheckRazorPayPaymentStatusSuccess extends RepaymentState{
  final RazorPayCheckPaymentStatusModel razorPayCheckPaymentStatusModel;
  CheckRazorPayPaymentStatusSuccess(this.razorPayCheckPaymentStatusModel);
}

class CheckRazorPayPaymentStatusFailed extends RepaymentState{
  final RazorPayCheckPaymentStatusModel razorPayCheckPaymentStatusModel;
  CheckRazorPayPaymentStatusFailed(this.razorPayCheckPaymentStatusModel);
}

class CashFreeInitiateSuccess extends RepaymentState{
  final CashFreePaymentInitializationResponse cashFreePaymentInitializationResponse;
  CashFreeInitiateSuccess(this.cashFreePaymentInitializationResponse);
}

class CashFreeInitiateFailed extends RepaymentState{
  final CashFreePaymentInitializationResponse cashFreePaymentInitializationResponse;
  CashFreeInitiateFailed(this.cashFreePaymentInitializationResponse);
}

class CashFreePaymentStatusSuccess extends RepaymentState{
  final CashFreePaymentResponseModel cashFreePaymentResponseModel;
  CashFreePaymentStatusSuccess(this.cashFreePaymentResponseModel);
}

class CashFreePaymentStatusFailed extends RepaymentState{
  final CashFreePaymentResponseModel cashFreePaymentResponseModel;
  CashFreePaymentStatusFailed(this.cashFreePaymentResponseModel);
}



