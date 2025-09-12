class GetCityAndStateRequest {
  final String custProfileId;
  final String leadId;
  final String pincode;

  GetCityAndStateRequest({
    required this.custProfileId,
    required this.leadId,
    required this.pincode,
  });

  Map<String, dynamic> toJson() {
    return {
      'cust_profile_id': custProfileId,
      'lead_id': leadId,
      'pincode': pincode,
    };
  }
}
