


import '../../Model/AddReferenceModel.dart';
import '../../Model/BankAccountTypeModel.dart';
import '../../Model/CalculateDistanceResponseModel.dart';
import '../../Model/CheckBankStatementStatusModel.dart';
import '../../Model/CreateLeadModel.dart';
import '../../Model/CustomerKycModel.dart';
import '../../Model/EkycVerifictionModel.dart';
import '../../Model/GenerateLoanOfferModel.dart';
import '../../Model/GetCustomerDetailsModel.dart';
import '../../Model/GetLeadIdResponseModel.dart';
import '../../Model/GetLoanHistoryModel.dart';
import '../../Model/GetPinCodeDetailsModel.dart';
import '../../Model/GetPurposeOfLoanModel.dart';
import '../../Model/GetUtilityDocTypeModel.dart';
import '../../Model/IfscCodeModel.dart';
import '../../Model/LoanAcceptanceModel.dart';
import '../../Model/UpdateBankAccountModel.dart';
import '../../Model/UploadBankStatementModel.dart';
import '../../Model/UploadOnlineBankStatementModel.dart';
import '../../Model/UploadSelfieModel.dart';
import '../../Model/UploadUtilityDocTypeModel.dart';
import '../../Model/VerifyBankStatementModel.dart';

abstract class LoanApplicationState {}

class LoanApplicationInitial extends LoanApplicationState {}

class LoanApplicationLoading extends LoanApplicationState {}


class LoanApplicationLoaded extends LoanApplicationState {
  final UploadSelfieModel data;
  LoanApplicationLoaded(this.data);
}

class LoanApplicationError extends LoanApplicationState {
  final String message;
  LoanApplicationError(this.message);
}


class CreateLeadSuccess extends LoanApplicationState{
  final CreateLeadModel createLeadModel;
  CreateLeadSuccess(this.createLeadModel);
}

class CreateLeadError extends LoanApplicationState{
  final CreateLeadModel createLeadModel;
  CreateLeadError(this.createLeadModel);
}

class GetPinCodeDetailsSuccess extends LoanApplicationState{
  final GetPinCodeDetailsModel pinCodeDetailsModel;
  GetPinCodeDetailsSuccess(this.pinCodeDetailsModel);
}

class GetPinCodeDetailsError extends LoanApplicationState{
  final String pinCodeDetailsModel;
  GetPinCodeDetailsError(this.pinCodeDetailsModel);
}

class UploadSelfieSuccess extends LoanApplicationState{
  final UploadSelfieModel uploadSelfieModel;
  UploadSelfieSuccess(this.uploadSelfieModel);
}

class UploadSelfieError extends LoanApplicationState{
  final UploadSelfieModel uploadSelfieModel;
  UploadSelfieError(this.uploadSelfieModel);
}

class GetCustomerDetailsSuccess extends LoanApplicationState{
  final GetCustomerDetailsModel getCustomerDetailsModel;
  GetCustomerDetailsSuccess(this.getCustomerDetailsModel);
}

class GetLeadIdSuccess extends LoanApplicationState{
  final GetLeadIdResponseModel getLeadIdResponseModel;
  GetLeadIdSuccess(this.getLeadIdResponseModel);
}

class GetLeadIdError extends LoanApplicationState{
  final GetLeadIdResponseModel getLeadIdResponseModel;
  GetLeadIdError(this.getLeadIdResponseModel);
}

class GetCustomerDetailsError extends LoanApplicationState{
  final GetCustomerDetailsModel getCustomerDetailsModel;
  GetCustomerDetailsError(this.getCustomerDetailsModel);
}

class CustomerKYCSuccess extends LoanApplicationState{
  final CustomerKycModel customerKycModel;
  CustomerKYCSuccess(this.customerKycModel);
}

class CustomerKYCError extends LoanApplicationState{
  final CustomerKycModel customerKycModel;
  CustomerKYCError(this.customerKycModel);
}

class CustomerKYCVerificationSuccess extends LoanApplicationState{
  final EkycVerificationModel ekycVerificationModel;
  CustomerKYCVerificationSuccess(this.ekycVerificationModel);
}

class CustomerKYCVerificationError extends LoanApplicationState{
  final EkycVerificationModel ekycVerificationModel;
  CustomerKYCVerificationError(this.ekycVerificationModel);
}

class GenerateLoanOfferSuccess extends LoanApplicationState{
  GenerateLoanOfferModel? generateLoanOfferModel;
  GetPurposeOfLoanModel? getPurposeOfLoanModel;
  GenerateLoanOfferSuccess(this.generateLoanOfferModel,this.getPurposeOfLoanModel);
}

class GetPurposeOfLoanSuccess extends LoanApplicationState{
  final GetPurposeOfLoanModel getPurposeOfLoanModel;
  GetPurposeOfLoanSuccess(this.getPurposeOfLoanModel);
}

class GetPurposeOfLoanFailed extends LoanApplicationState{
  final GetPurposeOfLoanModel getPurposeOfLoanModel;
  GetPurposeOfLoanFailed(this.getPurposeOfLoanModel);
}

class GenerateLoanOfferError extends LoanApplicationState{
  final GenerateLoanOfferModel generateLoanOfferModel;
  GenerateLoanOfferError(this.generateLoanOfferModel);
}

