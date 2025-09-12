class DeleteVerifyOTPParamModel {
  String? currentPage;
  String? custProfileId;
  int? deleteProfileConsent;
  int? deleteProfileOtp;

  DeleteVerifyOTPParamModel({
    this.currentPage,
    this.custProfileId,
    this.deleteProfileConsent,
    this.deleteProfileOtp,
  });

  factory DeleteVerifyOTPParamModel.fromJson(Map<String, dynamic> json) {
    return DeleteVerifyOTPParamModel(
      currentPage: json['current_page'],
      custProfileId: json['cust_profile_id'],
      deleteProfileConsent: json['delete_profile_consent'],
      deleteProfileOtp: json['delete_profile_otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'cust_profile_id': custProfileId,
      'delete_profile_consent': deleteProfileConsent,
      'delete_profile_otp': deleteProfileOtp,
    };
  }
}
