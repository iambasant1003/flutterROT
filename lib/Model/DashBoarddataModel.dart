class DashBoarddataModel {
  int? status;
  String? message;
  Data? data;

  DashBoarddataModel({this.status, this.message, this.data});

  DashBoarddataModel.fromJson(Map<String, dynamic> json) {
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
  List<AppBanners>? appBanners;
  String? leftSidePanel;
  String? mobile;
  String? fullName;
  int? profileFilledPercent;
  String? profilePic;
  int? registrationSuccessful;
  ApplyLoanBanner? applyLoanBanner;
  int? profileEditFlag;
  ActiveLoanDetails? activeLoanDetails;
  int? showLoanHistoryBtnFlag;
  int? applicationSubmitted;
  int? applicationFilledPercent;
  int? journeyWhitelistedFlag;
  ExecutiveContact? executiveContact;
  String? journeyVideoUrl;
  String? warningMessage;
  String? contactUsNumber;
  String? contactUsWhatsappNumber;
  String? contactUsEmail;
  bool? isAccountDeleteVisibility;

  Data(
      {this.appBanners,
        this.leftSidePanel,
        this.mobile,
        this.fullName,
        this.profileFilledPercent,
        this.profilePic,
        this.registrationSuccessful,
        this.applyLoanBanner,
        this.profileEditFlag,
        this.activeLoanDetails,
        this.showLoanHistoryBtnFlag,
        this.applicationSubmitted,
        this.applicationFilledPercent,
        this.journeyWhitelistedFlag,
        this.executiveContact,
        this.journeyVideoUrl,
        this.warningMessage,
        this.contactUsNumber,
        this.contactUsWhatsappNumber,
        this.isAccountDeleteVisibility,
        this.contactUsEmail});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['app_banners'] != null) {
      appBanners = <AppBanners>[];
      json['app_banners'].forEach((v) {
        appBanners!.add(new AppBanners.fromJson(v));
      });
    }
    leftSidePanel = json['left_side_panel'];
    mobile = json['mobile'];
    fullName = json['full_name'];
    profileFilledPercent = json['profile_filled_percent'];
    profilePic = json['profile_pic'];
    registrationSuccessful = json['registration_successful'];
    applyLoanBanner = json['apply_loan_banner'] != null
        ? new ApplyLoanBanner.fromJson(json['apply_loan_banner'])
        : null;
    profileEditFlag = json['profile_edit_flag'];
    activeLoanDetails = json['active_loan_details'] != null
        ? new ActiveLoanDetails.fromJson(json['active_loan_details'])
        : null;
    showLoanHistoryBtnFlag = json['show_loan_history_btn_flag'];
    applicationSubmitted = json['application_submitted'];
    applicationFilledPercent = json['application_filled_percent'];
    journeyWhitelistedFlag = json['journey_whitelisted_flag'];
    executiveContact = json['executive_contact'] != null
        ? new ExecutiveContact.fromJson(json['executive_contact'])
        : null;
    journeyVideoUrl = json['journey_video_url'];
    warningMessage = json['warning_message'];
    contactUsNumber = json['contact_us_number'];
    contactUsWhatsappNumber = json['contact_us_whatsapp_number'];
    contactUsEmail = json['contact_us_email'];
    isAccountDeleteVisibility = json['is_account_delete_visibility'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appBanners != null) {
      data['app_banners'] = this.appBanners!.map((v) => v.toJson()).toList();
    }
    data['left_side_panel'] = this.leftSidePanel;
    data['mobile'] = this.mobile;
    data['full_name'] = this.fullName;
    data['profile_filled_percent'] = this.profileFilledPercent;
    data['profile_pic'] = this.profilePic;
    data['registration_successful'] = this.registrationSuccessful;
    if (this.applyLoanBanner != null) {
      data['apply_loan_banner'] = this.applyLoanBanner!.toJson();
    }
    data['profile_edit_flag'] = this.profileEditFlag;
    if (this.activeLoanDetails != null) {
      data['active_loan_details'] = this.activeLoanDetails!.toJson();
    }
    data['show_loan_history_btn_flag'] = this.showLoanHistoryBtnFlag;
    data['application_submitted'] = this.applicationSubmitted;
    data['application_filled_percent'] = this.applicationFilledPercent;
    data['journey_whitelisted_flag'] = this.journeyWhitelistedFlag;
    if (this.executiveContact != null) {
      data['executive_contact'] = this.executiveContact!.toJson();
    }
    data['journey_video_url'] = this.journeyVideoUrl;
    data['warning_message'] = this.warningMessage;
    data['contact_us_number'] = this.contactUsNumber;
    data['contact_us_whatsapp_number'] = this.contactUsWhatsappNumber;
    data['contact_us_email'] = this.contactUsEmail;
    data['is_account_delete_visibility'] = this.isAccountDeleteVisibility;
    return data;
  }
}

