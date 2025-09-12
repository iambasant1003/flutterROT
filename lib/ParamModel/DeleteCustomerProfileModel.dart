class DeleteCustomerProfileModel {
   String? currentPage;
   String? custProfileId;

  DeleteCustomerProfileModel({
     this.currentPage,
     this.custProfileId,
  });

  factory DeleteCustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return DeleteCustomerProfileModel(
      currentPage: json['current_page'],
      custProfileId: json['cust_profile_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'cust_profile_id': custProfileId,
    };
  }
}
