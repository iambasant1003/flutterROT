
class CheckRazorPayPaymentStatusParamModel {
  String? leadId;
  String? razorpayPaymentId;
  String? recoveryById;
  String? remarks;

  CheckRazorPayPaymentStatusParamModel({
    this.leadId,
    this.razorpayPaymentId,
    this.recoveryById,
    this.remarks,
  });

  factory CheckRazorPayPaymentStatusParamModel.fromJson(Map<String, dynamic> json) {
    return CheckRazorPayPaymentStatusParamModel(
      leadId: json['lead_id'] as String?,
      razorpayPaymentId: json['razorpay_payment_id'] as String?,
      recoveryById: json['recovery_by_id'] as String?,
      remarks: json['remarks'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lead_id': leadId,
      'razorpay_payment_id': razorpayPaymentId,
      'recovery_by_id': recoveryById,
      'remarks': remarks,
    };
  }
}
