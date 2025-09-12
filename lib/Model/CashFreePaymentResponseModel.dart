class CashFreePaymentResponseModel {
  final int? status;
  final String? message;

  CashFreePaymentResponseModel({this.status, this.message});

  factory CashFreePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return CashFreePaymentResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
    };
  }
}
