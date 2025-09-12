class DeleteProfileOTPVerifyModel {
  int? status;
  String? message;
  dynamic data;

  DeleteProfileOTPVerifyModel({this.status, this.message, this.data});

  DeleteProfileOTPVerifyModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['Data'] = this.data;
    return data;
  }
}
