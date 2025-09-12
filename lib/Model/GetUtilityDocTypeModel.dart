class GetUtilityDocTypeModel {
  int? statusCode;
  List<Data>? data;
  bool? success;
  String? message;

  GetUtilityDocTypeModel(
      {this.statusCode, this.data, this.success, this.message});

  GetUtilityDocTypeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? docsId;
  String? docType;
  int? isRequired;
  bool? isUploaded;

  Data({this.docsId, this.docType, this.isRequired, this.isUploaded});

  Data.fromJson(Map<String, dynamic> json) {
    docsId = json['docsId'];
    docType = json['docType'];
    isRequired = json['isRequired'];
    isUploaded = json['isUploaded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docsId'] = this.docsId;
    data['docType'] = this.docType;
    data['isRequired'] = this.isRequired;
    data['isUploaded'] = this.isUploaded;
    return data;
  }
}
