class IfscCodeModel {
  int? status;
  String? message;
  Data? data;

  IfscCodeModel({this.status, this.message, this.data});

  IfscCodeModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? bankAccountName;
  String? bankAccountBranch;
  String? bankAccountIfsc;

  Data({this.bankAccountName, this.bankAccountBranch, this.bankAccountIfsc});

  Data.fromJson(Map<String, dynamic> json) {
    bankAccountName = json['bank_account_name'];
    bankAccountBranch = json['bank_account_branch'];
    bankAccountIfsc = json['bank_account_ifsc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_account_name'] = this.bankAccountName;
    data['bank_account_branch'] = this.bankAccountBranch;
    data['bank_account_ifsc'] = this.bankAccountIfsc;
    return data;
  }
}
