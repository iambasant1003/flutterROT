class CashFreePaymentInitializationParamModel {
  double? amount;
  String? leadId;

  CashFreePaymentInitializationParamModel({
    this.amount,
    this.leadId,
  });

  factory CashFreePaymentInitializationParamModel.fromJson(Map<String, dynamic> json) {
    return CashFreePaymentInitializationParamModel(
      amount: (json['amount'] != null) ? (json['amount'] as num).toDouble() : null,
      leadId: json['lead_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'lead_id': leadId,
    };
  }
}
