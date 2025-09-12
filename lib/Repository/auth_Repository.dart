
import 'dart:convert';
import 'package:loan112_app/Constant/ApiUrlConstant/ApiUrlConstant.dart';
import 'package:loan112_app/Cubit/auth_cubit/AuthState.dart';
import 'package:loan112_app/Model/SendPhpOTPModel.dart';
import 'package:loan112_app/Model/VerifyOTPModel.dart';
import 'package:loan112_app/Model/VerifyPHPOTPModel.dart';
import 'package:loan112_app/Services/ApiResponseStatus.dart';
import 'package:loan112_app/Services/http_client_php.dart';
import '../Constant/ConstText/ConstText.dart';
import '../Model/AppVersionResponseModel.dart';
import '../Model/SendOTPModel.dart';
import '../Model/error_model.dart';
import '../Services/http_client.dart';
import '../Utils/Debugprint.dart';

class AuthRepository {
  final ApiClass apiClass;
  final ApiClassPhp apiClassPhp;
  AuthRepository(this.apiClass,this.apiClassPhp);

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

  Future<ApiResponse<SendOTPModel>> sendOTPNodeApiCallFunction(Map<String, dynamic> data) async {
    try {
      final response = await apiClass.post(sendOTPNode, data, isHeader: false);
      DebugPrint.prt("API Response AreaWise Data ${response.data}");
      final ApiResponseStatus status = mapApiResponseStatus(response.data);
      final Map<String, dynamic> responseData = response.data;
      if (status == ApiResponseStatus.success) {
        final data = SendOTPModel.fromJson(responseData);
        DebugPrint.prt("ResponseData In success $responseData");
        return ApiResponse.success(data);
      } else {
        final error = SendOTPModel.fromJson(responseData);
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponse<SendPhpOTPModel>> sendOTPhpApiCallFunction(Map<String, dynamic> data) async {
    try {
      final response = await apiClassPhp.post(sendOTPhp, data, isHeader: true);
      DebugPrint.prt("Php Otp Verify Ui $response");
      final ApiResponseStatus status = mapApiResponseStatusPhp(response.data);
      final Map<String, dynamic> responseData = response.data;
      if (status == ApiResponseStatus.success) {
        final data = SendPhpOTPModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = SendPhpOTPModel.fromJson(responseData);
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      throw ConstText.exceptionError;
    }
  }

  Future<ApiResponse<VerifyOTPModel>> verifyOTPNodeApiCallFunction(Map<String, dynamic> data) async {
    try {
      final response = await apiClass.post(verifyOTPNode, data, isHeader: false);
      DebugPrint.prt("API Response AreaWise Data ${response.data},${response.statusCode}");
      final ApiResponseStatus status = mapApiResponseStatus(response.data);
      final Map<String, dynamic> responseData = response.data;
      if (status == ApiResponseStatus.success) {
        final data = VerifyOTPModel.fromJson(responseData);
        DebugPrint.prt("ResponseData In success $responseData");
        return ApiResponse.success(data);
      } else {
        final error = VerifyOTPModel.fromJson(responseData);
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      throw ConstText.exceptionError;
    }
  }

  Future<ApiResponse<VerifyPHPOTPModel>> verifyOTPpHpApiCallFunction(Map<String, dynamic> data) async {
    try {
      final response = await apiClassPhp.post(verifyOTPhp, data, isHeader: true);
      DebugPrint.prt("API Response Verify PHP OTP Data ${response.data},${response.statusCode}");
      final ApiResponseStatus status = mapApiResponseStatusPhp(response.data);
      final Map<String, dynamic> responseData = response.data;
      if (status == ApiResponseStatus.success) {
        final data = VerifyPHPOTPModel.fromJson(responseData);
        DebugPrint.prt("ResponseData In success $responseData");
        return ApiResponse.success(data);
      } else {
        final error = VerifyPHPOTPModel.fromJson(responseData);
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      throw ConstText.exceptionError;
    }
  }

  Future<ApiResponse<AppVersionResponseModel>> verifyAppVersionApiCallFunction(Map<String, dynamic> data) async {
    try {
      final response = await apiClassPhp.post(appVersionCheck, data, isHeader: false);
      DebugPrint.prt("API Response Check App Version Data ${response.data},${response.statusCode}");
      final ApiResponseStatus status = mapApiResponseStatusPhp(response.data);
      final Map<String, dynamic> responseData = response.data;
      if (status == ApiResponseStatus.success) {
        final data = AppVersionResponseModel.fromJson(responseData);
        DebugPrint.prt("ResponseData In success $responseData");
        return ApiResponse.success(data);
      } else {
        final error = AppVersionResponseModel.fromJson(responseData);
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      throw ConstText.exceptionError;
    }
  }
}