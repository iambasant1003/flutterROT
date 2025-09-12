
import 'package:loan112_app/Constant/ConstText/ConstText.dart';
import 'package:loan112_app/Model/DashBoarddataModel.dart';
import 'package:loan112_app/Model/DeleteCustomerModel.dart';
import 'package:loan112_app/Services/http_client.dart';
import 'package:loan112_app/Services/http_client_php.dart';
import '../Constant/ApiUrlConstant/ApiUrlConstant.dart';
import '../Model/DeleteProfileOTPVerifyModel.dart';
import '../Services/ApiResponseStatus.dart';
import '../Utils/Debugprint.dart';

class DashBoardRepository{
  final ApiClassPhp apiClassPhp;
  DashBoardRepository(this.apiClassPhp);


  ApiResponseStatus mapApiResponseStatusPhp(dynamic responseBody) {
    final Map<String, dynamic> decoded = responseBody;

    final int? logicalStatusCode = decoded['Status'];

    if (logicalStatusCode == null) {
      // Fallback: if no logical status code found, treat as failure
      return ApiResponseStatus.notFound;
    }

    return mapStatusCodePhp(logicalStatusCode);
  }

  ApiResponseStatus mapApiResponseStatus(dynamic responseBody) {
    final Map<String, dynamic> decoded = responseBody;

    final int? logicalStatusCode = decoded['statusCode'];

    if (logicalStatusCode == null) {
      // Fallback: if no logical status code found, treat as failure
      return ApiResponseStatus.notFound;
    }

    return mapStatusCode(logicalStatusCode);
  }

  Future<ApiResponse<DashBoarddataModel>> dashBoardApiCallFunction(Map<String,String> dataObj) async {
    final response = await apiClassPhp.post(dashBoard, dataObj, isHeader: true);
    DebugPrint.prt("API Response AreaWise Data ${response.data}");

    final Map<String, dynamic> responseData = response.data;
    final ApiResponseStatus status = mapApiResponseStatusPhp(responseData);

    if (status == ApiResponseStatus.success) {
      final data = DashBoarddataModel.fromJson(responseData);
      DebugPrint.prt("ResponseData In success $responseData");
      return ApiResponse.success(data);
    } else {
      final error = DashBoarddataModel.fromJson(responseData);
      return ApiResponse.error(status, error: error);
    }
  }


  Future<ApiResponse<DeleteCustomerModel>> deleteCustomerApiCallFunction(Map<String,dynamic> dataObj) async {
    try{
      final response = await apiClassPhp.post(deleteCustomerProfile, dataObj, isHeader: true);
      DebugPrint.prt("API Response Delete Customer Data ${response.data}");

      final Map<String, dynamic> responseData = response.data;
      final ApiResponseStatus status = mapApiResponseStatusPhp(responseData);

      if (status == ApiResponseStatus.success) {
        final data = DeleteCustomerModel.fromJson(responseData);
        DebugPrint.prt("ResponseData In success $responseData");
        return ApiResponse.success(data);
      } else {
        final error = DeleteCustomerModel.fromJson(responseData);
        return ApiResponse.error(status, error: error);
      }
    } catch (e){
      final error = DeleteCustomerModel.fromJson({
      'Data': null,
      'Message': ConstText.exceptionError,
      'Status': null,
      });
      return ApiResponse.error(ApiResponseStatus.notFound, error: error);
    }
  }


  Future<ApiResponse<DeleteProfileOTPVerifyModel>> verifyDeleteOTPApiCallFunction(Map<String,dynamic> dataObj) async{
    try{
      final response = await apiClassPhp.post(deleteCustomerProfile, dataObj, isHeader: true);
      DebugPrint.prt("API Response Delete Customer Data ${response.data}");

      final Map<String, dynamic> responseData = response.data;
      final ApiResponseStatus status = mapApiResponseStatusPhp(responseData);

      if (status == ApiResponseStatus.success) {
        final data = DeleteProfileOTPVerifyModel.fromJson(responseData);
        DebugPrint.prt("ResponseData In success $responseData");
        return ApiResponse.success(data);
      } else {
        final error = DeleteProfileOTPVerifyModel.fromJson(responseData);
        return ApiResponse.error(status, error: error);
      }
    } catch (e){
      final error = DeleteProfileOTPVerifyModel.fromJson({
        'Data': null,
        'Message': ConstText.exceptionError,
        'Status': null,
      });
      return ApiResponse.error(ApiResponseStatus.notFound, error: error);
    }
  }




}