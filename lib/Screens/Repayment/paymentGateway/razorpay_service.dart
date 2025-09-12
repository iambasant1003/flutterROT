import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


typedef PaymentSuccessCallback = void Function(String paymentId);
typedef PaymentErrorCallback = void Function(String code, String message);

class RazorpayService {
  late Razorpay _razorpay;

  void initRazorpay({
    required BuildContext context,
    required PaymentSuccessCallback onSuccess,
    required PaymentErrorCallback onError,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      onSuccess(response.paymentId ?? '',);
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      onError(response.code.toString(), response.message ?? 'Unknown error');
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
      EasyLoading.showInfo('External wallet selected: ${response.walletName}');
    });
  }

  void openCheckout({
    required BuildContext context,
    required String orderId,
    required String amount,
    required String leadId,
    required String key,
  }) {
    var options = {
      'key': key,
      'amount': (double.tryParse(amount) ?? 0) * 100, // convert to paise
      'name': 'Loan112',
      'description': 'Payment for Lead $leadId',
      'order_id': orderId,
      'prefill': {
        'contact': '9000000000',
        'email': 'test@loan112.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      EasyLoading.showError('Payment initialization failed');
      debugPrint('Razorpay error: $e');
    }
  }

  void clear() {
    _razorpay.clear();
  }
}
