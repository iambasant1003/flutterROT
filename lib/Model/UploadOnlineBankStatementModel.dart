class UploadOnlineBankStatementModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  UploadOnlineBankStatementModel(
      {this.statusCode, this.data, this.success, this.message});

  UploadOnlineBankStatementModel.fromJson(Map<String, dynamic> json) {
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
  int? apiStatusId;
  String? url;

  Data({this.apiStatusId, this.url});

  Data.fromJson(Map<String, dynamic> json) {
    apiStatusId = json['apiStatusId'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apiStatusId'] = this.apiStatusId;
    data['url'] = this.url;
    return data;
  }
}
