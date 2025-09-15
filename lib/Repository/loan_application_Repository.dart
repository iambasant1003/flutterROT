
import 'package:dio/dio.dart';
import '../Constant/ApiUrlConstant/ApiUrlConstant.dart';
import '../Constant/ConstText/ConstText.dart';
import '../Model/AddReferenceModel.dart';
import '../Model/BankAccountTypeModel.dart';
import '../Model/CalculateDistanceResponseModel.dart';
import '../Model/CheckBankStatementStatusModel.dart';
import '../Model/CreateLeadModel.dart';
import '../Model/CustomerKycModel.dart';
import '../Model/EkycVerifictionModel.dart';
import '../Model/GenerateLoanOfferModel.dart';
import '../Model/GetCustomerDetailsModel.dart';
import '../Model/GetLeadIdResponseModel.dart';
import '../Model/GetLoanHistoryModel.dart';
import '../Model/GetPinCodeDetailsModel.dart';
import '../Model/GetPurposeOfLoanModel.dart';
import '../Model/GetUtilityDocTypeModel.dart';
import '../Model/IfscCodeModel.dart';
import '../Model/LoanAcceptanceModel.dart';
import '../Model/UpdateBankAccountModel.dart';
import '../Model/UploadBankStatementModel.dart';
import '../Model/UploadOnlineBankStatementModel.dart';
import '../Model/UploadSelfieModel.dart';
import '../Model/UploadUtilityDocTypeModel.dart';
import '../Model/VerifyBankStatementModel.dart';
import '../Services/ApiResponseStatus.dart';
import '../Services/http_client.dart';
import '../Services/http_client_php.dart';
import '../Utils/Debugprint.dart';

class LoanApplicationRepository {
  final ApiClass apiClass;
  final ApiClassPhp apiClassPhp;
  LoanApplicationRepository(this.apiClass,this.apiClassPhp);


  ApiResponseStatus mapApiResponseStatus(dynamic responseBody) {
    final Map<String, dynamic> decoded = responseBody;

    final int? logicalStatusCode = decoded['statusCode'];

    if (logicalStatusCode == null) {
      // Fallback: if no logical status code found, treat as failure
      return ApiResponseStatus.notFound;
    }

    return mapStatusCode(logicalStatusCode);
  }

  ApiResponseStatus mapApiResponseStatusPhp(dynamic responseBody) {
    final Map<String, dynamic> decoded = responseBody;

    final int? logicalStatusCode = decoded['Status'];
    DebugPrint.prt("Token Getting ${logicalStatusCode.runtimeType}");

    if (logicalStatusCode == null) {
      // Fallback: if no logical status code found, treat as failure
      return ApiResponseStatus.notFound;
    }

    return mapStatusCodePhp(logicalStatusCode);
  }


  Future<ApiResponse<CreateLeadModel>> checkEligibilityFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(checkEligibility, dataObj, isHeader: true);
      DebugPrint.prt("API Response AreaWise Data ${response.data}");

      final Map<String, dynamic> responseData = response.data;

      final int statusCode = responseData['statusCode'] ?? 500;
      final ApiResponseStatus status = mapStatusCode(statusCode);

