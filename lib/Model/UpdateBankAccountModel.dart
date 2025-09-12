class UpdateBankAccountModel {
  final int? statusCode;
  final BankAccountPost? data;
  final bool? success;
  final String? message;

  UpdateBankAccountModel({
    this.statusCode,
    this.data,
    this.success,
    this.message,
  });

  factory UpdateBankAccountModel.fromJson(Map<String, dynamic> json) {
    return UpdateBankAccountModel(
      statusCode: json['statusCode'],
      data: json['data'] != null ? BankAccountPost.fromJson(json['data']) : null,
      success: json['success'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data?.toJson(),
      'success': success,
      'message': message,
    };
  }
}

class BankAccountPost {
  final String? reference;

  BankAccountPost({this.reference});

  factory BankAccountPost.fromJson(Map<String, dynamic> json) {
    return BankAccountPost(
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
    };
  }
}
