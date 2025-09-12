class AppVersionRequestModel {
  String? appName;
  int? version;
  String? fcmToken;
  String? deviceId;

  AppVersionRequestModel(
      {this.appName, this.version, this.fcmToken, this.deviceId});

  AppVersionRequestModel.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    version = json['version'];
    fcmToken = json['fcm_token'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['version'] = this.version;
    data['fcm_token'] = this.fcmToken;
    data['device_id'] = this.deviceId;
    return data;
  }
}
