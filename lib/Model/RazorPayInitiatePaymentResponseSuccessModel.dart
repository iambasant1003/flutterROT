class RazorPayInitiatePaymentResponseSuccessModel {
  int? status;
  String? message;
  Data? data;

  RazorPayInitiatePaymentResponseSuccessModel(
      {this.status, this.message, this.data});

  RazorPayInitiatePaymentResponseSuccessModel.fromJson(
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
  String? gatewayKey;
  String? gatewaySecretKey;
  String? companyId;
  String? razorOrderId;
  String? paymentAmount;
  String? leadId;

  Data(
      {this.gatewayKey,
      this.gatewaySecretKey,
      this.companyId,
      this.razorOrderId,
      this.paymentAmount,
      this.leadId});

  Data.fromJson(Map<String, dynamic> json) {
    gatewayKey = json['gateway_key'];
    gatewaySecretKey = json['gateway_secret_key'];
    companyId = json['company_id'];
    razorOrderId = json['razor_order_id'];
    paymentAmount = json['payment_amount'];
    leadId = json['lead_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gateway_key'] = this.gatewayKey;
    data['gateway_secret_key'] = this.gatewaySecretKey;
    data['company_id'] = this.companyId;
    data['razor_order_id'] = this.razorOrderId;
    data['payment_amount'] = this.paymentAmount;
    data['lead_id'] = this.leadId;
    return data;
  }
}
