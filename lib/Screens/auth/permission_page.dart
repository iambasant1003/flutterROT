import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ApiUrlConstant/WebviewUrl.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/MysharePrefenceClass.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widgets_easier/widgets_easier.dart';
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
      backgroundColor: ColorConstant.appThemeColor,
      body: SizedBox.expand(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstant.whiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(54.0),
                    topRight: Radius.circular(54.0),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: FontConstants.horizontalPadding,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 pushes bottom section down
                            children: [
                              SizedBox(height: 24.0,),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: FontConstants.horizontalPadding,
                                ),
                                child: permissionContainerWidget(context),
                              ),

                              /// Bottom Section
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: ColorConstant.whiteColor,
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 12.0,
                ),
                consentBoxUI(context),
                const SizedBox(height: 24.0),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final authCubit = context.read<AuthCubit>();
                    bool checked = authCubit.isPermissionGiven;

                    if (state is PermissionCheckboxState) {
                      checked = state.isChecked;
                    }

                    return Loan112Button(
                      onPressed: () {
                        if (checked) {
                          takeAllRequiredPermission(context);
                        } else {
                          openSnackBar(context,
                              "Please accept our Terms & Conditions and Privacy Policy.");
                        }
                      },
                      text: "Continue",
                    );
                  },
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
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
          decoration: ShapeDecoration(
            shape: DashedBorder(
                width: 2.8,
                color: Colors.black12,
              dashSize: 2.8,
              radius: 10
            ),
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
                    fontSize: FontConstants.f18,
                    fontFamily: FontConstants.fontFamily,
                    fontWeight: FontConstants.w800,
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
                          fontSize: FontConstants.f14,
                          fontWeight: FontConstants.w500,
                          color: ColorConstant.appThemeColor
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
        Center(
          child: Text(
            "Enable Permissions",
            style: TextStyle(
              fontSize: FontConstants.f24,
              fontWeight: FontConstants.w800,
              color: ColorConstant.permissionPageTextColor,
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 28),
            // other content goes here
            permissionTypeWidget(
              context,
              title: 'Location',
              subtitle:
              'This app collects location details one-time to fetch your current location (latitude/longitude) to identify serviceability, verify your current address expediting the KYC process and prevent fraud. We do not collect location when the app is in the background.',
              imagePath: ImageConstants.rotPermissionScreenLocation,
            ),
            SizedBox(height: 12),
            permissionTypeWidget(
              context,
              title: 'Phone State',
              subtitle:
              'To call Company customer care executive directly through the application, allow us to make and manage phone/video calls. With this permission, the customer is able to call (Phone/Video) Company customer care executive directly through the application.',
              imagePath: ImageConstants.rotPermissionScreenPhoneState,
            ),
            SizedBox(height: 12),
           // if(Platform.isAndroid)...[
              permissionTypeWidget(
                context,
                title: 'SMS',
                subtitle: 'The app periodically collects and transmits SMS data like sender names, SMS body and received time to our servers and third parties. This data is used to assess your income, spending patterns and your loan affordability. This helps us in quick credit assessment and help us in facilitating best offers to customers easily and at the same time prevent fraud.',
                imagePath: ImageConstants.rotPermissionScreenSMS,
              ),
              SizedBox(height: 12),
           // ],
            permissionTypeWidget(
              context,
              title: 'Camera',
              subtitle:
              'Grant access so you can take some selfies for verification',
              imagePath: ImageConstants.rotPermissionScreenCamera,
            ),
            SizedBox(height: 12),
            permissionTypeWidget(
              context,
              title: 'Apps',
              subtitle: 'This app collects and uploads the list of installed and system applications on your device to our trusted partner, Credeau (via https://devicesync.credeau.com), who provides device intelligence services. This data is used to detect potential fraud-such as the presence of VPNs, gaming, or other high-risk apps-and to assess your risk profile more accurately. These insights help us enable faster credit approvals and offer more suitable credit limits. The data is collected only after your explicit consent and is handled securely in accordance with applicable privacy policies.',
              imagePath: ImageConstants.rotPermissionScreenApp,
            ),
            SizedBox(height: 12),
            permissionTypeWidget(
              context,
              title: 'Device Metadata',
              subtitle: 'This app collects and monitors specific information about your device like device brand, model, OS and version, user profile information, Network and SIM Information, Mac Address for the device to ensure that customer identity is not compromised and we can prevent organized fraud. We do not collect any unique device identifiers like IMEI and serial number.',
              imagePath: ImageConstants.rotPermissionScreenDeviceMetaData,
            ),
            SizedBox(height: 16.0),
          ],
        ),
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
              checkColor: ColorConstant.whiteColor,
              activeColor: ColorConstant.appThemeColor,
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
                        color: ColorConstant.appThemeColor,
                        fontSize: FontConstants.f12,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontConstants.w800,
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
                        color: ColorConstant.appThemeColor,
                        fontSize: FontConstants.f12,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontConstants.w800,
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
