class CustomerKycModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  CustomerKycModel({this.statusCode, this.data, this.success, this.message});

  CustomerKycModel.fromJson(Map<String, dynamic> json) {
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
  int? validStatus;
  String? url;
  String? error;

  Data({this.validStatus, this.url, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    validStatus = json['validStatus'];
    url = json['url'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['validStatus'] = this.validStatus;
    data['url'] = this.url;
    data['error'] = this.error;
    return data;
  }
}
