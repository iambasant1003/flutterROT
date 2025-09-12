class CheckBankStatementStatusModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  CheckBankStatementStatusModel(
      {this.statusCode, this.data, this.success, this.message});

  CheckBankStatementStatusModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? aaConsentStatus;
  int? bankStatementFetched;
  String? message;

  Data({this.aaConsentStatus, this.bankStatementFetched, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    aaConsentStatus = json['aa_consent_status'];
    bankStatementFetched = json['bank_statement_fetched'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aa_consent_status'] = this.aaConsentStatus;
    data['bank_statement_fetched'] = this.bankStatementFetched;
    data['message'] = this.message;
    return data;
  }
}
