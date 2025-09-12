class UploadBankStatementModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  UploadBankStatementModel(
      {this.statusCode, this.data, this.success, this.message});

  UploadBankStatementModel.fromJson(Map<String, dynamic> json) {
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
  int? timerVal;

  Data(
      {this.fieldCount,
        this.affectedRows,
        this.insertId,
        this.info,
        this.serverStatus,
        this.warningStatus,
        this.changedRows,
        this.timerVal});

  Data.fromJson(Map<String, dynamic> json) {
    fieldCount = json['fieldCount'];
    affectedRows = json['affectedRows'];
    insertId = json['insertId'];
    info = json['info'];
    serverStatus = json['serverStatus'];
    warningStatus = json['warningStatus'];
    changedRows = json['changedRows'];
    timerVal = json['timerVal'];
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
    data['timerVal'] = this.timerVal;
    return data;
  }
}
