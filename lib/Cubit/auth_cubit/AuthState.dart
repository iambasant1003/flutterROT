import 'package:loan112_app/Model/AppVersionResponseModel.dart';
import 'package:loan112_app/Model/SendOTPModel.dart';
import 'package:loan112_app/Model/SendPhpOTPModel.dart';
import 'package:loan112_app/Model/VerifyPHPOTPModel.dart';

import '../../Model/VerifyOTPModel.dart';

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
