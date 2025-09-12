class VerifyOTPModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  VerifyOTPModel({this.statusCode, this.data, this.success, this.message});

  VerifyOTPModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}

class Data {
  String? custId;
  String? leadId;
  String? firstName;
  String? middleName;
  String? lastName;
  int? mobile;
  String? pancard;
  String? personalEmail;
  int? isRegister;
  int? custIdDecode;
  String? token;

  Data({
    this.custId,
    this.leadId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.mobile,
    this.pancard,
    this.personalEmail,
    this.isRegister,
    this.custIdDecode,
    this.token,
  });

  Data.fromJson(Map<String, dynamic> json) {
    custId = json['custId'];
    leadId = json['leadId'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    pancard = json['pancard'];
    personalEmail = json['personalEmail'];
    isRegister = json['isRegister'];
    custIdDecode = json['custIdDecode'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['custId'] = custId;
    data['leadId'] = leadId;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['mobile'] = mobile;
    data['pancard'] = pancard;
    data['personalEmail'] = personalEmail;
    data['isRegister'] = isRegister;
    data['custIdDecode'] = custIdDecode;
    data['token'] = token;
    return data;
  }
}
