
class RazorPayPaymentInitialParamModel {
  double? amount;
  String? leadId;
  int? productType;// Always 0

  RazorPayPaymentInitialParamModel({
    this.amount,
    this.leadId,
    this.productType,
  });

  factory RazorPayPaymentInitialParamModel.fromJson(Map<String, dynamic> json) {
    return RazorPayPaymentInitialParamModel(
      amount: (json['amount'] as num?)?.toDouble(),
      leadId: json['lead_id'] as String?,
      productType: json['product_type'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'lead_id': leadId,
      'product_type': productType,
    };
  }
}