class AppBanners {
  int? id;
  String? imgUrl;
  String? redirectUrl;

  AppBanners({this.id, this.imgUrl, this.redirectUrl});

  AppBanners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgUrl = json['imgUrl'];
    redirectUrl = json['redirectUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imgUrl'] = this.imgUrl;
    data['redirectUrl'] = this.redirectUrl;
    return data;
  }
}

class ApplyLoanBanner {
  int? appBannerProgressPercent;
  String? appBannerTitle;
  String? appBannerText;
  String? appBannerBtnText;
  int? appBannerBtnActiveFlag;
  int? appBannerBtnGotoFlag;

  ApplyLoanBanner(
      {this.appBannerProgressPercent,
        this.appBannerTitle,
        this.appBannerText,
        this.appBannerBtnText,
        this.appBannerBtnActiveFlag,
        this.appBannerBtnGotoFlag});

  ApplyLoanBanner.fromJson(Map<String, dynamic> json) {
    appBannerProgressPercent = json['app_banner_progress_percent'];
    appBannerTitle = json['app_banner_title'];
    appBannerText = json['app_banner_text'];
    appBannerBtnText = json['app_banner_btn_text'];
    appBannerBtnActiveFlag = json['app_banner_btn_active_flag'];
    appBannerBtnGotoFlag = json['app_banner_btn_goto_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_banner_progress_percent'] = this.appBannerProgressPercent;
    data['app_banner_title'] = this.appBannerTitle;
    data['app_banner_text'] = this.appBannerText;
    data['app_banner_btn_text'] = this.appBannerBtnText;
    data['app_banner_btn_active_flag'] = this.appBannerBtnActiveFlag;
    data['app_banner_btn_goto_flag'] = this.appBannerBtnGotoFlag;
    return data;
  }
}

class ActiveLoanDetails {
  String? loanNo;
  int? repaymentAmount;
  String? repaymentDate;
  int? remainingDays;
  int? totalDue;

  ActiveLoanDetails(
      {this.loanNo,
        this.repaymentAmount,
        this.repaymentDate,
        this.remainingDays,
        this.totalDue});

  ActiveLoanDetails.fromJson(Map<String, dynamic> json) {
    loanNo = json['loan_no'];
    repaymentAmount = json['repayment_amount'];
    repaymentDate = json['repayment_date'];
    remainingDays = json['remaining_days'];
    totalDue = json['total_due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loan_no'] = this.loanNo;
    data['repayment_amount'] = this.repaymentAmount;
    data['repayment_date'] = this.repaymentDate;
    data['remaining_days'] = this.remainingDays;
    data['total_due'] = this.totalDue;
    return data;
  }
}

class ExecutiveContact {
  int? executiveContactFlag;
  String? executiveContactHeader;
  String? executiveContactTitle;
  String? executiveContactName;
  String? executiveContactEmail;
  String? executiveContactMobile;
  String? executiveContactImage;

  ExecutiveContact(
      {this.executiveContactFlag,
        this.executiveContactHeader,
        this.executiveContactTitle,
        this.executiveContactName,
        this.executiveContactEmail,
        this.executiveContactMobile,
        this.executiveContactImage});

  ExecutiveContact.fromJson(Map<String, dynamic> json) {
    executiveContactFlag = json['executive_contact_flag'];
    executiveContactHeader = json['executive_contact_header'];
    executiveContactTitle = json['executive_contact_title'];
    executiveContactName = json['executive_contact_name'];
    executiveContactEmail = json['executive_contact_email'];
    executiveContactMobile = json['executive_contact_mobile'];
    executiveContactImage = json['executive_contact_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['executive_contact_flag'] = this.executiveContactFlag;
    data['executive_contact_header'] = this.executiveContactHeader;
    data['executive_contact_title'] = this.executiveContactTitle;
    data['executive_contact_name'] = this.executiveContactName;
    data['executive_contact_email'] = this.executiveContactEmail;
    data['executive_contact_mobile'] = this.executiveContactMobile;
    data['executive_contact_image'] = this.executiveContactImage;
    return data;
  }
}