      if (status == ApiResponseStatus.success) {
        final data = CreateLeadModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = CreateLeadModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in checkEligibilityFunction: $e");
      final error = CreateLeadModel(
        statusCode: 500,
        message: ConstText.exceptionError,
        success: false,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }


  Future<ApiResponse<GetPinCodeDetailsModel>> getPinCodeDetailsFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClassPhp.post(getPinCodeDetails,dataObj, isHeader: true);
      DebugPrint.prt("API Response PinCode Data ${response.data}");
      final ApiResponseStatus status = mapApiResponseStatusPhp(response.data);
      DebugPrint.prt("ApI Response after statusCode $status");
      final Map<String, dynamic> responseData = response.data;
      DebugPrint.prt("ApI Response after parsing $responseData");
      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("Data In Success PinCode $status");
        final data = GetPinCodeDetailsModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = GetPinCodeDetailsModel.fromJson(responseData);
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      throw e.toString();
    }
  }


  Future<ApiResponse<UploadSelfieModel>> uploadSelfieFunction(FormData dataObj) async{
    try {
      final response = await apiClass.post(uploadSelfie, dataObj, isHeader: true,isMultipart: true);
      DebugPrint.prt("API Response Upload Selfie Data ${response.data}");

      final Map<String, dynamic> responseData = response.data;

      final int statusCode = responseData['statusCode'] ?? 500;
      final ApiResponseStatus status = mapStatusCode(statusCode);

      if (status == ApiResponseStatus.success) {
        final data = UploadSelfieModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = UploadSelfieModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Upload Selfie: $e");
      final error = UploadSelfieModel(
        statusCode: 500,
        message: ConstText.exceptionError,
        success: false,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<GetCustomerDetailsModel>> getCustomerDetailsFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClassPhp.post(getCustomerDetailsPHP, dataObj, isHeader: true);
      DebugPrint.prt("API Response GetCustomer Details Data ${response.data}");

      final Map<String, dynamic> responseData = response.data;

      final int statusCode = responseData['Status'] ?? 500;
      final ApiResponseStatus status = mapStatusCodePhp(statusCode);

      if (status == ApiResponseStatus.success) {
        final data = GetCustomerDetailsModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = GetCustomerDetailsModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.status}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in get Customer Details: $e");
      final error = GetCustomerDetailsModel(
        status: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }


  Future<ApiResponse<GetLeadIdResponseModel>> getLeadIdFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(getLeadId, dataObj, isHeader: true);
      DebugPrint.prt("API Response Lead Id Data ${response.data}");

      final Map<String, dynamic> responseData = response.data;

      final int statusCode = responseData['statusCode'] ?? 500;
      final ApiResponseStatus status = mapStatusCode(statusCode);

      if (status == ApiResponseStatus.success) {
        final data = GetLeadIdResponseModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = GetLeadIdResponseModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in get Lead Id: $e");
      final error = GetLeadIdResponseModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<CustomerKycModel>> customerKYCFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(customerKyc, dataObj, isHeader: true);
      DebugPrint.prt("API Response Customer KYC data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        final data = CustomerKycModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = CustomerKycModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in get Customer Details: $e");
      final error = CustomerKycModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }


  Future<ApiResponse<EkycVerificationModel>> customerKYCVerificationFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.put(customerKycVerification, dataObj, isHeader: true);
      DebugPrint.prt("API Response Customer KYC data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        final data = EkycVerificationModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = EkycVerificationModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in get Customer Details: $e");
      final error = EkycVerificationModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<GenerateLoanOfferModel>> generateLoanOfferApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(generateLoanOffer, dataObj, isHeader: true);
      DebugPrint.prt("API Response Generate Loan Offer data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        final data = GenerateLoanOfferModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = GenerateLoanOfferModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in get Customer Details: $e");
      final error = GenerateLoanOfferModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<LoanAcceptanceModel>> loanAcceptanceApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.put(loanAcceptance, dataObj, isHeader: true);
      DebugPrint.prt("API Response Loan Acceptance data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        final data = LoanAcceptanceModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = LoanAcceptanceModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in accept Loan Offer: $e");
      final error = LoanAcceptanceModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }


  Future<ApiResponse<GetPurposeOfLoanModel>> getPurposeOfLoanApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClassPhp.post(loanPurpose, {},isHeader: true);
      DebugPrint.prt("API Response Purpose of Loan data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatusPhp(responseData);

      if (status == ApiResponseStatus.success) {
        final data = GetPurposeOfLoanModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = GetPurposeOfLoanModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.status}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in accept Loan Offer: $e");
      final error = GetPurposeOfLoanModel(
        status: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<GetUtilityDocTypeModel>> getUtilityTyeApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(getUtilityDoc,dataObj,isHeader: true);
      DebugPrint.prt("API Response Utility Type data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        final data = GetUtilityDocTypeModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = GetUtilityDocTypeModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in accept Loan Offer: $e");
      final error = GetUtilityDocTypeModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }


  Future<ApiResponse<UploadUtilityDocTypeModel>> uploadUtilityTypeDocApiCallFunction(FormData dataObj) async{
    try {
      final response = await apiClass.post(uploadResidenceDoc,dataObj,isHeader: true,isMultipart: true);
      DebugPrint.prt("API Response Upload Utility data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("Utility Doc Success Response Model $responseData}");
        final data = UploadUtilityDocTypeModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = UploadUtilityDocTypeModel.fromJson(responseData);
        DebugPrint.prt("Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Upload Utility Doc : $e");
      final error = UploadUtilityDocTypeModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<UploadBankStatementModel>> uploadBankStatementApiCallFunction(FormData dataObj) async{
    try {
      final response = await apiClass.post(uploadBankStatement,dataObj,isHeader: true,isMultipart: true);
      DebugPrint.prt("API Response Upload BankStatement data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("BankStatement Success Response Model $responseData}");
        final data = UploadBankStatementModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = UploadBankStatementModel.fromJson(responseData);
        DebugPrint.prt("BankStatement Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Upload BankStatement : $e");
      final error = UploadBankStatementModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<AddReferenceModel>> addReferenceApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(addReFeRance,dataObj,isHeader: true);
      DebugPrint.prt("API Response Add Reference data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("BankStatement Success Response Model $responseData}");
        final data = AddReferenceModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = AddReferenceModel.fromJson(responseData);
        //DebugPrint.prt("BankStatement Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Add Reference : $e");
      final error = AddReferenceModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<UpdateBankAccountModel>> updateBankingDetailsApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(updateBankingDetails,dataObj,isHeader: true);
      DebugPrint.prt("API Response Update Banking data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("Update Bank Details Success Response Model $responseData}");
        final data = UpdateBankAccountModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = UpdateBankAccountModel.fromJson(responseData);
        DebugPrint.prt("Bank Details Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Update Banking data : $e");
      final error = UpdateBankAccountModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<IfscCodeModel>> verifyIfscCodeApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClassPhp.post(verifyIfscCode,dataObj,isHeader: true);
      DebugPrint.prt("API Response Verify Ifsc Code data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatusPhp(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("Verify Ifsc Code Success Response Model $responseData}");
        final data = IfscCodeModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = IfscCodeModel.fromJson(responseData);
        DebugPrint.prt("Verify Ifsc Error Message ${error.message}, ${error.status}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Verify Ifsc Code data : $e");
      final error = IfscCodeModel(
        status: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }


  Future<ApiResponse<BankAccountTypeModel>> bankAccountTypeApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClassPhp.post(bankAccountType,dataObj,isHeader: true);
      DebugPrint.prt("API Response bank Account Type data ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatusPhp(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("Bank Account Type Success Response Model $responseData}");
        final data = BankAccountTypeModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = BankAccountTypeModel.fromJson(responseData);
        DebugPrint.prt("Bank Account Type Error Message ${error.message}, ${error.status}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Bank Account Type data : $e");
      final error = BankAccountTypeModel(
        status: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<UploadOnlineBankStatementModel>> fetchAccountAggregatorApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(uploadOnlineBankStatement,dataObj,isHeader: true);
      DebugPrint.prt("API Response Account Aggregator ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("Account Aggregator Success Response Model $responseData}");
        final data =UploadOnlineBankStatementModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = UploadOnlineBankStatementModel.fromJson(responseData);
        DebugPrint.prt("Account Aggregator Type Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Account Aggregator data : $e");
      final error = UploadOnlineBankStatementModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<CheckBankStatementStatusModel>> checkBankStatementStatusApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.put(checkBankStatementStatus,dataObj,isHeader: true);
      DebugPrint.prt("API Response Check BankStatement Status ${response.data}");

      final Map<String, dynamic> responseData = response.data;

      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("Check Bank Account Status Success Response Model $responseData}");
        final data =CheckBankStatementStatusModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = CheckBankStatementStatusModel.fromJson(responseData);
        DebugPrint.prt("Check Bank Account Status Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Bank Account Status data : $e");
      final error = CheckBankStatementStatusModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }


  Future<ApiResponse<GetLoanHistoryModel>> getLoanHistoryApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(getLoanHistory,dataObj,isHeader: true);
      DebugPrint.prt("API Response Get Loan History ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("Get Loan History Success Response Model $responseData}");
        final data =GetLoanHistoryModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = GetLoanHistoryModel.fromJson(responseData);
        DebugPrint.prt("Get Loan History Type Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Get Loan History data : $e");
      final error = GetLoanHistoryModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<CalculateDistanceResponseModel>> calculateDistanceApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(calculateDistance,dataObj,isHeader: true);
      DebugPrint.prt("API Response Calculate Distance ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("Calculate Distance Success Response Model $responseData}");
        final data =CalculateDistanceResponseModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = CalculateDistanceResponseModel.fromJson(responseData);
        DebugPrint.prt("Calculate Distance Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in Calculate Distance data : $e");
      final error = CalculateDistanceResponseModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

  Future<ApiResponse<VerifyBankStatementModel>> verifyBankStatementApiCallFunction(Map<String,dynamic> dataObj) async{
    try {
      final response = await apiClass.post(bankStatementVerification,dataObj,isHeader: true);
      DebugPrint.prt("API Response verify Bank Statement ${response.data}");

      final Map<String, dynamic> responseData = response.data;


      final ApiResponseStatus status = mapApiResponseStatus(responseData);

      if (status == ApiResponseStatus.success) {
        DebugPrint.prt("verify Bank Statement Success Response Model $responseData}");
        final data =VerifyBankStatementModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = VerifyBankStatementModel.fromJson(responseData);
        DebugPrint.prt("verify Bank Statement Error Message ${error.message}, ${error.statusCode}");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Exception in verify Bank Statement data : $e");
      final error = VerifyBankStatementModel(
        statusCode: 500,
        message: ConstText.exceptionError,
      );
      return ApiResponse.error(ApiResponseStatus.serverError, error: error);
    }
  }

}

