import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';

void startCashFreeDropCheckout({
  required BuildContext context,
  required String orderId,
  required String paymentSessionId,
  required Future<bool> Function(String orderId) verifyPaymentStatus, // ✅ NEW
  bool isProd = false,
}) {
  try {
    DebugPrint.prt("Session Id $paymentSessionId, Order Id $orderId");

    final CFSession session = CFSessionBuilder()
        .setEnvironment(
          isProd ? CFEnvironment.PRODUCTION : CFEnvironment.SANDBOX,
        )
        .setOrderId(orderId)
        .setPaymentSessionId(paymentSessionId)
        .build();

    final CFDropCheckoutPayment cfDropCheckoutPayment =
        CFDropCheckoutPaymentBuilder().setSession(session).build();

    final CFPaymentGatewayService cfPaymentGatewayService =
        CFPaymentGatewayService();

    // ✅ Set callbacks
    cfPaymentGatewayService.setCallback(
      (String returnedOrderId) async {
        DebugPrint.prt("CF SDK success callback for order: $returnedOrderId");

        // Call verifyPaymentStatus function
        bool isPaymentVerified = await verifyPaymentStatus(returnedOrderId);

        if (isPaymentVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ Payment Verified for Order: $returnedOrderId"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("⚠️ Payment could not be verified!"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (CFErrorResponse error, String orderId) {
        DebugPrint.prt("CF SDK error: ${error.getMessage()}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Payment Failed: ${error.getMessage()}"),
            backgroundColor: Colors.red,
          ),
        );
      },
    );

    // ✅ Start payment
    cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
  } catch (e) {
    if (e is CFException) {
      debugPrint("CFException occurred: ${e.message}");
    } else {
      debugPrint("Unexpected error: $e");
    }
  }
}
