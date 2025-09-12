import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Constant/ApiUrlConstant/WebviewUrl.dart';
import 'package:loan112_app/Constant/ColorConst/ColorConstant.dart';
import 'package:loan112_app/Constant/ImageConstant/ImageConstants.dart';
import 'package:loan112_app/Utils/Debugprint.dart';
import 'package:loan112_app/Utils/MysharePrefenceClass.dart';
import 'package:loan112_app/Utils/snackbarMassage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Constant/FontConstant/FontConstant.dart';
import '../../Cubit/auth_cubit/AuthCubit.dart';
import '../../Cubit/auth_cubit/AuthState.dart';
import '../../Routes/app_router_name.dart';
import '../../Utils/FirebaseNotificationService.dart';
import '../../Widget/common_button.dart';


class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<StatefulWidget> createState() => _PermissionPage();
}

class _PermissionPage extends State<PermissionPage> {

  @override
  void initState() {
    super.initState();
    _initAppsFlyer();
    allowNotification();
  }


  void allowNotification() async{
    await FirebaseNotificationService().init(context);
  }

  AppsflyerSdk? _appsflyerSdk;

  void _initAppsFlyer() async {
    final options = AppsFlyerOptions(
      afDevKey: "", // Replace this
      appId: "6747157984", // iOS App ID (can be empty for Android)
      showDebug: true,
      timeToWaitForATTUserAuthorization: 50,
    );

    _appsflyerSdk = AppsflyerSdk(options);

    var result = await _appsflyerSdk!.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    _appsflyerSdk!.onInstallConversionData((data) {
      debugPrint("🔁 Conversion Data: $data");
    });

    _appsflyerSdk!.onAppOpenAttribution((data) {
      debugPrint("📥 Attribution Data: $data");
    });

    _appsflyerSdk!.onDeepLinking((data) {
      debugPrint("🔗 Deep Link Data: $data");
    });

    DebugPrint.prt("AppFlyer result $result");
    // if (result['status'] == 'OK')
    if (result['status'] == 'OK') {
      final appsFlyerId = await _appsflyerSdk?.getAppsFlyerUID();
      DebugPrint.prt("AppFlyer Id $appsFlyerId");
      if (appsFlyerId != null) {
        MySharedPreferences.setAppsFlyerKey(appsFlyerId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand( // background fills screen
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                ImageConstants.permissionScreenBackground,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20), // avoid bottom cut-off
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 15),
                        permissionContainerWidget(context),
                        //const SizedBox(height: 60), // leave space for button
                      ],
                    ),
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstant.appThemeColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(18.0),
                              bottomRight: Radius.circular(18.0),
                            ),
                          ),
                          width: 244,
                          height: 40,
                          child: Center(
                            child: Text(
                              "Permissions",
                              style: TextStyle(
                                fontSize: FontConstants.f18,
                                fontWeight: FontConstants.w800,
                                color: ColorConstant.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    /*
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: 162,
                          child: Loan112Button(
                            onPressed: () {
                              if (allPermissionAccepted) {
                                takeAllRequiredPermission(context);
                              }else{
                                openSnackBar(context, "Please accept our Terms & Conditions and Privacy Policy.");
                              }
                            },
                            text: "Allow",
                          ),
                        ),
                      ),
                    ),

                     */
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context,state){
            final authCubit = context.read<AuthCubit>();
            bool checked = authCubit.isPermissionGiven;

            if (state is PermissionCheckboxState) {
              checked = state.isChecked;
            }
            return SizedBox(
              width: 162,
              height: 85,
              child: Padding(
                padding: EdgeInsets.all(FontConstants.horizontalPadding),
                child: Loan112Button(
                  onPressed: () {
                    if (checked) {
                      takeAllRequiredPermission(context);
                    }else{
                      openSnackBar(context, "Please accept our Terms & Conditions and Privacy Policy.");
                    }
                  },
                  text: "Allow",
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void takeAllRequiredPermission(BuildContext context) async{
    final cameraPermission = await Permission.camera.request();
    final microPhonePermission = await Permission.microphone.request();
    final locationPermission = await Permission.location.request();

    DebugPrint.prt("camera permission ${cameraPermission.isGranted}");
    DebugPrint.prt("MicroPhone permission ${microPhonePermission.isGranted}");
    DebugPrint.prt("Location permission ${locationPermission.isGranted}");


    if (cameraPermission.isGranted &&
        microPhonePermission.isGranted &&
        locationPermission.isGranted &&
        !(await Permission.notification.isDenied ||
            await Permission.notification.isPermanentlyDenied)
    ) {
      MySharedPreferences.setPermissionStatus(true);
      context.go(AppRouterName.login);
    } else {
      openAppSettings();
    }
  }

  Widget permissionTypeWidget(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: ColorConstant.appThemeColor.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 4), // x: 0, y: 4 => shadow below only
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 35.0,
              right: 12.0,
              top: 12.0,
              bottom: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: FontConstants.f16,
                    fontFamily: FontConstants.fontFamily,
                    fontWeight: FontConstants.w700,
                    color: ColorConstant.blackTextColor,
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontConstants.f12,
                          fontWeight: FontConstants.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          bottom: 10,
          left: -4,
          child: Image.asset(imagePath, width: 46, height: 46),
        ),
      ],
    );
  }

  Widget permissionContainerWidget(BuildContext context){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstants.permissionScreenLeftPyramid,width: 26,height: 13),
            SizedBox(
              width: 214,
            ),
            Image.asset(ImageConstants.permissionScreenRightPyramid,width: 26,height: 13.0),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            //vertical: 32,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 28),
              // other content goes here
              permissionTypeWidget(
                context,
                title: 'Location',
                subtitle:
                'This app collects location details one-time to fetch your current location (latitude/longitude) to identify serviceability, verify your current address expediting the KYC process and prevent fraud. We do not collect location when the app is in the background.',
                imagePath: ImageConstants.permissionScreenLocation,
              ),
              SizedBox(height: 12),
              permissionTypeWidget(
                context,
                title: 'Device',
                subtitle:
                'To call Company customer care executive directly through the application, allow us to make and manage phone/video calls. With this permission, the customer is able to call (Phone/Video) Company customer care executive directly through the application.',
                imagePath: ImageConstants.permissionScreenDevice,
              ),
              SizedBox(height: 12),
              if(Platform.isAndroid)...[
                permissionTypeWidget(
                  context,
                  title: 'SMS',
                  subtitle: 'The app periodically collects and transmits SMS data like sender names, SMS body and received time to our servers and third parties. This data is used to assess your income, spending patterns and your loan affordability. This helps us in quick credit assessment and help us in facilitating best offers to customers easily and at the same time prevent fraud.',
                  imagePath: ImageConstants.permissionScreenSMS,
                ),
                SizedBox(height: 12),
              ],
              permissionTypeWidget(
                context,
                title: 'Camera',
                subtitle:
                'Grant access so you can take some selfies for verification',
                imagePath: ImageConstants.permissionScreenCamera,
              ),
              SizedBox(height: 16.0),
              consentBoxUI(context),
              SizedBox(height: 24.0),
            ],
          ),
        )
      ],
    );
  }

  Widget consentBoxUI(BuildContext context){
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context,state){
        final authCubit = context.read<AuthCubit>();
        bool checked = authCubit.isPermissionGiven;

        if (state is PermissionCheckboxState) {
          checked = state.isChecked;
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: checked,
              onChanged: (val) {
                context.read<AuthCubit>()
                    .toggleCheckbox(val);
              },
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: 'By proceeding, you agree to our ',
                  style: TextStyle(
                    color: ColorConstant.greyTextColor,
                    fontSize: FontConstants.f12,
                    fontFamily: FontConstants.fontFamily,
                    fontWeight: FontConstants.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: ColorConstant.blueTextColor,
                        fontSize: FontConstants.f12,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontConstants.w500,
                      ),
                      recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          context.push(AppRouterName.termsAndConditionWebview,extra: UrlsNods.TermAndCondition);
                        },
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(
                        color: ColorConstant.greyTextColor,
                        fontSize: FontConstants.f12,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontConstants.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: ColorConstant.blueTextColor,
                        fontSize: FontConstants.f12,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontConstants.w500,
                      ),
                      recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          context.push(AppRouterName.termsAndConditionWebview,extra: UrlsNods.privacy);
                        },
                    ),
                    TextSpan(
                      text:
                      ' and consent to receive WhatsApp and email communications.',
                      style: TextStyle(
                        color: ColorConstant.greyTextColor,
                        fontSize: FontConstants.f12,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontConstants.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
