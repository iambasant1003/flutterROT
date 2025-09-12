class SendOTPModel {
  int? statusCode;
  String? data;
  bool? success;
  String? message;

  SendOTPModel({this.statusCode, this.data, this.success, this.message});

  SendOTPModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['data'] = this.data;
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}


class SendOTPModelPHP {
  int? status;
  String? message;
  String? data;

  SendOTPModelPHP({this.status, this.message, this.data});

  SendOTPModelPHP.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['Data'] = this.data;
    return data;
  }
}

