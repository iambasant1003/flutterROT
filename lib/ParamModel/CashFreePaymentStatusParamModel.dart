class CashFreePaymentStatusParamModel {
   String? leadId;
   String? orderId;

  CashFreePaymentStatusParamModel({this.leadId, this.orderId});

  Map<String, dynamic> toJson() {
    return {
      'lead_id': leadId,
      'order_id': orderId,
    };
  }

  factory CashFreePaymentStatusParamModel.fromJson(Map<String, dynamic> json) {
    return CashFreePaymentStatusParamModel(
      leadId: json['lead_id'] as String?,
      orderId: json['order_id'] as String?,
    );
  }
}
