
import 'package:loan112_app/Constant/ConstText/ConstText.dart';
import 'package:loan112_app/Model/CashFreePaymentInitializationResponse.dart';
import 'package:loan112_app/Model/CashFreePaymentResponseModel.dart';
import 'package:loan112_app/Model/RazorPayInitiatePaymentResponseModel.dart';
import 'package:loan112_app/Services/http_client_php.dart';
import '../Constant/ApiUrlConstant/ApiUrlConstant.dart';
import '../Model/RazorPayCheckPaymentStatusModel.dart';
import '../Model/RazorPayInitiatePaymentResponseSuccessModel.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/Debugprint.dart';

class  RepaymentRepository{
 final ApiClassPhp apiClassPhp;
 RepaymentRepository(this.apiClassPhp);

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


  Future<ApiResponse<RazorPayInitiatePaymentResponseSuccessModel>> initiateRazorpayApiCallFunction(Map<String, dynamic> data) async {
    try {
      final response = await apiClassPhp.post(initiateRazorpayPayment, data, isHeader: false);
      DebugPrint.prt("API Response Initiate RazorPay ${response.data}");
      final ApiResponseStatus status = mapApiResponseStatusPhp(response.data);
      final Map<String, dynamic> responseData = response.data;
      if (status == ApiResponseStatus.success) {
        final data = RazorPayInitiatePaymentResponseSuccessModel.fromJson(responseData);
        DebugPrint.prt("ResponseData In success $responseData");
        return ApiResponse.success(data);
      } else {
        final error = RazorPayInitiatePaymentResponseSuccessModel.fromJson(responseData);
        DebugPrint.prt("Initialization Failed $responseData");
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      DebugPrint.prt("Error  in Initialization $e");
      throw ConstText.exceptionError;
    }
  }

 Future<ApiResponse<CashFreePaymentInitializationResponse>> initiateCashFreeApiCallFunction(Map<String, dynamic> data) async {
   try {
     final response = await apiClassPhp.post(initiateCashFreePayment, data, isHeader: false);
     DebugPrint.prt("API Response Initiate CashFree ${response.data}");
     final ApiResponseStatus status = mapApiResponseStatusPhp(response.data);
     final Map<String, dynamic> responseData = response.data;
     if (status == ApiResponseStatus.success) {
       final data = CashFreePaymentInitializationResponse.fromJson(responseData);
       DebugPrint.prt("ResponseData In success $responseData");
       return ApiResponse.success(data);
     } else {
       final error = CashFreePaymentInitializationResponse.fromJson(responseData);
       DebugPrint.prt("Initialization Failed $responseData");
       return ApiResponse.error(status, error: error);
     }
   } catch (e) {
     DebugPrint.prt("Error  in Initialization $e");
     throw ConstText.exceptionError;
   }
 }

 Future<ApiResponse<RazorPayCheckPaymentStatusModel>> completeRazorpayApiCallFunction(Map<String, dynamic> data) async {
   try {
     final response = await apiClassPhp.post(completeRazorpayPayment, data, isHeader: false);
     DebugPrint.prt("API Response Initiate RazorPay ${response.data}");
     final ApiResponseStatus status = mapApiResponseStatusPhp(response.data);
     final Map<String, dynamic> responseData = response.data;
     if (status == ApiResponseStatus.success) {
       final data = RazorPayCheckPaymentStatusModel.fromJson(responseData);
       DebugPrint.prt("ResponseData In success $responseData");
       return ApiResponse.success(data);
     } else {
       final error = RazorPayCheckPaymentStatusModel.fromJson(responseData);
       DebugPrint.prt("Initialization Failed $responseData");
       return ApiResponse.error(status, error: error);
     }
   } catch (e) {
     DebugPrint.prt("Error  in Initialization $e");
     throw ConstText.exceptionError;
   }
 }


 Future<ApiResponse<CashFreePaymentResponseModel>> completeCashFreePayApiCallFunction(Map<String, dynamic> data) async {
   try {
     final response = await apiClassPhp.post(completeCashFreePayment, data, isHeader: false);
     DebugPrint.prt("API Response complete CashFree ${response.data}");
     final ApiResponseStatus status = mapApiResponseStatusPhp(response.data);
     final Map<String, dynamic> responseData = response.data;
     if (status == ApiResponseStatus.success) {
       final data = CashFreePaymentResponseModel.fromJson(responseData);
       DebugPrint.prt("ResponseData In success $responseData");
       return ApiResponse.success(data);
     } else {
       final error = CashFreePaymentResponseModel.fromJson(responseData);
       DebugPrint.prt("Initialization Failed $responseData");
       return ApiResponse.error(status, error: error);
     }
   } catch (e) {
     DebugPrint.prt("Error  in Initialization $e");
     throw ConstText.exceptionError;
   }
 }



}

