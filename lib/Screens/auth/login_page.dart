

import 'dart:convert';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Constant/ColorConst/ColorConstant.dart';
import 'package:loan112_app/Constant/ImageConstant/ImageConstants.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Utils/Debugprint.dart';
import 'package:loan112_app/Utils/MysharePrefenceClass.dart';
import 'package:loan112_app/Utils/snackbarMassage.dart';
import 'package:loan112_app/Utils/validation.dart';
import 'package:loan112_app/Widget/common_system_ui.dart';
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
                  child: Image.asset(
                    ImageConstants.logInScreenBackGround,
                    fit: BoxFit.cover,
                  ),
                ),

                /// Form + Button
                SafeArea(
                  bottom: true,
                  top: true,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                ImageConstants.loan112AppNameIcon,
                                height: 76,
                                width: 76,
                              ),
                            ],
                          ),
                        ),
                        /// Scrollable form content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 48.0),
                                Image.asset(
                                  ImageConstants.logInPageIcon,
                                  width: 200,
                                  height: 143,
                                ),
                                SizedBox(height: 40),
                                Text(
                                  "To Register / Login your Account",
                                  style: TextStyle(
                                    fontSize: FontConstants.f20,
                                    fontWeight: FontConstants.w800,
                                    fontFamily: FontConstants.fontFamily,
                                    color: ColorConstant.blackTextColor,
                                  ),
                                ),
                                SizedBox(height: 43),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Please enter your Mobile number",
                                      style: TextStyle(
                                        color: ColorConstant.greyTextColor,
                                        fontSize: FontConstants.f16,
                                        fontFamily: FontConstants.fontFamily,
                                        fontWeight: FontConstants.w600,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: CommonTextField(
                                            controller: mobileController,
                                            hintText: "Enter your Mobile number",
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
                                            onEditingComplete: (){
                                              mobileNumberToPass = mobileController.text.trim();
                                            },
                                            onChanged: (val) {
                                              print("Value is Changing");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20), // space before button
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// Button pinned at bottom
                        Padding(
                          padding: EdgeInsets.all(FontConstants.horizontalPadding),
                          child: Loan112Button(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
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
                            text: "LOGIN",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

}


