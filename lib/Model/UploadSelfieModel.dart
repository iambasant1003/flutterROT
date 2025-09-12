class UploadSelfieModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  UploadSelfieModel({this.statusCode, this.data, this.success, this.message});

  UploadSelfieModel.fromJson(Map<String, dynamic> json) {
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
  int? fieldCount;
  int? affectedRows;
  int? insertId;
  String? info;
  int? serverStatus;
  int? warningStatus;
  int? changedRows;
  String? decision;
  int? loanAmount;
  String? userType;
  bool? checkKycFlag;

  Data(
      {this.fieldCount,
        this.affectedRows,
        this.insertId,
        this.info,
        this.serverStatus,
        this.warningStatus,
        this.changedRows,
        this.decision,
        this.loanAmount,
        this.userType,
        this.checkKycFlag});

  Data.fromJson(Map<String, dynamic> json) {
    fieldCount = json['fieldCount'];
    affectedRows = json['affectedRows'];
    insertId = json['insertId'];
    info = json['info'];
    serverStatus = json['serverStatus'];
    warningStatus = json['warningStatus'];
    changedRows = json['changedRows'];
    decision = json['decision'];
    loanAmount = json['loanAmount'];
    userType = json['userType'];
    checkKycFlag = json['checkKycFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldCount'] = this.fieldCount;
    data['affectedRows'] = this.affectedRows;
    data['insertId'] = this.insertId;
    data['info'] = this.info;
    data['serverStatus'] = this.serverStatus;
    data['warningStatus'] = this.warningStatus;
    data['changedRows'] = this.changedRows;
    data['decision'] = this.decision;
    data['loanAmount'] = this.loanAmount;
    data['userType'] = this.userType;
    data['checkKycFlag'] = this.checkKycFlag;
    return data;
  }
}
