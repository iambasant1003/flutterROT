

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan112_app/Cubit/safe_emit.dart';
import '../../Model/GenerateLoanOfferModel.dart';
import '../../Model/GetPurposeOfLoanModel.dart';
import '../../Model/VerifyOTPModel.dart';
import '../../Repository/loan_application_Repository.dart';
import '../../Services/ApiResponseStatus.dart';
import '../../Utils/Debugprint.dart';
import '../../Utils/MysharePrefenceClass.dart';
import 'LoanApplicationState.dart';

class LoanApplicationCubit extends Cubit<LoanApplicationState> {
  final LoanApplicationRepository loanApplicationRepository;

  LoanApplicationCubit(this.loanApplicationRepository) : super(LoanApplicationInitial());




  Future<void> checkEligibilityApiCall(Map<String,dynamic> dataObj) async {
    DebugPrint.prt("Data Object Check Eligibility $dataObj");
    safeEmit(()=>emit(LoanApplicationLoading()));
    final response = await loanApplicationRepository.checkEligibilityFunction(dataObj);
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>emit(CreateLeadSuccess(response.data!)));
    } else {
      safeEmit(()=>emit(CreateLeadError(response.error!)));
    }
  }

  Future<void> getPinCodeDetailsApiCall(Map<String,dynamic> dataObj) async {

    safeEmit(()=>emit(LoanApplicationLoading()));
    try {
      final response = await loanApplicationRepository.getPinCodeDetailsFunction(dataObj);
      DebugPrint.prt("PinCode Status ${response.status}");
      if (response.status == ApiResponseStatus.success) {
        safeEmit(()=>emit(GetPinCodeDetailsSuccess(response.data!)));
      } else {
        safeEmit(()=>emit(GetPinCodeDetailsError(response.error?.message ?? "Please Enter valid PinCode")));
      }
    } catch (e) {
      safeEmit(()=>emit(GetPinCodeDetailsError("Please Enter valid PinCode")));
    }
  }

  Future<void> uploadSelfieApiCall(FormData dataObj) async {
    safeEmit(()=>emit(LoanApplicationLoading()));
    final response = await loanApplicationRepository.uploadSelfieFunction(dataObj);

    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(UploadSelfieSuccess(response.data!))
      );
    } else {
      safeEmit(()=>
          emit(UploadSelfieError(response.error!))
      );
    }
  }

  Future<void> getCustomerDetailsApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.getCustomerDetailsFunction(dataObj);

    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(GetCustomerDetailsSuccess(response.data!))
      );
    } else {
      safeEmit(()=>
          emit(GetCustomerDetailsError(response.error!))
      );
    }
  }


  Future<void> getLeadIdApiCall(Map<String,dynamic> dataObj) async{
    // safeEmit(()=>
    //     emit(LoanApplicationLoading())
    // );
    final response = await loanApplicationRepository.getLeadIdFunction(dataObj);

    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(GetLeadIdSuccess(response.data!))
      );
    } else {
      safeEmit(()=>
          emit(GetLeadIdError(response.error!))
      );
    }
  }




  Future<void> customerKycApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.customerKYCFunction(dataObj);
     DebugPrint.prt("KYC Api Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>emit(CustomerKYCSuccess(response.data!)));
    } else {
      safeEmit(()=>emit(CustomerKYCError(response.error!)));
    }
  }

  Future<void> customerKycVerificationApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.customerKYCVerificationFunction(dataObj);
    DebugPrint.prt("KYC Api Verification Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>emit(CustomerKYCVerificationSuccess(response.data!)));
    } else {
      safeEmit(()=> emit(CustomerKYCVerificationError(response.error!)));
    }
  }


  Future<void>  getPurposeOfLoanApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final responseList =await Future.wait([
          loanApplicationRepository.generateLoanOfferApiCallFunction(dataObj),
          loanApplicationRepository.getPurposeOfLoanApiCallFunction(dataObj)
    ]);
    DebugPrint.prt("Status Loan Offer ${responseList[0].status}, Purpose of Loan ${responseList[1].status}");
    if(responseList[0].status == ApiResponseStatus.success &&
        responseList[1].status == ApiResponseStatus.success){
      GenerateLoanOfferModel generateLoanOfferModel = GenerateLoanOfferModel.fromJson(jsonDecode(jsonEncode(responseList[0].data)));
      GetPurposeOfLoanModel getPurposeOfLoanModel = GetPurposeOfLoanModel.fromJson(jsonDecode(jsonEncode(responseList[1].data)));
      safeEmit(()=>emit(GenerateLoanOfferSuccess(generateLoanOfferModel,getPurposeOfLoanModel)));
      DebugPrint.prt("Emitted generate Loan Offer");
    }
    else{
      if(responseList[0].status != ApiResponseStatus.success){
        DebugPrint.prt("InSide Else if Block ${responseList[0].error}");
        GenerateLoanOfferModel generateLoanOfferModel = GenerateLoanOfferModel.fromJson(jsonDecode(jsonEncode(responseList[0].error)));
        safeEmit(()=>emit(GenerateLoanOfferError(generateLoanOfferModel)));
      }else if(responseList[1].status != ApiResponseStatus.success){
        DebugPrint.prt("InSide Else else Block");
        GetPurposeOfLoanModel getPurposeOfLoanModel = GetPurposeOfLoanModel.fromJson(jsonDecode(jsonEncode(responseList[1].error)));
        safeEmit(()=> emit(GetPurposeOfLoanFailed(getPurposeOfLoanModel)));
      }
    }
  }


  Future<void> loanAcceptanceApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanAcceptanceLoading())
    );
    final response = await loanApplicationRepository.loanAcceptanceApiCallFunction(dataObj);
    DebugPrint.prt("Accept Loan Offer Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=> emit(LoanAcceptanceSuccess(response.data!)));
    } else {
      safeEmit(() => emit(LoanAcceptanceError(response.error!)));
    }
  }

  Future<void> getUtilityTypeDocApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.getUtilityTyeApiCallFunction(dataObj);
    DebugPrint.prt("Get Utility Doc Type Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>emit(GetUtilityDocTypeLoaded(response.data!)));
    } else {
      safeEmit(()=> emit(LoanApplicationError(response.error?.message ?? "Unknown Error")));
    }
  }


  Future<void> uploadUtilityTypeDocApiCall(FormData dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.uploadUtilityTypeDocApiCallFunction(dataObj);
    DebugPrint.prt("Upload Utility Doc Type Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>emit(UploadUtilityDocSuccess(response.data!)));
    } else {
      safeEmit(()=> emit(UploadUtilityDocError(response.error?.message ?? "Unknown Error")));
    }
  }

  Future<void> uploadBankStatementApiCall(FormData dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.uploadBankStatementApiCallFunction(dataObj);
    DebugPrint.prt("Upload BankStatement Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>emit(UploadBankStatementSuccess(response.data!)));
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>emit(UploadBankStatementFailed(response.error!)));
    }
  }


  Future<void> addReferenceApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.addReferenceApiCallFunction(dataObj);
    DebugPrint.prt("Upload Reference Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(AddReferenceSuccess(response.data!))
      );
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>
          emit(AddReferenceFailed(response.error!))
      );
    }
  }


  Future<void> updateBankDetailsApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.updateBankingDetailsApiCallFunction(dataObj);
    DebugPrint.prt("Update Bank Details Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(UpdateBankDetailsSuccess(response.data!))
      );
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>
          emit(UpdateBankDetailsFailed(response.error!))
      );
    }
  }

  Future<void> verifyIfscCodeApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>emit(LoanApplicationLoading()));
    final response = await loanApplicationRepository.verifyIfscCodeApiCallFunction(dataObj);
    DebugPrint.prt("Verify ifsc Code Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(VerifyIfscCodeSuccess(response.data!))
      );
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>
          emit(VerifyIfscCodeFailed(response.error!))
      );
    }
  }

  Future<void> getBankAccountTypeApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.bankAccountTypeApiCallFunction(dataObj);
    DebugPrint.prt("Get Bank Account Type Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(BankAccountTypeSuccess(response.data!))
      );
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>
          emit(BankAccountTypeFailed(response.error!))
      );
    }
  }

  Future<void> fetchOnlineAccountAggregatorApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.fetchAccountAggregatorApiCallFunction(dataObj);
    DebugPrint.prt("Fetch Account Aggregator Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(OnlineAccountAggregatorSuccess(response.data!))
      );
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>
          emit(OnlineAccountAggregatorFailed(response.error!))
      );
    }
  }

  Future<void> fetchBankStatementStatusApiCall(String leadId,String customerId) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.checkBankStatementStatusApiCallFunction(
      {
        "custId":customerId,
        "leadId":leadId
      }
    );
    DebugPrint.prt("Fetch Bank Statement Status Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(CheckBankStatementStatusSuccess(response.data!))
      );
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>
          emit(CheckBankStatementStatusFailed(response.error!))
      );
    }
  }

  Future<void> getLoanHistoryApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.getLoanHistoryApiCallFunction(dataObj);
    DebugPrint.prt("Get Loan History Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(GetLoanHistorySuccess(response.data!))
      );
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>
          emit(GetLoanHistoryFailed(response.error!))
      );
    }
  }

  Future<void> calculateDistanceApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.calculateDistanceApiCallFunction(dataObj);
    DebugPrint.prt("Calculate Distance Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(CalculateDistanceSuccess(response.data!))
      );
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>
          emit(CalculateDistanceFailed(response.error!))
      );
    }
  }

  Future<void> verifyBankStatementApiCall(Map<String,dynamic> dataObj) async{
    safeEmit(()=>
        emit(LoanApplicationLoading())
    );
    final response = await loanApplicationRepository.verifyBankStatementApiCallFunction(dataObj);
    DebugPrint.prt("Verify Bank Statement Response Status ${response.status}");
    if (response.status == ApiResponseStatus.success) {
      safeEmit(()=>
          emit(VerifyBankStatementSuccess(response.data!))
      );
    } else {
      DebugPrint.prt("Inside Else Block of response");
      safeEmit(()=>
          emit(VerifyBankStatementFailed(response.error!))
      );
    }
  }

}

