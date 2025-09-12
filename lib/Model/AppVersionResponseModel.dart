class AppVersionResponseModel {
  String? message;
  int? status;
  String? version;

  AppVersionResponseModel({this.message, this.status, this.version});

  AppVersionResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    data['version'] = this.version;
    return data;
  }
}
