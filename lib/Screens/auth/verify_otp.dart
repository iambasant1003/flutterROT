import 'dart:async';
import 'dart:convert';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Cubit/auth_cubit/AuthCubit.dart';
import 'package:rupeeontime/Cubit/auth_cubit/AuthState.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/CleverTapEventsName.dart';
import 'package:rupeeontime/Utils/MysharePrefenceClass.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../Constant/ColorConst/ColorConstant.dart';
import '../../Constant/FontConstant/FontConstant.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import '../../Utils/CleverTapLogger.dart';
import '../../Widget/app_bar.dart';
import '../../Widget/common_button.dart';

class VerifyOTP extends StatefulWidget{
  final String mobileNumber;
  const VerifyOTP({super.key,required this.mobileNumber});


  @override
  State<StatefulWidget> createState() => _VerifyOTP();
}

class _VerifyOTP extends State<VerifyOTP>{

  TextEditingController otpController = TextEditingController();
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  void _resendOtp() {
    CleverTapLogger.logEvent(CleverTapEventsName.OTP_RESENT, isSuccess: true);
    context.read<AuthCubit>().sendBothOtp(widget.mobileNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SizedBox.expand(
          child: Stack(
            children: [
              /// Background image
              Positioned.fill(
                child: Container(
                  color: ColorConstant.appThemeColor,
                )
              ),

              /// Form + Button
              BlocListener<AuthCubit,AuthState>(
                 listenWhen: (prevState,currentState){
                   return prevState != currentState;
                 },
                  listener: (context,state){
                    if(state is AuthLoading){
                      EasyLoading.show(status: "Please Wait");
                    } else if(state is AuthPhpSuccess){
                      //EasyLoading.dismiss();
                      MySharedPreferences.setPhpOTPModel(jsonEncode(state.data));
                    } else if(state is AuthNodeSuccess){
                      EasyLoading.dismiss();
                      startTimer();
                    }
                    if(state is VerifyOtpLoading){
                      EasyLoading.show(status: "Please Wait");
                    }else if(state is VerifyPhpOTPSuccess){
                      //EasyLoading.dismiss();
                      MySharedPreferences.setUserSessionDataPhp(jsonEncode(state.data));
                      context.read<AuthCubit>().verifyOtpNode(widget.mobileNumber,otpController.text.trim());
                    } else if(state is VerifyOTPSuccess){
                      EasyLoading.dismiss();
                      MySharedPreferences.setUserSessionDataNode(jsonEncode(state.verifyOTPModel));
                      CleverTapLogger.logEvent(CleverTapEventsName.OTP_VERIFY, isSuccess: true);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          context.push(AppRouterName.dashboardPage);
                        }
                      });
                    }else if(state is AuthError){
                      EasyLoading.dismiss();
                      CleverTapLogger.logEvent(CleverTapEventsName.OTP_VERIFY, isSuccess: false);
                      openSnackBar(context, state.message);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 59.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorConstant.whiteColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(54.0),
                            topLeft:  Radius.circular(54.0),
                          )
                      ),
                      child: SafeArea(
                        top: true,
                        bottom: true,
                        child: Column(
                          children: [
                            /// Scrollable form content
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 69.0),
                                    Image.asset(
                                      ImageConstants.rotVerifyOTPIcon,
                                      width: 52,
                                      height: 52,
                                    ),
                                    SizedBox(height: 32),
                                    Text(
                                      "Enter the OTP",
                                      style: TextStyle(
                                        fontSize: FontConstants.f24,
                                        fontWeight: FontConstants.w700,
                                        fontFamily: FontConstants.fontFamily,
                                        color: ColorConstant.blackTextColor,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "One step left — enter your OTP to continue",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xff0A6075),
                                            fontSize: FontConstants.f16,
                                            fontFamily: FontConstants.fontFamily,
                                            fontWeight: FontConstants.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "+91-${widget.mobileNumber}",
                                              style: TextStyle(
                                                  fontFamily: FontConstants.fontFamily,
                                                  fontSize: FontConstants.f20,
                                                  fontWeight: FontConstants.w700,
                                                  color: ColorConstant.appThemeColor
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            InkWell(
                                              onTap: (){
                                                otpController.clear();  // remove value
                                                FocusScope.of(context).unfocus(); // close keyboard if open
                                                context.pop();
                                              },
                                              child: Image.asset(
                                                ImageConstants.rotEditMobileNumber,
                                                height: 17,
                                                width: 17,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        PinCodeTextField(
                                          appContext: context,
                                          length: 4,
                                          controller: otpController,
                                          onChanged: (value) {},
                                          keyboardType: TextInputType.number,
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderRadius: BorderRadius.circular(8),
                                            fieldHeight: 52,
                                            fieldWidth: 52,
                                            activeColor: Colors.grey.shade400,
                                            inactiveColor: Colors.grey.shade300,
                                            selectedColor: ColorConstant.appThemeColor,
                                            activeFillColor: Colors.white,
                                            inactiveFillColor: Colors.white,
                                            selectedFillColor: Colors.white,
                                            borderWidth: 1,
                                          ),
                                          cursorColor: Colors.blue,
                                          animationType: AnimationType.fade,
                                          enableActiveFill: true,
                                          onCompleted: (otp) {
                                            // This is called when all 4 digits are entered
                                            debugPrint("OTP entered: $otp");
                                            context.read<AuthCubit>().verifyOtpPhp(widget.mobileNumber,otp.trim());
                                          },
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // << key
                                        ),
                                        SizedBox(height: 20),
                                        _secondsRemaining > 0?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "OTP Will Expire",
                                              style: TextStyle(
                                                color: ColorConstant.greyTextColor,
                                                fontSize: FontConstants.f14,
                                                fontFamily: FontConstants.fontFamily,
                                                fontWeight: FontConstants.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Text(
                                              "00:$_secondsRemaining",
                                              style: TextStyle(
                                                  fontFamily: FontConstants.fontFamily,
                                                  fontSize: FontConstants.f14,
                                                  fontWeight: FontConstants.w800,
                                                  color: ColorConstant.blueTextColor
                                              ),
                                            ),
                                          ],
                                        ):
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Didn’t receive a Code?",
                                              style: TextStyle(
                                                  fontFamily: FontConstants.fontFamily,
                                                  fontSize: FontConstants.f14,
                                                  fontWeight: FontConstants.w700,
                                                  color: ColorConstant.greyTextColor
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.0,
                                            ),
                                            GestureDetector(
                                              onTap: _resendOtp,
                                              child: Text(
                                                "Resend Code!",
                                                style: TextStyle(
                                                    fontFamily: FontConstants.fontFamily,
                                                    fontSize: FontConstants.f14,
                                                    fontWeight: FontConstants.w800,
                                                    color: ColorConstant.blueTextColor
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 265,
                                          child: Loan112Button(
                                            onPressed: () {
                                              if(otpController.text.trim() != ""){
                                                context.read<AuthCubit>().verifyOtpPhp(widget.mobileNumber,otpController.text.trim());
                                              }else{
                                                openSnackBar(context, "Please Enter OTP");
                                              }
                                            },
                                            text: "Verify otp".toUpperCase(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /// Button pinned at bottom
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
            ],
          ),
        )
    );
  }

}

