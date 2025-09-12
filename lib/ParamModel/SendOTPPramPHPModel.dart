class SendOTPPramPHPModel {
  String? currentPage;
  String? mobile;
  int? isExistingCustomer;
  int? adjustAdid;
  int? adjustGpsId;
  int? adjustIdfa;
  String? pancard;
  String? geoLat;
  String? geoLong;
  String? utmSource;
  String? utmMedium;
  String? utmCampaign;
  String? fcmToken;
  String? appfylerUid;
  String? appfylerAdvertiserId;
  String? deviceId;

  SendOTPPramPHPModel(
      {this.currentPage,
      this.mobile,
      this.isExistingCustomer,
      this.adjustAdid,
      this.adjustGpsId,
      this.adjustIdfa,
      this.pancard,
      this.geoLat,
      this.geoLong,
      this.utmSource,
      this.utmMedium,
      this.utmCampaign,
      this.fcmToken,
      this.appfylerUid,
      this.appfylerAdvertiserId,
      this.deviceId});

  SendOTPPramPHPModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    mobile = json['mobile'];
    isExistingCustomer = json['is_existing_customer'];
    adjustAdid = json['adjust_adid'];
    adjustGpsId = json['adjust_gps_id'];
    adjustIdfa = json['adjust_idfa'];
    pancard = json['pancard'];
    geoLat = json['geo_lat'];
    geoLong = json['geo_long'];
    utmSource = json['utm_source'];
    utmMedium = json['utm_medium'];
    utmCampaign = json['utm_campaign'];
    fcmToken = json['fcm_token'];
    appfylerUid = json['appfyler_uid'];
    appfylerAdvertiserId = json['appfyler_advertiser_id'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['mobile'] = this.mobile;
    data['is_existing_customer'] = this.isExistingCustomer;
    data['adjust_adid'] = this.adjustAdid;
    data['adjust_gps_id'] = this.adjustGpsId;
    data['adjust_idfa'] = this.adjustIdfa;
    data['pancard'] = this.pancard;
    data['geo_lat'] = this.geoLat;
    data['geo_long'] = this.geoLong;
    data['utm_source'] = this.utmSource;
    data['utm_medium'] = this.utmMedium;
    data['utm_campaign'] = this.utmCampaign;
    data['fcm_token'] = this.fcmToken;
    data['appfyler_uid'] = this.appfylerUid;
    data['appfyler_advertiser_id'] = this.appfylerAdvertiserId;
    data['device_id'] = this.deviceId;
    return data;
  }
}
