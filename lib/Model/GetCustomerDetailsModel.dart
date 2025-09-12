class GetCustomerDetailsModel {
  int? status;
  String? message;
  Data? data;

  GetCustomerDetailsModel({this.status, this.message, this.data});

  GetCustomerDetailsModel.fromJson(Map<String, dynamic> json) {
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
  CustomerDetails? customerDetails;
  ScreenDetails? screenDetails;
  DocDetails? docDetails;
  ApplicationStatus? applicationStatus;
  LoanDetails? loanDetails;

  Data(
      {this.customerDetails,
        this.screenDetails,
        this.docDetails,
        this.applicationStatus,
        this.loanDetails});

  Data.fromJson(Map<String, dynamic> json) {
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;
    screenDetails = json['screen_details'] != null
        ? new ScreenDetails.fromJson(json['screen_details'])
        : null;
    docDetails = json['doc_details'] != null
        ? new DocDetails.fromJson(json['doc_details'])
        : null;
    applicationStatus = json['application_status'] != null
        ? new ApplicationStatus.fromJson(json['application_status'])
        : null;
    loanDetails = json['loan_details'] != null
        ? new LoanDetails.fromJson(json['loan_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customerDetails != null) {
      data['customer_details'] = this.customerDetails!.toJson();
    }
    if (this.screenDetails != null) {
      data['screen_details'] = this.screenDetails!.toJson();
    }
    if (this.docDetails != null) {
      data['doc_details'] = this.docDetails!.toJson();
    }
    if (this.applicationStatus != null) {
      data['application_status'] = this.applicationStatus!.toJson();
    }
    if (this.loanDetails != null) {
      data['loan_details'] = this.loanDetails!.toJson();
    }
    return data;
  }
}

class CustomerDetails {
  bool? existingCustomer;
  String? mobile;
  String? mobileVerified;
  String? pancard;
  String? pancardVerifiedStatus;
  String? fullName;
  String? dob;
  String? gender;
  String? residencePincode;
  String? residenceCityId;
  String? residenceStateId;
  String? residenceCityCode;
  String? residenceStateCode;
  String? residenceCityName;
  String? residenceStateName;
  String? residenceTypeId;
  String? residenceTypeName;
  String? residenceAddress1;
  String? residenceAddress2;
  String? residenceLandmark;
  String? personalEmail;
  String? personalEmailVerifiedStatus;
  String? incomeTypeId;
  String? monthlyIncome;
  String? salaryModeId;
  String? salaryModeName;
  String? salaryDate;
  String? maritalStatusId;
  String? maritalStatusName;
  String? spouseName;
  int? ekycVerifiedStatus;
  int? aadhaarFetched;
  int? panFetched;
  String? empWorkMode;
  String? empCompanyName;
  String? empCompanyType;
  String? empCompanyTypeId;
  String? empDesignation;
  String? empPincode;
  String? empCityId;
  String? empStateId;
  String? empCityName;
  String? empStateName;
  String? empAddress1;
  String? empAddress2;
  String? empLandmark;
  String? officeEmail;
  int? officeEmailVerifiedStatus;
  String? leadId;
  String? aadhaarNo;
  String? bankAccountNumber;
  String? cnfBankAccountNumber;
  String? bankAccountIfsc;
  String? bankAccountName;
  String? bankAccountBranch;
  String? bankAccountTypeId;
  String? bankAccountTypeName;
  int? bankAccountStatus;
  String? customerType;
  int? applicationFilledPercent;
  int? ekycSkipButtonFlag;
  String? refrenceName;
  String? refrenceMobile;
  String? refrenceType;

  CustomerDetails(
      {this.existingCustomer,
        this.mobile,
        this.mobileVerified,
        this.pancard,
        this.pancardVerifiedStatus,
        this.fullName,
        this.dob,
        this.gender,
        this.residencePincode,
        this.residenceCityId,
        this.residenceStateId,
        this.residenceCityCode,
        this.residenceStateCode,
        this.residenceCityName,
        this.residenceStateName,
        this.residenceTypeId,
        this.residenceTypeName,
        this.residenceAddress1,
        this.residenceAddress2,
        this.residenceLandmark,
        this.personalEmail,
        this.personalEmailVerifiedStatus,
        this.incomeTypeId,
        this.monthlyIncome,
        this.salaryModeId,
        this.salaryModeName,
        this.salaryDate,
        this.maritalStatusId,
        this.maritalStatusName,
        this.spouseName,
        this.ekycVerifiedStatus,
        this.aadhaarFetched,
        this.panFetched,
        this.empWorkMode,
        this.empCompanyName,
        this.empCompanyType,
        this.empCompanyTypeId,
        this.empDesignation,
        this.empPincode,
        this.empCityId,
        this.empStateId,
        this.empCityName,
        this.empStateName,
        this.empAddress1,
        this.empAddress2,
        this.empLandmark,
        this.officeEmail,
        this.officeEmailVerifiedStatus,
        this.leadId,
        this.aadhaarNo,
        this.bankAccountNumber,
        this.cnfBankAccountNumber,
        this.bankAccountIfsc,
        this.bankAccountName,
        this.bankAccountBranch,
        this.bankAccountTypeId,
        this.bankAccountTypeName,
        this.bankAccountStatus,
        this.customerType,
        this.applicationFilledPercent,
        this.ekycSkipButtonFlag,
        this.refrenceName,
        this.refrenceMobile,
        this.refrenceType});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    existingCustomer = json['existing_customer'];
    mobile = json['mobile'];
    mobileVerified = json['mobile_verified'];
    pancard = json['pancard'];
    pancardVerifiedStatus = json['pancard_verified_status'];
    fullName = json['full_name'];
    dob = json['dob'];
    gender = json['gender'];
    residencePincode = json['residence_pincode'];
    residenceCityId = json['residence_city_id'];
    residenceStateId = json['residence_state_id'];
    residenceCityCode = json['residence_city_code'];
    residenceStateCode = json['residence_state_code'];
    residenceCityName = json['residence_city_name'];
    residenceStateName = json['residence_state_name'];
    residenceTypeId = json['residence_type_id'];
    residenceTypeName = json['residence_type_name'];
    residenceAddress1 = json['residence_address_1'];
    residenceAddress2 = json['residence_address_2'];
    residenceLandmark = json['residence_landmark'];
    personalEmail = json['personal_email'];
    personalEmailVerifiedStatus = json['personal_email_verified_status'];
    incomeTypeId = json['income_type_id'];
    monthlyIncome = json['monthly_income'];
    salaryModeId = json['salary_mode_id'];
    salaryModeName = json['salary_mode_name'];
    salaryDate = json['salary_date'];
    maritalStatusId = json['marital_status_id'];
    maritalStatusName = json['marital_status_name'];
    spouseName = json['spouse_name'];
    ekycVerifiedStatus = json['ekyc_verified_status'];
    aadhaarFetched = json['aadhaar_fetched'];
    panFetched = json['pan_fetched'];
    empWorkMode = json['emp_work_mode'];
    empCompanyName = json['emp_company_name'];
    empCompanyType = json['emp_company_type'];
    empCompanyTypeId = json['emp_company_type_id'];
    empDesignation = json['emp_designation'];
    empPincode = json['emp_pincode'];
    empCityId = json['emp_city_id'];
    empStateId = json['emp_state_id'];
    empCityName = json['emp_city_name'];
    empStateName = json['emp_state_name'];
    empAddress1 = json['emp_address_1'];
    empAddress2 = json['emp_address_2'];
    empLandmark = json['emp_landmark'];
    officeEmail = json['office_email'];
    officeEmailVerifiedStatus = json['office_email_verified_status'];
    leadId = json['lead_id'];
    aadhaarNo = json['aadhaar_no'];
    bankAccountNumber = json['bank_account_number'];
    cnfBankAccountNumber = json['cnf_bank_account_number'];
    bankAccountIfsc = json['bank_account_ifsc'];
    bankAccountName = json['bank_account_name'];
    bankAccountBranch = json['bank_account_branch'];
    bankAccountTypeId = json['bank_account_type_id'];
    bankAccountTypeName = json['bank_account_type_name'];
    bankAccountStatus = json['bank_account_status'];
    customerType = json['customer_type'];
    applicationFilledPercent = json['application_filled_percent'];
    ekycSkipButtonFlag = json['ekyc_skip_button_flag'];
    refrenceName = json['refrence_name'];
    refrenceMobile = json['refrence_mobile'];
    refrenceType = json['refrence_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['existing_customer'] = this.existingCustomer;
    data['mobile'] = this.mobile;
    data['mobile_verified'] = this.mobileVerified;
    data['pancard'] = this.pancard;
    data['pancard_verified_status'] = this.pancardVerifiedStatus;
    data['full_name'] = this.fullName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['residence_pincode'] = this.residencePincode;
    data['residence_city_id'] = this.residenceCityId;
    data['residence_state_id'] = this.residenceStateId;
    data['residence_city_code'] = this.residenceCityCode;
    data['residence_state_code'] = this.residenceStateCode;
    data['residence_city_name'] = this.residenceCityName;
    data['residence_state_name'] = this.residenceStateName;
    data['residence_type_id'] = this.residenceTypeId;
    data['residence_type_name'] = this.residenceTypeName;
    data['residence_address_1'] = this.residenceAddress1;
    data['residence_address_2'] = this.residenceAddress2;
    data['residence_landmark'] = this.residenceLandmark;
    data['personal_email'] = this.personalEmail;
    data['personal_email_verified_status'] = this.personalEmailVerifiedStatus;
    data['income_type_id'] = this.incomeTypeId;
    data['monthly_income'] = this.monthlyIncome;
    data['salary_mode_id'] = this.salaryModeId;
    data['salary_mode_name'] = this.salaryModeName;
    data['salary_date'] = this.salaryDate;
    data['marital_status_id'] = this.maritalStatusId;
    data['marital_status_name'] = this.maritalStatusName;
    data['spouse_name'] = this.spouseName;
    data['ekyc_verified_status'] = this.ekycVerifiedStatus;
    data['aadhaar_fetched'] = this.aadhaarFetched;
    data['pan_fetched'] = this.panFetched;
    data['emp_work_mode'] = this.empWorkMode;
    data['emp_company_name'] = this.empCompanyName;
    data['emp_company_type'] = this.empCompanyType;
    data['emp_company_type_id'] = this.empCompanyTypeId;
    data['emp_designation'] = this.empDesignation;
    data['emp_pincode'] = this.empPincode;
    data['emp_city_id'] = this.empCityId;
    data['emp_state_id'] = this.empStateId;
    data['emp_city_name'] = this.empCityName;
    data['emp_state_name'] = this.empStateName;
    data['emp_address_1'] = this.empAddress1;
    data['emp_address_2'] = this.empAddress2;
    data['emp_landmark'] = this.empLandmark;
    data['office_email'] = this.officeEmail;
    data['office_email_verified_status'] = this.officeEmailVerifiedStatus;
    data['lead_id'] = this.leadId;
    data['aadhaar_no'] = this.aadhaarNo;
    data['bank_account_number'] = this.bankAccountNumber;
    data['cnf_bank_account_number'] = this.cnfBankAccountNumber;
    data['bank_account_ifsc'] = this.bankAccountIfsc;
    data['bank_account_name'] = this.bankAccountName;
    data['bank_account_branch'] = this.bankAccountBranch;
    data['bank_account_type_id'] = this.bankAccountTypeId;
    data['bank_account_type_name'] = this.bankAccountTypeName;
    data['bank_account_status'] = this.bankAccountStatus;
    data['customer_type'] = this.customerType;
    data['application_filled_percent'] = this.applicationFilledPercent;
    data['ekyc_skip_button_flag'] = this.ekycSkipButtonFlag;
    data['refrence_name'] = this.refrenceName;
    data['refrence_mobile'] = this.refrenceMobile;
    data['refrence_type'] = this.refrenceType;
    return data;
  }
}

class ScreenDetails {
  int? lastPage;
  int? pancardVerification;
  int? residencePincode;
  int? incomeDetails;
  int? personalDetails;
  int? promocode;
  int? residenceDetails;
  int? selfieUpload;
  int? registrationSuccessful;
  int? checkEligibility;
  int? generateLoanQuote;
  int? loanQuote;
  int? employmentWorkMode;
  int? employmentDetails;
  int? bankingDetails;
  int? aadhaarUpload;
  int? residenceProofUpload;
  int? bankStatementUpload;
  int? paySlipUpload;
  int? panUpload;
  int? accountAggregator;
  int? accountAggregatorVerify;
  int? customerReferences;
  int? ekycInitiated;
  int? ekycVerified;
  int? isEnhance;

  ScreenDetails(
      {this.lastPage,
        this.pancardVerification,
        this.residencePincode,
        this.incomeDetails,
        this.personalDetails,
        this.promocode,
        this.residenceDetails,
        this.selfieUpload,
        this.registrationSuccessful,
        this.checkEligibility,
        this.generateLoanQuote,
        this.loanQuote,
        this.employmentWorkMode,
        this.employmentDetails,
        this.bankingDetails,
        this.aadhaarUpload,
        this.residenceProofUpload,
        this.bankStatementUpload,
        this.paySlipUpload,
        this.panUpload,
        this.accountAggregator,
        this.accountAggregatorVerify,
        this.customerReferences,
        this.ekycInitiated,
        this.ekycVerified,
        this.isEnhance});

  ScreenDetails.fromJson(Map<String, dynamic> json) {
    lastPage = json['last_page'];
    pancardVerification = json['pancard_verification'];
    residencePincode = json['residence_pincode'];
    incomeDetails = json['income_details'];
    personalDetails = json['personal_details'];
    promocode = json['promocode'];
    residenceDetails = json['residence_details'];
    selfieUpload = json['selfie_upload'];
    registrationSuccessful = json['registration_successful'];
    checkEligibility = json['check_eligibility'];
    generateLoanQuote = json['generate_loan_quote'];
    loanQuote = json['loan_quote'];
    employmentWorkMode = json['employment_work_mode'];
    employmentDetails = json['employment_details'];
    bankingDetails = json['banking_details'];
    aadhaarUpload = json['aadhaar_upload'];
    residenceProofUpload = json['residence_proof_upload'];
    bankStatementUpload = json['bank_statement_upload'];
    paySlipUpload = json['pay_slip_upload'];
    panUpload = json['pan_upload'];
    accountAggregator = json['account_aggregator'];
    accountAggregatorVerify = json['account_aggregator_verify'];
    customerReferences = json['customer_references'];
    ekycInitiated = json['ekyc_initiated'];
    ekycVerified = json['ekyc_verified'];
    isEnhance = json['is_enhance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_page'] = this.lastPage;
    data['pancard_verification'] = this.pancardVerification;
    data['residence_pincode'] = this.residencePincode;
    data['income_details'] = this.incomeDetails;
    data['personal_details'] = this.personalDetails;
    data['promocode'] = this.promocode;
    data['residence_details'] = this.residenceDetails;
    data['selfie_upload'] = this.selfieUpload;
    data['registration_successful'] = this.registrationSuccessful;
    data['check_eligibility'] = this.checkEligibility;
    data['generate_loan_quote'] = this.generateLoanQuote;
    data['loan_quote'] = this.loanQuote;
    data['employment_work_mode'] = this.employmentWorkMode;
    data['employment_details'] = this.employmentDetails;
    data['banking_details'] = this.bankingDetails;
    data['aadhaar_upload'] = this.aadhaarUpload;
    data['residence_proof_upload'] = this.residenceProofUpload;
    data['bank_statement_upload'] = this.bankStatementUpload;
    data['pay_slip_upload'] = this.paySlipUpload;
    data['pan_upload'] = this.panUpload;
    data['account_aggregator'] = this.accountAggregator;
    data['account_aggregator_verify'] = this.accountAggregatorVerify;
    data['customer_references'] = this.customerReferences;
    data['ekyc_initiated'] = this.ekycInitiated;
    data['ekyc_verified'] = this.ekycVerified;
    data['is_enhance'] = this.isEnhance;
    return data;
  }
}

class DocDetails {
  BankStatement? bankStatement;
  BankStatement? paySlip;
  BankStatement? aadhaarFront;
  BankStatement? aadhaarBack;
  BankStatement? pancard;
  BankStatement? selfie;
  BankStatement? electricityBill;
  BankStatement? landlineBill;
  BankStatement? gasBill;
  BankStatement? waterBill;
  BankStatement? creditCardStatement;
  BankStatement? rentAgreement;

  DocDetails(
      {this.bankStatement,
        this.paySlip,
        this.aadhaarFront,
        this.aadhaarBack,
        this.pancard,
        this.selfie,
        this.electricityBill,
        this.landlineBill,
        this.gasBill,
        this.waterBill,
        this.creditCardStatement,
        this.rentAgreement});

  DocDetails.fromJson(Map<String, dynamic> json) {
    bankStatement = json['bank_statement'] != null
        ? new BankStatement.fromJson(json['bank_statement'])
        : null;
    paySlip = json['pay_slip'] != null
        ? new BankStatement.fromJson(json['pay_slip'])
        : null;
    aadhaarFront = json['aadhaar_front'] != null
        ? new BankStatement.fromJson(json['aadhaar_front'])
        : null;
    aadhaarBack = json['aadhaar_back'] != null
        ? new BankStatement.fromJson(json['aadhaar_back'])
        : null;
    pancard = json['pancard'] != null
        ? new BankStatement.fromJson(json['pancard'])
        : null;
    selfie = json['selfie'] != null
        ? new BankStatement.fromJson(json['selfie'])
        : null;
    electricityBill = json['electricity_bill'] != null
        ? new BankStatement.fromJson(json['electricity_bill'])
        : null;
    landlineBill = json['landline_bill'] != null
        ? new BankStatement.fromJson(json['landline_bill'])
        : null;
    gasBill = json['gas_bill'] != null
        ? new BankStatement.fromJson(json['gas_bill'])
        : null;
    waterBill = json['water_bill'] != null
        ? new BankStatement.fromJson(json['water_bill'])
        : null;
    creditCardStatement = json['credit_card_statement'] != null
        ? new BankStatement.fromJson(json['credit_card_statement'])
        : null;
    rentAgreement = json['rent_agreement'] != null
        ? new BankStatement.fromJson(json['rent_agreement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bankStatement != null) {
      data['bank_statement'] = this.bankStatement!.toJson();
    }
    if (this.paySlip != null) {
      data['pay_slip'] = this.paySlip!.toJson();
    }
    if (this.aadhaarFront != null) {
      data['aadhaar_front'] = this.aadhaarFront!.toJson();
    }
    if (this.aadhaarBack != null) {
      data['aadhaar_back'] = this.aadhaarBack!.toJson();
    }
    if (this.pancard != null) {
      data['pancard'] = this.pancard!.toJson();
    }
    if (this.selfie != null) {
      data['selfie'] = this.selfie!.toJson();
    }
    if (this.electricityBill != null) {
      data['electricity_bill'] = this.electricityBill!.toJson();
    }
    if (this.landlineBill != null) {
      data['landline_bill'] = this.landlineBill!.toJson();
    }
    if (this.gasBill != null) {
      data['gas_bill'] = this.gasBill!.toJson();
    }
    if (this.waterBill != null) {
      data['water_bill'] = this.waterBill!.toJson();
    }
    if (this.creditCardStatement != null) {
      data['credit_card_statement'] = this.creditCardStatement!.toJson();
    }
    if (this.rentAgreement != null) {
      data['rent_agreement'] = this.rentAgreement!.toJson();
    }
    return data;
  }
}

class BankStatement {
  int? required;
  int? uploaded;
  String? fileName;
  String? fileExtAllowed;

  BankStatement(
      {this.required, this.uploaded, this.fileName, this.fileExtAllowed});

  BankStatement.fromJson(Map<String, dynamic> json) {
    required = json['required'];
    uploaded = json['uploaded'];
    fileName = json['file_name'];
    fileExtAllowed = json['file_ext_allowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['required'] = this.required;
    data['uploaded'] = this.uploaded;
    data['file_name'] = this.fileName;
    data['file_ext_allowed'] = this.fileExtAllowed;
    return data;
  }
}

class ApplicationStatus {
  int? applicationSubmitted;
  int? applicationInReview;
  int? sanction;
  int? esign;
  int? disbursement;

  ApplicationStatus(
      {this.applicationSubmitted,
        this.applicationInReview,
        this.sanction,
        this.esign,
        this.disbursement});

  ApplicationStatus.fromJson(Map<String, dynamic> json) {
    applicationSubmitted = json['application_submitted'];
    applicationInReview = json['application_in_review'];
    sanction = json['sanction'];
    esign = json['esign'];
    disbursement = json['disbursement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['application_submitted'] = this.applicationSubmitted;
    data['application_in_review'] = this.applicationInReview;
    data['sanction'] = this.sanction;
    data['esign'] = this.esign;
    data['disbursement'] = this.disbursement;
    return data;
  }
}

class LoanDetails {
  String? loanAmount;
  String? roi;
  String? penalRoi;
  String? sanctionDate;
  String? repaymentAmount;
  String? repaymentDate;
  String? tenure;
  String? adminProcessingFee;

  LoanDetails(
      {this.loanAmount,
        this.roi,
        this.penalRoi,
        this.sanctionDate,
        this.repaymentAmount,
        this.repaymentDate,
        this.tenure,
        this.adminProcessingFee});

  LoanDetails.fromJson(Map<String, dynamic> json) {
    loanAmount = json['loan_amount'];
    roi = json['roi'];
    penalRoi = json['penal_roi'];
    sanctionDate = json['sanction_date'];
    repaymentAmount = json['repayment_amount'];
    repaymentDate = json['repayment_date'];
    tenure = json['tenure'];
    adminProcessingFee = json['admin_processing_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loan_amount'] = this.loanAmount;
    data['roi'] = this.roi;
    data['penal_roi'] = this.penalRoi;
    data['sanction_date'] = this.sanctionDate;
    data['repayment_amount'] = this.repaymentAmount;
    data['repayment_date'] = this.repaymentDate;
    data['tenure'] = this.tenure;
    data['admin_processing_fee'] = this.adminProcessingFee;
    return data;
  }
}
