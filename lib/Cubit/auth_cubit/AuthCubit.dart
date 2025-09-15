
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan112_app/Cubit/safe_emit.dart';
import '../../Constant/ConstText/ConstText.dart';
import '../../Constant/PageKeyConstant/PageKeyConstant.dart';
import '../../Model/AppVersionResponseModel.dart';
import '../../Model/SendOTPModel.dart';
import '../../Model/SendPhpOTPModel.dart';
import '../../ParamModel/AppVersionRequestModel.dart';
import '../../ParamModel/SendOTPPramNodeModel.dart';
import '../../ParamModel/SendOTPPramPHPModel.dart';
import '../../Repository/auth_Repository.dart';
import '../../Services/ApiResponseStatus.dart';
import '../../Utils/AppConfig.dart';
import '../../Utils/Debugprint.dart';
import '../../Utils/MysharePrefenceClass.dart';
import '../../Utils/validation.dart';
import 'AuthState.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  bool isPermissionGiven = false;

  void toggleCheckbox(bool? value) {
    isPermissionGiven = value ?? false;
    safeEmit(() => emit(PermissionCheckboxState(isChecked: isPermissionGiven)));
  }

  Future<void> sendOtpNode(String phoneNumber) async {
    //emit(AuthLoading());

    SendOTPPramNodeModel sendOTPPramNodeModel = SendOTPPramNodeModel();
    sendOTPPramNodeModel.mobile = phoneNumber.trim().toString();

    try {
      final response = await authRepository.sendOTPNodeApiCallFunction(sendOTPPramNodeModel.toJson());
      if (response.status == ApiResponseStatus.success) {
        safeEmit(()=>emit(AuthNodeSuccess(response.data!)));
      } else {
        safeEmit(()=>emit(AuthError(response.error?.message ?? "Unknown error")));
      }
    } catch (e) {
      safeEmit(()=>emit(AuthError("UnExpected Error")));
    }
  }

  Future<void> sendBothOtp(String phoneNumber) async {
    DebugPrint.prt("Inside Method");
    safeEmit(()=>emit(AuthLoading()));

    try {
      // Get location with timeout
      final position = await getCurrentPositionFast();

      final geoLat = position.latitude.toString();
      final geoLong = position.longitude.toString();
      final deviceId = await getDeviceId();
      final fcmToken = await MySharedPreferences.getNotificationData();
      final appFlyerId = await MySharedPreferences.getAppsFlyerKey();

      DebugPrint.prt("Position $position, GeoLat $geoLat, GeoLong $geoLong, DeviceId $deviceId");

      SendOTPPramPHPModel sendOtpParamPHPModel = SendOTPPramPHPModel()
        ..currentPage = pageLogin.toString()
        ..mobile = phoneNumber.trim()
        ..isExistingCustomer = 0
        ..adjustAdid = 1
        ..adjustGpsId = 1
        ..adjustIdfa = 1
        ..pancard = ""
        ..geoLat = geoLat
        ..geoLong = geoLong
        ..utmSource = ""
        ..utmMedium = ""
        ..utmCampaign = ""
        ..fcmToken = fcmToken
        ..appfylerUid = appFlyerId
        ..appfylerAdvertiserId = ""
        ..deviceId = deviceId ?? "";

      SendOTPPramNodeModel sendOTPPramNodeModel = SendOTPPramNodeModel()
        ..mobile = phoneNumber.trim();

      // API calls with timeout
      var responseList = await Future.wait([
        authRepository
            .sendOTPNodeApiCallFunction(sendOTPPramNodeModel.toJson()),
        authRepository
            .sendOTPhpApiCallFunction(sendOtpParamPHPModel.toJson())
      ]);

      if (responseList[0].status == ApiResponseStatus.success &&
          responseList[1].status == ApiResponseStatus.success) {
        safeEmit(()=>emit(AuthNodeSuccess(
          SendOTPModel.fromJson(jsonDecode(jsonEncode(responseList[0].data))),
        )));
        safeEmit(()=>
            emit(AuthPhpSuccess(
              SendPhpOTPModel.fromJson(jsonDecode(jsonEncode(responseList[1].data))),
            ))
        );
      } else {
        if (responseList[0].status != ApiResponseStatus.success) {
          final err = SendOTPModel.fromJson(jsonDecode(jsonEncode(responseList[0].error)));
          safeEmit(()=>
              emit(AuthError(err.message ?? "Unknown Error"))
          );
        } else if (responseList[1].status != ApiResponseStatus.success) {
          final err = SendPhpOTPModel.fromJson(jsonDecode(jsonEncode(responseList[1].error)));
          safeEmit(()=>
              emit(AuthError(err.message ?? "Unknown Error"))
          );
        }
      }
    } catch (e) {
      DebugPrint.prt("Error in sendBothOtp: $e");
      safeEmit(()=>
          emit(AuthError(ConstText.exceptionError))
      );
    }
  }

  /*
  Future<void> sendOtpHp(String phoneNumber) async {
    try {
      final position = await getCurrentPosition();
      final geoLat = position.latitude.toString();
      final geoLong = position.longitude.toString();
      final deviceId = await getDeviceId();

      DebugPrint.prt("Position $position,GeoLat $geoLat,GeoLang $geoLong,DeviceId $deviceId");

      SendOTPPramPHPModel sendOtpParamPHPModel = SendOTPPramPHPModel();
      sendOtpParamPHPModel.currentPage = pageLogin.toString();
      sendOtpParamPHPModel.mobile = phoneNumber.trim().toString();
      sendOtpParamPHPModel.isExistingCustomer = 0;
      sendOtpParamPHPModel.adjustAdid = 1;
      sendOtpParamPHPModel.adjustGpsId = 1;
      sendOtpParamPHPModel.adjustIdfa = 1;
      sendOtpParamPHPModel.pancard = "";
      sendOtpParamPHPModel.geoLat = geoLat;
      sendOtpParamPHPModel.geoLong = geoLong;
      sendOtpParamPHPModel.utmSource = "";
      sendOtpParamPHPModel.utmMedium = "";
      sendOtpParamPHPModel.utmCampaign = "";
      sendOtpParamPHPModel.fcmToken = "";
      sendOtpParamPHPModel.appfylerUid = "";
      sendOtpParamPHPModel.appfylerAdvertiserId = "";
      sendOtpParamPHPModel.deviceId = deviceId ?? "";

      emit(AuthLoading());

      final response = await authRepository.sendOTPhpApiCallFunction(sendOtpParamPHPModel.toJson());



      if (response.status == ApiResponseStatus.success) {
        emit(AuthPhpSuccess(response.data!));
      } else {
        DebugPrint.prt("Error Message ${response.error?.message}");
        emit(AuthError(response.error?.message ?? "Unknown error"));
      }
    } catch (e) {
      DebugPrint.prt('Exception $e');
      emit(AuthError("something went wrong"));
    }
  }

   */

  Future<String> getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;  // or androidInfo.androidId
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor ?? "";
    }
    return "";
  }

  Future<void> verifyOtpNode(String phoneNumber,String otp) async {
    safeEmit(()=>
        emit(VerifyOtpLoading())
    );
    try {
      final response = await authRepository.verifyOTPNodeApiCallFunction({
        "mobile":phoneNumber,
        "otp":otp
      });
      DebugPrint.prt("Verify OTP Success $response");
      if (response.status == ApiResponseStatus.success) {
        safeEmit(()=>
            emit(VerifyOTPSuccess(response.data!))
        );
      } else {
        safeEmit(()=>
            emit(AuthError(response.error?.message ?? "Unknown error"))
        );
      }
    } catch (e) {
      safeEmit(()=>
          emit(AuthError(ConstText.exceptionError))
      );
    }
  }

  Future<void> verifyOtpPhp(String phoneNumber,String otp) async {
    var customerData = await MySharedPreferences.getPhpOTPModel();
    SendPhpOTPModel sendPhpOTPModel = SendPhpOTPModel.fromJson(jsonDecode(customerData));
    Map<String, dynamic> otpVerifyRequest = {
      "current_page": "otp_verify",
      "cust_profile_id": sendPhpOTPModel.data?.custProfileId ?? "",
      "mobile": phoneNumber,
      "otp": int.parse(otp)
    };

    safeEmit(()=>
        emit(VerifyOtpLoading())
    );
    try {
      final response = await authRepository.verifyOTPpHpApiCallFunction(otpVerifyRequest);
      DebugPrint.prt("Verify OTP Success $response");
      if (response.status == ApiResponseStatus.success) {
        safeEmit(()=>
            emit(VerifyPhpOTPSuccess(response.data!))
        );
      } else {
        safeEmit(()=>
            emit(AuthError(response.error?.message ?? "Unknown error"))
        );
      }
    } catch (e) {
      safeEmit(()=>
          emit(AuthError(ConstText.exceptionError))
      );
    }
  }

  Future<void> checkAppVersionApiCall() async {
    AppVersionRequestModel appVersionRequestModel = AppVersionRequestModel();
    appVersionRequestModel.version = AppConfig.appVersion;
    appVersionRequestModel.fcmToken = "";
    appVersionRequestModel.appName = "LN";
    appVersionRequestModel.deviceId = await getDeviceId();

    safeEmit(()=>
        emit(AuthLoading())
    );
    try {
      final response = await authRepository.verifyAppVersionApiCallFunction(appVersionRequestModel.toJson());
      DebugPrint.prt("Check AppVersion Success $response");
      if (response.status == ApiResponseStatus.success) {
        safeEmit(()=>
            emit(CheckAppVersionSuccess(response.data!))
        );
      } else {
        safeEmit(()=>
            emit(CheckAppVersionFailed(response.error!))
        );
      }
    } catch (e) {
      safeEmit(()=>
          emit(CheckAppVersionFailed(
            AppVersionResponseModel(
              status: 500,
              message: ConstText.exceptionError
            )
          ))
      );
    }
  }

}
