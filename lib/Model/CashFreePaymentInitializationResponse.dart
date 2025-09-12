class CashFreePaymentInitializationResponse {
  int? status;
  String? message;
  CashFreePayment? data;

  CashFreePaymentInitializationResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CashFreePaymentInitializationResponse.fromJson(Map<String, dynamic> json) {
    return CashFreePaymentInitializationResponse(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      data: json['Data'] != null
          ? CashFreePayment.fromJson(json['Data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'Data': data?.toJson(),
    };
  }
}

class CashFreePayment {
  String? apiVersion;
  String? gatewayKey;
  String? gatewaySecretKey;
  String? leadID;
  String? orderId;
  String? paymentSessionId;
  double? paymentAmount;

  CashFreePayment({
    this.apiVersion,
    this.gatewayKey,
    this.gatewaySecretKey,
    this.leadID,
    this.orderId,
    this.paymentSessionId,
    this.paymentAmount,
  });

  factory CashFreePayment.fromJson(Map<String, dynamic> json) {
    return CashFreePayment(
      apiVersion: json['api_version'] as String?,
      gatewayKey: json['gateway_key'] as String?,
      gatewaySecretKey: json['gateway_secret_key'] as String?,
      leadID: json['lead_id'] as String?,
      orderId: json['order_id'] as String?,
      paymentSessionId: json['payment_session_id'] as String?,
      paymentAmount: (json['payment_amount'] != null)
          ? (json['payment_amount'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'api_version': apiVersion,
      'gateway_key': gatewayKey,
      'gateway_secret_key': gatewaySecretKey,
      'lead_id': leadID,
      'order_id': orderId,
      'payment_session_id': paymentSessionId,
      'payment_amount': paymentAmount,
    };
  }
}
