import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:rupeeontime/Model/VerifyPHPOTPModel.dart';
import 'package:rupeeontime/Utils/MysharePrefenceClass.dart';
import '../Utils/AppConfig.dart';
import '../Utils/Debugprint.dart';

class ApiClassPhp {
  static final String _baseUrl = AppConfig.baseUrlPhp;

  final Dio _dio;

  ApiClassPhp()
      : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {},
    contentType: Headers.jsonContentType,
    preserveHeaderCase: true,
  )) {
    // 👇 This is new
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  /// Creating Header With Authenticated Data
  Future<Map<String, String>> getHeaders({bool isHeader = false}) async {
    DebugPrint.prt("Get Header function Called");

    String? token;
    String? authToken;

    // Read saved session data
    final dashBoardData = await MySharedPreferences.getUserSessionDataPhp();
    DebugPrint.prt("DashBoard Data in Header: $dashBoardData");

    if (dashBoardData != null && dashBoardData.isNotEmpty) {
      try {
        final verifyOTPModel =
        VerifyPHPOTPModel.fromJson(jsonDecode(dashBoardData));
        authToken = verifyOTPModel.data?.appLoginToken?.trim();
        DebugPrint.prt("Token from session: $token");
      } catch (e) {
        DebugPrint.prt("❌ Error parsing session data: $e");
      }
    }

    // If no token in session, fallback to AppConfig
    token ??= AppConfig.authPhpToken.trim();

    DebugPrint.prt("Final token to use: $token");

    final headers = <String, String>{
      "Content-Type": "application/json",
    };

    if (isHeader) {
      headers['Auth'] = token;
      headers['Authtoken'] = authToken ?? "";
      DebugPrint.prt("✅ Added 'Auth' header with token");
    } else {
      DebugPrint.prt("ℹ️ isHeader=false, not adding Auth header");
    }

    DebugPrint.prt("Headers returned: $headers");
    return headers;
  }


  /// GET
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

  /// POST
  Future<Response> post(
      String endPoint,
      Map<String, dynamic> object, {
        bool isHeader = true,
      }) async {
    try {
      final headers = await getHeaders(isHeader: true);

      var culRequest = buildCurlCommand(url: "$_baseUrl$endPoint", method: "POST", headers: headers, body: object);
      DebugPrint.prt("Curl Request $culRequest");

      final response = await _dio.post(
        endPoint,
        data: object,
        options: Options(headers: headers),
      );

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
      String endPoint, {
        bool isHeader = true,
      }) async {
    final headers = await getHeaders(isHeader: isHeader);
    DebugPrint.prt("Header passed $headers");

    try {
      final response = await _dio.delete(
        endPoint,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
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

  String buildCurlCommand({
    required String url,
    required String method,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
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



}
