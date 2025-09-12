

import 'package:loan112_app/Utils/Debugprint.dart';


enum ApiResponseStatus {
  success,
  badRequest,
  unauthorized,
  notFound,
  serverError,
  declined,
  selfieError
}

class ApiResponse<T> {
  final T? error;
  final ApiResponseStatus? status;
  final T? data;

  ApiResponse(this.status, {this.data, this.error});

  factory ApiResponse.success(T data) {
    return ApiResponse(ApiResponseStatus.success, data: data);
  }

  factory ApiResponse.error(ApiResponseStatus status, {T? error}) {
    return ApiResponse(status, error: error);
  }
}

ApiResponseStatus mapStatusCode(int statusCode) {
  DebugPrint.prt("StatusCode In ApiResponse $statusCode");
  switch (statusCode) {
    case 200:
      return ApiResponseStatus.success;
    case 400:
      return ApiResponseStatus.badRequest;
    case 402:
      return ApiResponseStatus.declined;
    case 403:
      return ApiResponseStatus.unauthorized;
    case 404:
      return ApiResponseStatus.notFound;
    case 500:
      return ApiResponseStatus.serverError;
    case 205:
       return ApiResponseStatus.selfieError;
    default:
      throw Exception('Unknown status code: $statusCode');
  }
}

ApiResponseStatus mapStatusCodePhp(int statusCode){
  switch (statusCode) {
    case 1:
      return ApiResponseStatus.success;
    case 2:
      return ApiResponseStatus.badRequest;
    case 3:
      return ApiResponseStatus.unauthorized;
    case 4:
      return ApiResponseStatus.unauthorized;
    case 5:
      return ApiResponseStatus.serverError;
    default:
      throw Exception('Unknown status code: $statusCode');
  }
}
