class CalculateDistanceResponseModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  CalculateDistanceResponseModel(
      {this.statusCode, this.data, this.success, this.message});

  CalculateDistanceResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? permanentAddress;
  String? officeAddress;
  String? isResidenceProofRequired;
  bool? rangeDistanceFlag;

  Data(
      {this.permanentAddress,
      this.officeAddress,
      this.isResidenceProofRequired,
      this.rangeDistanceFlag});

  Data.fromJson(Map<String, dynamic> json) {
    permanentAddress = json['permanentAddress'];
    officeAddress = json['officeAddress'];
    isResidenceProofRequired = json['isResidenceProofRequired'];
    rangeDistanceFlag = json['rangeDistanceFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permanentAddress'] = this.permanentAddress;
    data['officeAddress'] = this.officeAddress;
    data['isResidenceProofRequired'] = this.isResidenceProofRequired;
    data['rangeDistanceFlag'] = this.rangeDistanceFlag;
    return data;
  }
}
