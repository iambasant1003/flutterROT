class GetPurposeOfLoanModel {
  int? status;
  String? message;
  List<DataModeL>? data;

  GetPurposeOfLoanModel({this.status, this.message, this.data});

  GetPurposeOfLoanModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Data'] != null) {
      data = <DataModeL>[];
      json['Data'].forEach((v) {
        data!.add(new DataModeL.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataModeL {
  String? loanPurposeId;
  String? loanPurposeName;

  DataModeL({this.loanPurposeId, this.loanPurposeName});

  DataModeL.fromJson(Map<String, dynamic> json) {
    loanPurposeId = json['loan_purpose_id'];
    loanPurposeName = json['loan_purpose_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loan_purpose_id'] = this.loanPurposeId;
    data['loan_purpose_name'] = this.loanPurposeName;
    return data;
  }
}
