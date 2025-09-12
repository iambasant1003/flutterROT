class AddReferenceModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  AddReferenceModel({this.statusCode, this.data, this.success, this.message});

  AddReferenceModel.fromJson(Map<String, dynamic> json) {
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
  String? finalResult;

  Data({this.finalResult});

  Data.fromJson(Map<String, dynamic> json) {
    finalResult = json['finalResult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['finalResult'] = this.finalResult;
    return data;
  }
}
