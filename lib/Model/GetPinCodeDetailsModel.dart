class GetPinCodeDetailsModel {
  int? status;
  String? message;
  Data? data;

  GetPinCodeDetailsModel({this.status, this.message, this.data});

  GetPinCodeDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? cityId;
  String? cityName;
  String? stateId;
  String? stateName;
  String? pincode;

  Data(
      {this.cityId, this.cityName, this.stateId, this.stateName, this.pincode});

  Data.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    cityName = json['city_name'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['pincode'] = this.pincode;
    return data;
  }
}
