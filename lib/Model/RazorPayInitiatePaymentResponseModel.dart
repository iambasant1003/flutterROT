class RazorPayInitiatePaymentResponseModel {
  int? status;
  String? message;
  Data? data;

  RazorPayInitiatePaymentResponseModel(
      {this.status, this.message, this.data});

  RazorPayInitiatePaymentResponseModel.fromJson(
      Map<String, dynamic> json) {
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
  String? razorOrderId;
  String? paymentAmount;
  String? leadId;

  Data({this.razorOrderId, this.paymentAmount, this.leadId});

  Data.fromJson(Map<String, dynamic> json) {
    razorOrderId = json['razor_order_id'];
    paymentAmount = json['payment_amount'];
    leadId = json['lead_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['razor_order_id'] = this.razorOrderId;
    data['payment_amount'] = this.paymentAmount;
    data['lead_id'] = this.leadId;
    return data;
  }
}
