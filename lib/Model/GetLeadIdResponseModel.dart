class GetLeadIdResponseModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  GetLeadIdResponseModel(
      {this.statusCode, this.data, this.success, this.message});

  GetLeadIdResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? leadId;

  Data({this.leadId});

  Data.fromJson(Map<String, dynamic> json) {
    leadId = json['leadId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadId'] = this.leadId;
    return data;
  }
}
