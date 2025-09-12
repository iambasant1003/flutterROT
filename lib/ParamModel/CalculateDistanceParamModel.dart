class CalculateDistanceParamModel {
  String? custId;
  String? leadId;
  String? sourceLatitude;
  String? sourceLongitude;

  CalculateDistanceParamModel(
      {this.custId, this.leadId, this.sourceLatitude, this.sourceLongitude});

  CalculateDistanceParamModel.fromJson(Map<String, dynamic> json) {
    custId = json['custId'];
    leadId = json['leadId'];
    sourceLatitude = json['sourceLatitude'];
    sourceLongitude = json['sourceLongitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['custId'] = this.custId;
    data['leadId'] = this.leadId;
    data['sourceLatitude'] = this.sourceLatitude;
    data['sourceLongitude'] = this.sourceLongitude;
    return data;
  }
}
