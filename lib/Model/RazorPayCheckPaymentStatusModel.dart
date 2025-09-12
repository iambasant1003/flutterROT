class RazorPayCheckPaymentStatusModel {
  PaymentCompleteData? data;
  String? message;
  int? status;

  RazorPayCheckPaymentStatusModel({
    this.data,
    this.message,
    this.status,
  });

  factory RazorPayCheckPaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return RazorPayCheckPaymentStatusModel(
      data: json['Data'] != null
          ? PaymentCompleteData.fromJson(json['Data'] as Map<String, dynamic>)
          : null,
      message: json['Message'] as String?,
      status: json['Status'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Data': data?.toJson(),
      'Message': message,
      'Status': status,
    };
  }
}

class PaymentCompleteData {
  String? id;
  String? entity;
  int? amount;
  String? currency;
  String? status;
  String? orderId;
  String? invoiceId;
  bool? international;
  String? method;
  int? amountRefunded;
  String? refundStatus;
  bool? captured;
  String? description;
  String? cardId;
  String? bank;
  String? wallet;
  String? vpa;
  String? email;
  String? contact;
  Notes? notes;
  int? fee;
  int? tax;
  String? errorCode;
  String? errorDescription;
  String? errorSource;
  String? errorStep;
  String? errorReason;
  AcquirerData? acquirerData;
  int? createdAt;

  PaymentCompleteData({
    this.id,
    this.entity,
    this.amount,
    this.currency,
    this.status,
    this.orderId,
    this.invoiceId,
    this.international,
    this.method,
    this.amountRefunded,
    this.refundStatus,
    this.captured,
    this.description,
    this.cardId,
    this.bank,
    this.wallet,
    this.vpa,
    this.email,
    this.contact,
    this.notes,
    this.fee,
    this.tax,
    this.errorCode,
    this.errorDescription,
    this.errorSource,
    this.errorStep,
    this.errorReason,
    this.acquirerData,
    this.createdAt,
  });

  factory PaymentCompleteData.fromJson(Map<String, dynamic> json) {
    return PaymentCompleteData(
      id: json['id'] as String?,
      entity: json['entity'] as String?,
      amount: json['amount'] as int?,
      currency: json['currency'] as String?,
      status: json['status'] as String?,
      orderId: json['order_id'] as String?,
      invoiceId: json['invoice_id'] as String?,
      international: json['international'] as bool?,
      method: json['method'] as String?,
      amountRefunded: json['amount_refunded'] as int?,
      refundStatus: json['refund_status'] as String?,
      captured: json['captured'] as bool?,
      description: json['description'] as String?,
      cardId: json['card_id'] as String?,
      bank: json['bank'] as String?,
      wallet: json['wallet'] as String?,
      vpa: json['vpa'] as String?,
      email: json['email'] as String?,
      contact: json['contact'] as String?,
      notes: json['notes'] != null
          ? Notes.fromJson(json['notes'] as Map<String, dynamic>)
          : null,
      fee: json['fee'] as int?,
      tax: json['tax'] as int?,
      errorCode: json['error_code'] as String?,
      errorDescription: json['error_description'] as String?,
      errorSource: json['error_source'] as String?,
      errorStep: json['error_step'] as String?,
      errorReason: json['error_reason'] as String?,
      acquirerData: json['acquirer_data'] != null
          ? AcquirerData.fromJson(json['acquirer_data'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity': entity,
      'amount': amount,
      'currency': currency,
      'status': status,
      'order_id': orderId,
      'invoice_id': invoiceId,
      'international': international,
      'method': method,
      'amount_refunded': amountRefunded,
      'refund_status': refundStatus,
      'captured': captured,
      'description': description,
      'card_id': cardId,
      'bank': bank,
      'wallet': wallet,
      'vpa': vpa,
      'email': email,
      'contact': contact,
      'notes': notes?.toJson(),
      'fee': fee,
      'tax': tax,
      'error_code': errorCode,
      'error_description': errorDescription,
      'error_source': errorSource,
      'error_step': errorStep,
      'error_reason': errorReason,
      'acquirer_data': acquirerData?.toJson(),
      'created_at': createdAt,
    };
  }
}

class Notes {
  String? leadId;
  String? loanNo;
  String? paymentRequestedBy;

  Notes({
    this.leadId,
    this.loanNo,
    this.paymentRequestedBy,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      leadId: json['lead_id'] as String?,
      loanNo: json['loan_no'] as String?,
      paymentRequestedBy: json['payment_requested_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lead_id': leadId,
      'loan_no': loanNo,
      'payment_requested_by': paymentRequestedBy,
    };
  }
}

class AcquirerData {
  String? bankTransactionId;

  AcquirerData({
    this.bankTransactionId,
  });

  factory AcquirerData.fromJson(Map<String, dynamic> json) {
    return AcquirerData(
      bankTransactionId: json['bank_transaction_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_transaction_id': bankTransactionId,
    };
  }
}
