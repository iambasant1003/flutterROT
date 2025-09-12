class SendPhpOTPModel {
  int? status;
  String? message;
  Data? data;

  SendPhpOTPModel({this.status, this.message, this.data});

  SendPhpOTPModel.fromJson(Map<String, dynamic> json) {
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
  String? custProfileId;
  String? mobile;
  String? appflyerProfileId;

  Data({this.custProfileId, this.mobile, this.appflyerProfileId});

  Data.fromJson(Map<String, dynamic> json) {
    custProfileId = json['cust_profile_id'];
    mobile = json['mobile'];
    appflyerProfileId = json['appflyer_profile_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cust_profile_id'] = this.custProfileId;
    data['mobile'] = this.mobile;
    data['appflyer_profile_id'] = this.appflyerProfileId;
    return data;
  }
}
