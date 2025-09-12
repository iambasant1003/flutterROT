class EkycVerificationModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  EkycVerificationModel(
      {this.statusCode, this.data, this.success, this.message});

  EkycVerificationModel.fromJson(Map<String, dynamic> json) {
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
  int? ekycVerifiedFlag;

  Data({this.ekycVerifiedFlag});

  Data.fromJson(Map<String, dynamic> json) {
    ekycVerifiedFlag = json['ekyc_verified_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ekyc_verified_flag'] = this.ekycVerifiedFlag;
    return data;
  }
}
