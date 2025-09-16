import 'dart:convert';
import 'dart:io';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ConstText/ConstText.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Cubit/auth_cubit/AuthCubit.dart';
import 'package:rupeeontime/Cubit/auth_cubit/AuthState.dart';
import 'package:rupeeontime/Model/VerifyOTPModel.dart';
import 'package:rupeeontime/Utils/AppConfig.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/MysharePrefenceClass.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Routes/app_router_name.dart';
import '../../Utils/FirebaseNotificationService.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Call async logic after the widget is initialized

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Or any other color
        statusBarIconBrightness: Brightness.light, // or Brightness.dark
      ),
    );

    Future.delayed(Duration.zero, () {
      // context.read<AuthCubit>().checkAppVersionApiCall();
      _initAsync(context);
    });
  }

  Future<void> _initAsync(BuildContext context) async {
    var isPermissionGiven = await MySharedPreferences.getPermissionStatus();
    var dashBoardData = await MySharedPreferences.getUserSessionDataNode();
    var dashBoardDataPhp = await MySharedPreferences.getUserSessionDataPhp();
    DebugPrint.prt("Is permission Given $isPermissionGiven");
    DebugPrint.prt("Dashbaord Data $dashBoardData,$dashBoardDataPhp");
    Future.delayed(const Duration(seconds: 3), ()  async{
      if(dashBoardData != "" && dashBoardData != null){
        VerifyOTPModel verifyOTPModel = VerifyOTPModel.fromJson(jsonDecode(dashBoardData));
        //VerifyOTPModel verifyOTPModelPhp = VerifyOTPModel.fromJson(jsonDecode(dashBoardDataPhp));
        if(verifyOTPModel.data?.token != "" && verifyOTPModel.data?.token != null){
          GoRouter.of(context).push(AppRouterName.dashboardPage);
        }
        else{
          if(isPermissionGiven){
            GoRouter.of(context).go(AppRouterName.login);
          }else{
            GoRouter.of(context).go(AppRouterName.permissionPage);
          }
        }
      }
      else{
        if(isPermissionGiven){
          context.go(AppRouterName.login);
        }else{
          context.go(AppRouterName.permissionPage);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit,AuthState>(
        listenWhen: (prevState,currentState){
          return prevState != currentState;
        },
        listener: (context,state){
          if(state is AuthLoading){
            EasyLoading.show(status: "Please Wait...");
          }else if(state is CheckAppVersionSuccess){
            DebugPrint.prt("Check AppVersion Success");
            EasyLoading.dismiss();
            if(int.parse(state.appVersionResponseModel.version ?? "0") != AppConfig.appVersion){
              openPlayStore(context);
            }else{
              _initAsync(context);
            }
          }else if(state is CheckAppVersionFailed){
            EasyLoading.dismiss();
            openSnackBar(context, state.appVersionResponseModel.message ?? "UnExpected Error");
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFAFCFD), // Top color
                Color(0xFFB9F0FD), // Bottom color
              ],
            ),
          ),
          child: Center(
            child: Image.asset(
              ImageConstants.appIconLogo,
              width: 216,
              height: 128,
            ),
          ),
        )
      ),
    );

  }


  Future<void> openPlayStore(BuildContext context) async {
    final Uri playStoreUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.personalLoan.loan112&hl=en_IN&pli=1',
    );
    final iosUrl = Uri.parse(
        "https://apps.apple.com/in/app/loan112/id6747157984"
    );
    if(Platform.isIOS){
      if (!await launchUrl(
        iosUrl,
        mode: LaunchMode.externalApplication,
      )) {
        openSnackBar(context, 'Could not launch $playStoreUrl');
      }
    }else{
      if (!await launchUrl(
        playStoreUrl,
        mode: LaunchMode.externalApplication,
      )) {
        openSnackBar(context, 'Could not launch $playStoreUrl');
      }
    }

  }

}
