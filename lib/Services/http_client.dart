import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../Model/VerifyOTPModel.dart';
import '../Utils/AppConfig.dart';
import '../Utils/Debugprint.dart';
import '../Utils/MysharePrefenceClass.dart';

class ApiClass {
  static final String _baseUrl = AppConfig.baseUrlNode;

  final Dio _dio;

  ApiClass()
      : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 120),
    receiveTimeout: const Duration(seconds: 120),
    headers: {
      'Content-Type': 'application/json',
    },
  ));


  Future<Map<String, String>> getHeaders({
    bool isHeader = false,
    bool isMultipart = false,
  }) async {
    DebugPrint.prt("Get Header function Called");

    final headers = <String, String>{
      "Content-Type": isMultipart ? 'multipart/form-data' : 'application/json',
    };

    if (isHeader) {
      final dashBoardData = await MySharedPreferences.getUserSessionDataNode();

      if (dashBoardData != null && dashBoardData.isNotEmpty) {
        try {
          final verifyOTPModel =
          VerifyOTPModel.fromJson(jsonDecode(dashBoardData));

          final token = verifyOTPModel.data?.token?.trim();

          if (token != null && token.isNotEmpty) {
            headers['Authorization'] = "Bearer $token";
            DebugPrint.prt("✅ Added Bearer token to header.");
          } else {
            DebugPrint.prt("⚠️ Token was null or empty even though isHeader = true.");
          }
        } catch (e) {
          DebugPrint.prt("❌ Error parsing dashboard data: $e");
        }
      } else {
        DebugPrint.prt("⚠️ No dashboard data found in preferences.");
      }
    }

    DebugPrint.prt("Headers returned: $headers");
    return headers;
  }




  Future<Response> get(String endPoint, {bool isHeader = true}) async {
    final headers = await getHeaders(isHeader: isHeader);
    DebugPrint.prt("Header passed $headers");
    DebugPrint.prt("Get API URL $_baseUrl$endPoint");



    try {
      final response = await _dio.get(
        endPoint,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<Response> post(
      String endPoint,
      dynamic object, {
        bool isHeader = false,
        bool isMultipart = false,
      }) async {
    final headers = await getHeaders(isHeader: isHeader, isMultipart: isMultipart);

    DebugPrint.prt("Header passed: $headers");
    DebugPrint.prt("ApiUrl: $_baseUrl$endPoint");


    if (isMultipart) {
      DebugPrint.prt("data to be passed: fields=${object.fields}, files=${object.files}");
    } else {
      var curlRequest = buildCurlCommand(url: "$_baseUrl$endPoint", method: "POST", headers: headers, body: object);

      DebugPrint.prt("Current Curl Command $curlRequest");
      DebugPrint.prt("data to be passed: $object");
    }

    try {
      final response = await _dio.post(
        endPoint,
        data: isMultipart ? object : jsonEncode(object),
        options: Options(headers: headers),
      );

      DebugPrint.prt("Api Response http class: ${response.data}");
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }




  /// PATCH
  Future<Response> patch(
      String endPoint,
      Object object, {
        bool isHeader = true,
      }) async {
    final headers = await getHeaders(isHeader: isHeader);
    DebugPrint.prt("Header passed $headers");

    try {
      final response = await _dio.patch(
        endPoint,
        data: object,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE
  Future<Response> delete(
      String endPoint,
      dynamic object,{
        bool isHeader = true,
      }) async {
    final headers = await getHeaders(isHeader: isHeader);
    DebugPrint.prt("Header passed $headers");

    try {
      final response = await _dio.delete(
        endPoint,
        data: object,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  /// PUT
  Future<Response> put(
      String endPoint,
      Object object, {
        bool isHeader = true,
        bool isMultipart = false,
      }) async {
    final headers = await getHeaders(isHeader: isHeader, isMultipart: isMultipart);
    DebugPrint.prt("Header passed: $headers");
    DebugPrint.prt("PUT ApiUrl: $_baseUrl$endPoint");


    if(!isMultipart){
      var curlRequest = buildCurlCommand(
        url: "$_baseUrl$endPoint",
        method: "PUT",
        headers: headers,
        body: object,
      );

      DebugPrint.prt("Current Curl Command: $curlRequest");
    }


    if (isMultipart) {
      DebugPrint.prt("data to be passed: multipart data");
    } else {
      DebugPrint.prt("data to be passed: $object");
    }

    try {
      final response = await _dio.put(
        endPoint,
        data: isMultipart ? object : jsonEncode(object),
        options: Options(headers: headers),
      );
      DebugPrint.prt("PUT Api Response: ${response.data}");
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  String buildCurlCommand({
    required String url,
    required String method,
    required Map<String, dynamic> headers,
    required dynamic body,
  }) {
    final buffer = StringBuffer();

    buffer.write('curl -X ${method.toUpperCase()} "$url"');

    for (final entry in headers.entries) {
      buffer.write(' -H "${entry.key}: ${entry.value}"');
    }

    // convert body map to proper JSON string
    final jsonBody = jsonEncode(body);

    buffer.write(" -d '$jsonBody'");

    return buffer.toString();
  }


  /// Private error handler
  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Network Request timed out';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No Internet Connection';
    } else {
      return e.message ?? 'Unexpected error';
    }
  }
}
