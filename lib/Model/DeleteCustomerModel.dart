class DeleteCustomerModel {
  final dynamic data;
  final String? message;
  final int? status;

  DeleteCustomerModel({
    this.data,
    this.message,
    required this.status,
  });

  factory DeleteCustomerModel.fromJson(Map<String, dynamic> json) {
    return DeleteCustomerModel(
      data: json['Data'],
      message: json['Message'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Data': data,
      'Message': message,
      'Status': status,
    };
  }
}
