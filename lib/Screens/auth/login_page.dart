

import 'dart:convert';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/MysharePrefenceClass.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Utils/validation.dart';
import 'package:rupeeontime/Widget/common_system_ui.dart';
import '../../Constant/ApiUrlConstant/WebviewUrl.dart';
import '../../Constant/FontConstant/FontConstant.dart';
import '../../Cubit/auth_cubit/AuthCubit.dart';
import '../../Cubit/auth_cubit/AuthState.dart';
import '../../Utils/CleverTapEventsName.dart';
import '../../Utils/CleverTapLogger.dart';
import '../../Widget/common_button.dart';
import '../../Widget/common_textField.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool termAndCondition = false;

  TextEditingController mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String mobileNumberToPass = "";


  @override
  Widget build(BuildContext context) {
    return Loan112SystemUi(
      child: Scaffold(
          body: BlocListener<AuthCubit, AuthState>(
            listenWhen: (prev,current){
              return prev != current;
            },
            listener: (BuildContext context, state) {

              if (ModalRoute.of(context)?.isCurrent != true) return;

              if(state is AuthLoading){
                EasyLoading.show(status: "Please Wait");
              } else if(state is AuthPhpSuccess){
                //EasyLoading.dismiss();
                MySharedPreferences.setPhpOTPModel(jsonEncode(state.data));
              } else if(state is AuthNodeSuccess){
                DebugPrint.prt("Navigation Logic Called To OTP");
                EasyLoading.dismiss();
                mobileController.clear();
                CleverTapLogger.logEvent(CleverTapEventsName.OTP_SENT, isSuccess: true);
                context.push(AppRouterName.verifyOtp,extra: mobileNumberToPass);
              }else if(state is AuthError){
                EasyLoading.dismiss();
                CleverTapLogger.logEvent(CleverTapEventsName.OTP_SENT, isSuccess: false);
                openSnackBar(context, state.message);
              }
            },
            child: Stack(
              children: [
                /// Background image
                Positioned.fill(
                  child: Container(
                    color: ColorConstant.appThemeColor,
                  )
                ),

                /// Form + Button
                SafeArea(
                  top: true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.whiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(54.0),
                        topLeft:  Radius.circular(54.0),
                      )
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          /// Scrollable form content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 59),
                                  Text(
                                    "Log In / Sign Up Your Account",
                                    style: TextStyle(
                                      fontSize: FontConstants.f20,
                                      fontWeight: FontConstants.w800,
                                      fontFamily: FontConstants.fontFamily,
                                      color: ColorConstant.blackTextColor,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Please enter your Mobile number",
                                        style: TextStyle(
                                          color: ColorConstant.appThemeColor,
                                          fontSize: FontConstants.f16,
                                          fontFamily: FontConstants.fontFamily,
                                          fontWeight: FontConstants.w500,
                                        ),
                                      ),
                                      SizedBox(height: 24.0),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: CommonTextField(
                                              hintStyle: TextStyle(
                                                fontSize: FontConstants.f20,
                                                fontWeight: FontWeight.w200,
                                                color: Color(0xffAEAEAE),
                                                letterSpacing: 6
                                              ),
                                              textStyle: TextStyle(
                                                  fontSize: FontConstants.f20,
                                                  fontWeight: FontWeight.w200,
                                                  letterSpacing: 2
                                              ),
                                              controller: mobileController,
                                              hintText: "XXXXXXXXXX",
                                              maxLength: 10,
                                              //keyboardType: TextInputType.phone,
                                              //textInputAction: TextInputAction.done,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                              textInputAction: TextInputAction.done,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                              ],
                                              validator: (value) {
                                                return validateMobileNumber(value);
                                              },
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus(); // hide keyboard
                                                mobileNumberToPass = mobileController.text.trim();
                                              },
                                              onChanged: (val) {
                                                print("Value is Changing");
                                              },
                                              leadingWidget: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                 Padding(
                                                   padding: EdgeInsets.only(left: FontConstants.horizontalPadding),
                                                   child:  Image.asset(
                                                     ImageConstants.rotIndianFlag,
                                                     height: 24,
                                                     width: 24,
                                                   ),
                                                 ),
                                                  const SizedBox(width: 6),
                                                   Padding(
                                                    padding: EdgeInsets.only(right: FontConstants.horizontalPadding),
                                                    child: Text(
                                                      "+91",
                                                      style: TextStyle(
                                                        fontSize: FontConstants.f20,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: FontConstants.fontFamily
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                                  /*
                                              Padding(
                                                padding: EdgeInsets.only(left: 20.0),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      ImageConstants.rotIndianFlag,
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "+91-",
                                                      style: TextStyle(
                                                          fontSize: FontConstants.f20,
                                                          fontWeight: FontConstants.w500,
                                                          fontFamily: FontConstants.fontFamily,
                                                          color: ColorConstant.blackTextColor
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),

                                                   */
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 24.0), // space before button
                                      consentBoxUI(context),
                                      SizedBox(height: 24.0), // space before button
                                      BlocBuilder<AuthCubit, AuthState>(
                                        builder: (context,state){

                                          final authCubit = context.read<AuthCubit>();
                                          bool checked = authCubit.isPermissionGiven;

                                          if (state is PermissionCheckboxState) {
                                            checked = state.isChecked;
                                          }
                                          return Center(
                                            child: SizedBox(
                                              width: 265,
                                              child: Loan112Button(
                                                onPressed: () {
                                                  if(!checked){
                                                    openSnackBar(context,
                                                        "Please accept our Terms & Conditions and Privacy Policy.");
                                                  }
                                                  else if(_formKey.currentState!.validate()){
                                                    mobileNumberToPass = mobileController.text.trim();
                                                    final phone = mobileController.text.trim();
                                                    if (phone.isNotEmpty) {
                                                      DebugPrint.prt("LogIn Method Called $phone");
                                                      CleverTapPlugin.onUserLogin({
                                                        'Identity': phone,
                                                      });
                                                      context.read<AuthCubit>().sendBothOtp(phone);
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text("Enter phone number")),
                                                      );
                                                    }
                                                  }
                                                },
                                                text: "Get OTP",
                                                fontSize: FontConstants.f16,
                                                fontWeight: FontConstants.w700,
                                                fontFamily: FontConstants.fontFamily,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// Button pinned at bottom
                          Image.asset(
                              ImageConstants.rotLogInBoyImage
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 10,
            color: ColorConstant.whiteColor,
          ),
      ),
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
            CheckboxTheme(
              data: CheckboxThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1.0, // 👈 custom border width
                  ),
                ),
              ),
              child: Checkbox(
                value: checked,
                checkColor: ColorConstant.whiteColor,
                activeColor: ColorConstant.appThemeColor,
                onChanged: (val) {
                  context.read<AuthCubit>().toggleCheckbox(val);
                },
              ),
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
                    fontWeight: FontConstants.w600,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: ColorConstant.appThemeColor,
                        fontSize: FontConstants.f14,
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
                        fontWeight: FontConstants.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: ColorConstant.appThemeColor,
                        fontSize: FontConstants.f14,
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
                        fontWeight: FontConstants.w600,
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


