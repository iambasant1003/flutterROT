class GetLoanHistoryModel {
  int? statusCode;
  List<Data>? data;
  bool? success;
  String? message;

  GetLoanHistoryModel({this.statusCode, this.data, this.success, this.message});

  GetLoanHistoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? leadId;
  String? loanNo;
  int? productId;
  int? loanRecommended;
  int? roi;
  int? repaymentAmount;
  String? repaymentDate;
  int? tenure;
  String? disbursalDate;
  int? panelRoi;
  int? loanTotalPayableAmount;
  int? leadStatusId;
  String? status;
  int? loanTotalReceivedAmount;
  int? loanTotalOutstandingAmount;
  int? loanTotalPenaltyAmount;
  int? loanActiveStatus;
  bool? razorpay;
  bool? cashfree;

  Data(
      {this.leadId,
        this.loanNo,
        this.productId,
        this.loanRecommended,
        this.roi,
        this.repaymentAmount,
        this.repaymentDate,
        this.tenure,
        this.disbursalDate,
        this.panelRoi,
        this.loanTotalPayableAmount,
        this.leadStatusId,
        this.status,
        this.loanTotalReceivedAmount,
        this.loanTotalOutstandingAmount,
        this.loanTotalPenaltyAmount,
        this.loanActiveStatus,
        this.razorpay,
        this.cashfree});

  Data.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    loanNo = json['loan_no'];
    productId = json['product_id'];
    loanRecommended = json['loan_recommended'];
    roi = json['roi'];
    repaymentAmount = json['repayment_amount'];
    repaymentDate = json['repayment_date'];
    tenure = json['tenure'];
    disbursalDate = json['disbursal_date'];
    panelRoi = json['panel_roi'];
    loanTotalPayableAmount = json['loan_total_payable_amount'];
    leadStatusId = json['lead_status_id'];
    status = json['status'];
    loanTotalReceivedAmount = json['loan_total_received_amount'];
    loanTotalOutstandingAmount = json['loan_total_outstanding_amount'];
    loanTotalPenaltyAmount = json['loan_total_penalty_amount'];
    loanActiveStatus = json['loan_active_status'];
    razorpay = json['razorpay'];
    cashfree = json['cashfree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_id'] = this.leadId;
    data['loan_no'] = this.loanNo;
    data['product_id'] = this.productId;
    data['loan_recommended'] = this.loanRecommended;
    data['roi'] = this.roi;
    data['repayment_amount'] = this.repaymentAmount;
    data['repayment_date'] = this.repaymentDate;
    data['tenure'] = this.tenure;
    data['disbursal_date'] = this.disbursalDate;
    data['panel_roi'] = this.panelRoi;
    data['loan_total_payable_amount'] = this.loanTotalPayableAmount;
    data['lead_status_id'] = this.leadStatusId;
    data['status'] = this.status;
    data['loan_total_received_amount'] = this.loanTotalReceivedAmount;
    data['loan_total_outstanding_amount'] = this.loanTotalOutstandingAmount;
    data['loan_total_penalty_amount'] = this.loanTotalPenaltyAmount;
    data['loan_active_status'] = this.loanActiveStatus;
    data['razorpay'] = this.razorpay;
    data['cashfree'] = this.cashfree;
    return data;
  }
}
