class VerifyIfscParamModel {
  final String bankAccountIfsc;

  VerifyIfscParamModel({required this.bankAccountIfsc});

  factory VerifyIfscParamModel.fromJson(Map<String, dynamic> json) {
    return VerifyIfscParamModel(
      bankAccountIfsc: json['bank_account_ifsc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_account_ifsc': bankAccountIfsc,
    };
  }
}
