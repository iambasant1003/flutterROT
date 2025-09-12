class VerifyPHPOTPModel {
  int? status;
  String? message;
  Data? data;

  VerifyPHPOTPModel({this.status, this.message, this.data});

  VerifyPHPOTPModel.fromJson(Map<String, dynamic> json) {
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
  String? appLoginToken;
  int? mobileVerifiedStatus;

  Data({this.appLoginToken, this.mobileVerifiedStatus});

  Data.fromJson(Map<String, dynamic> json) {
    appLoginToken = json['app_login_token'];
    mobileVerifiedStatus = json['mobile_verified_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_login_token'] = this.appLoginToken;
    data['mobile_verified_status'] = this.mobileVerifiedStatus;
    return data;
  }
}
