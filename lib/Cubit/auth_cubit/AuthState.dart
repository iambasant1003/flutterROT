

import '../../Model/AppVersionResponseModel.dart';
import '../../Model/SendOTPModel.dart';
import '../../Model/SendPhpOTPModel.dart';
import '../../Model/VerifyOTPModel.dart';
import '../../Model/VerifyPHPOTPModel.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthNodeSuccess extends AuthState {
  final SendOTPModel data;
  AuthNodeSuccess(this.data);
}

class AuthPhpSuccess extends AuthState{
  final SendPhpOTPModel data;
  AuthPhpSuccess(this.data);
}


class VerifyOtpLoading extends AuthState{}

class VerifyPhpOTPSuccess extends AuthState{
  final VerifyPHPOTPModel data;
  VerifyPhpOTPSuccess(this.data);
}

class VerifyOTPSuccess extends AuthState{
  final VerifyOTPModel verifyOTPModel;
  VerifyOTPSuccess(this.verifyOTPModel);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}


class PermissionCheckboxState extends AuthState {
  final bool isChecked;
  PermissionCheckboxState({required this.isChecked});
}

class CheckAppVersionSuccess extends AuthState{
   final AppVersionResponseModel appVersionResponseModel;
   CheckAppVersionSuccess(this.appVersionResponseModel);
}

class CheckAppVersionFailed extends AuthState{
  final AppVersionResponseModel appVersionResponseModel;
  CheckAppVersionFailed(this.appVersionResponseModel);
}
