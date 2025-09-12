class GenerateLoanOfferModel {
  int? statusCode;
  Data? data;
  bool? success;
  String? message;

  GenerateLoanOfferModel(
      {this.statusCode, this.data, this.success, this.message});

  GenerateLoanOfferModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? statusId;
  int? maxLoanAmount;
  int? minLoanAmount;
  int? maxLoanTenure;
  int? minLoanTenure;
  int? interestRate;
  int? processingFee;
  String? minLoanTenureText;
  String? maxLoanTenureText;
  String? loanQuotePageTopText;
  String? loanQuotePageBottomText;
  String? interestRateText;
  String? processingFeeText;
  String? totalInterestText;
  int? productId;
  String? loanTenureText;
  int? showFixedTenure;

  Data(
      {this.statusId,
        this.maxLoanAmount,
        this.minLoanAmount,
        this.maxLoanTenure,
        this.minLoanTenure,
        this.interestRate,
        this.processingFee,
        this.minLoanTenureText,
        this.maxLoanTenureText,
        this.loanQuotePageTopText,
        this.loanQuotePageBottomText,
        this.interestRateText,
        this.processingFeeText,
        this.totalInterestText,
        this.productId,
        this.loanTenureText,
        this.showFixedTenure});

  Data.fromJson(Map<String, dynamic> json) {
    statusId = json['statusId'];
    maxLoanAmount = json['max_loan_amount'];
    minLoanAmount = json['min_loan_amount'];
    maxLoanTenure = json['max_loan_tenure'];
    minLoanTenure = json['min_loan_tenure'];
    interestRate = json['interest_rate'];
    processingFee = json['processing_fee'];
    minLoanTenureText = json['min_loan_tenure_text'];
    maxLoanTenureText = json['max_loan_tenure_text'];
    loanQuotePageTopText = json['loan_quote_page_top_text'];
    loanQuotePageBottomText = json['loan_quote_page_bottom_text'];
    interestRateText = json['interest_rate_text'];
    processingFeeText = json['processing_fee_text'];
    totalInterestText = json['total_interest_text'];
    productId = json['product_id'];
    loanTenureText = json['loan_tenure_text'];
    showFixedTenure = json['show_fixed_tenure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusId'] = this.statusId;
    data['max_loan_amount'] = this.maxLoanAmount;
    data['min_loan_amount'] = this.minLoanAmount;
    data['max_loan_tenure'] = this.maxLoanTenure;
    data['min_loan_tenure'] = this.minLoanTenure;
    data['interest_rate'] = this.interestRate;
    data['processing_fee'] = this.processingFee;
    data['min_loan_tenure_text'] = this.minLoanTenureText;
    data['max_loan_tenure_text'] = this.maxLoanTenureText;
    data['loan_quote_page_top_text'] = this.loanQuotePageTopText;
    data['loan_quote_page_bottom_text'] = this.loanQuotePageBottomText;
    data['interest_rate_text'] = this.interestRateText;
    data['processing_fee_text'] = this.processingFeeText;
    data['total_interest_text'] = this.totalInterestText;
    data['product_id'] = this.productId;
    data['loan_tenure_text'] = this.loanTenureText;
    data['show_fixed_tenure'] = this.showFixedTenure;
    return data;
  }
}