class LoanAcceptanceLoading extends LoanApplicationState{}

class LoanAcceptanceSuccess extends LoanApplicationState{
 final LoanAcceptanceModel loanAcceptanceModel;
 LoanAcceptanceSuccess(this.loanAcceptanceModel);
}

class LoanAcceptanceError extends LoanApplicationState{
  final LoanAcceptanceModel loanAcceptanceModel;
  LoanAcceptanceError(this.loanAcceptanceModel);
}

class GetUtilityDocTypeLoaded extends LoanApplicationState{
  final GetUtilityDocTypeModel getUtilityDocTypeModel;
  GetUtilityDocTypeLoaded(this.getUtilityDocTypeModel);
}

class UploadUtilityDocSuccess extends LoanApplicationState{
  final UploadUtilityDocTypeModel uploadUtilityDocTypeModel;
  UploadUtilityDocSuccess(this.uploadUtilityDocTypeModel);
}

class UploadUtilityDocError extends LoanApplicationState{
  final String errorMessage;
  UploadUtilityDocError(this.errorMessage);
}

class UploadBankStatementSuccess extends LoanApplicationState{
  final UploadBankStatementModel uploadBankStatementModel;
  UploadBankStatementSuccess(this.uploadBankStatementModel);
}

class UploadBankStatementFailed extends LoanApplicationState{
  final UploadBankStatementModel uploadBankStatementModel;
  UploadBankStatementFailed(this.uploadBankStatementModel);
}

class AddReferenceSuccess extends LoanApplicationState{
  final AddReferenceModel addReferenceModel;
  AddReferenceSuccess(this.addReferenceModel);
}

class AddReferenceFailed extends LoanApplicationState{
  final AddReferenceModel addReferenceModel;
  AddReferenceFailed(this.addReferenceModel);
}

class UpdateBankDetailsSuccess extends LoanApplicationState{
  final UpdateBankAccountModel updateBankAccountModel;
  UpdateBankDetailsSuccess(this.updateBankAccountModel);
}

class UpdateBankDetailsFailed extends LoanApplicationState{
  final UpdateBankAccountModel updateBankAccountModel;
  UpdateBankDetailsFailed(this.updateBankAccountModel);
}

class VerifyIfscCodeSuccess extends LoanApplicationState{
  final IfscCodeModel ifscCodeModel;
  VerifyIfscCodeSuccess(this.ifscCodeModel);
}

class VerifyIfscCodeFailed extends LoanApplicationState{
  final IfscCodeModel ifscCodeModel;
  VerifyIfscCodeFailed(this.ifscCodeModel);
}

class BankAccountTypeSuccess extends LoanApplicationState{
  final BankAccountTypeModel bankAccountTypeModel;
  BankAccountTypeSuccess(this.bankAccountTypeModel);
}

class BankAccountTypeFailed extends LoanApplicationState{
  final BankAccountTypeModel bankAccountTypeModel;
  BankAccountTypeFailed(this.bankAccountTypeModel);
}

class OnlineAccountAggregatorSuccess extends LoanApplicationState{
  final UploadOnlineBankStatementModel uploadOnlineBankStatementModel;
  OnlineAccountAggregatorSuccess(this.uploadOnlineBankStatementModel);
}

class OnlineAccountAggregatorFailed extends LoanApplicationState{
  final UploadOnlineBankStatementModel uploadOnlineBankStatementModel;
  OnlineAccountAggregatorFailed(this.uploadOnlineBankStatementModel);
}

class CheckBankStatementStatusSuccess extends LoanApplicationState{
  final CheckBankStatementStatusModel checkBankStatementStatusModel;
  CheckBankStatementStatusSuccess(this.checkBankStatementStatusModel);
}

class CheckBankStatementStatusFailed extends LoanApplicationState{
  final CheckBankStatementStatusModel checkBankStatementStatusModel;
  CheckBankStatementStatusFailed(this.checkBankStatementStatusModel);
}

class GetLoanHistorySuccess extends LoanApplicationState{
  final GetLoanHistoryModel getLoanHistoryModel;
  GetLoanHistorySuccess(this.getLoanHistoryModel);
}

class GetLoanHistoryFailed extends LoanApplicationState{
  final GetLoanHistoryModel getLoanHistoryModel;
  GetLoanHistoryFailed(this.getLoanHistoryModel);
}

class CalculateDistanceSuccess extends LoanApplicationState{
  final CalculateDistanceResponseModel calculateDistanceResponseModel;
  CalculateDistanceSuccess(this.calculateDistanceResponseModel);
}

class CalculateDistanceFailed extends LoanApplicationState{
  final CalculateDistanceResponseModel calculateDistanceResponseModel;
  CalculateDistanceFailed(this.calculateDistanceResponseModel);
}

class VerifyBankStatementSuccess extends LoanApplicationState{
  final VerifyBankStatementModel verifyBankStatementModel;
  VerifyBankStatementSuccess(this.verifyBankStatementModel);
}

class VerifyBankStatementFailed extends LoanApplicationState{
  final VerifyBankStatementModel verifyBankStatementModel;
  VerifyBankStatementFailed(this.verifyBankStatementModel);
}




