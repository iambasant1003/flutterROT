class UpdateBankDetailsParamModel {
  final String custId;
  final String leadId;
  final String account;
  final String confirmAccount;
  final String ifsc;
  final String accountType;
  final String type;

  UpdateBankDetailsParamModel({
    required this.custId,
    required this.leadId,
    required this.account,
    required this.confirmAccount,
    required this.ifsc,
    required this.accountType,
    required this.type,
  });

  factory UpdateBankDetailsParamModel.fromJson(Map<String, dynamic> json) {
    return UpdateBankDetailsParamModel(
      custId: json['custId'],
      leadId: json['leadId'],
      account: json['account'],
      confirmAccount: json['confirmAccount'],
      ifsc: json['ifsc'],
      accountType: json['accountType'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custId': custId,
      'leadId': leadId,
      'account': account,
      'confirmAccount': confirmAccount,
      'ifsc': ifsc,
      'accountType': accountType,
      'type': type,
    };
  }
}
