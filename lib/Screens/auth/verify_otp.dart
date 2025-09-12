import 'dart:async';
import 'dart:convert';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Cubit/auth_cubit/AuthCubit.dart';
import 'package:loan112_app/Cubit/auth_cubit/AuthState.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Utils/CleverTapEventsName.dart';
import 'package:loan112_app/Utils/MysharePrefenceClass.dart';
import 'package:loan112_app/Utils/snackbarMassage.dart';
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
    otpController.dispose();
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
                child: Image.asset(
                  ImageConstants.logInScreenBackGround,
                  fit: BoxFit.cover,
                ),
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
                  child: SafeArea(
                   top: true,
                   bottom: true,
                   child: Column(
                     children: [
                       Padding(
                         padding: EdgeInsets.only(bottom: 11.0,left: 0.0),
                         child: Loan112AppBar(
                           customLeading: InkWell(
                             child: Icon(Icons.arrow_back_ios,
                                 color: ColorConstant.blackTextColor),
                             onTap: () {
                               GoRouter.of(context).pop();
                             },
                           ),
                           leadingSpacing: 30,
                           title: Image.asset(
                             ImageConstants.loan112AppNameIcon,
                             height: 76,
                             width: 76,
                           ),
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
                                 ImageConstants.verifyOTP,
                                 width: 200,
                                 height: 143,
                               ),
                               SizedBox(height: 40),
                               Text(
                                 "Verify OTP",
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
                                     "Please enter your OTP",
                                     style: TextStyle(
                                       color: ColorConstant.greyTextColor,
                                       fontSize: FontConstants.f16,
                                       fontFamily: FontConstants.fontFamily,
                                       fontWeight: FontConstants.w600,
                                     ),
                                   ),
                                   SizedBox(height: 12),
                                   Align(
                                     alignment: Alignment.centerLeft, // left align
                                     child: ConstrainedBox(
                                       constraints: BoxConstraints(maxWidth: (50 * 4) + (12 * 3)), // total width
                                       child: PinCodeTextField(
                                         appContext: context,
                                         length: 4,
                                         controller: otpController,
                                         onChanged: (value) {},
                                         keyboardType: TextInputType.number,
                                         pinTheme: PinTheme(
                                           shape: PinCodeFieldShape.box,
                                           borderRadius: BorderRadius.circular(8),
                                           fieldHeight: 50,
                                           fieldWidth: 50,
                                           activeColor: Colors.grey.shade400,
                                           inactiveColor: Colors.grey.shade300,
                                           selectedColor: Colors.blue.shade400,
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
                                     ),
                                   ),
                                   SizedBox(height: 30),
                                   _secondsRemaining > 0
                                       ? Row(
                                     children: [
                                       Text(
                                     "Resend OTP",
                                     style: TextStyle(
                                         fontFamily: FontConstants.fontFamily,
                                         fontSize: FontConstants.f14,
                                         fontWeight: FontConstants.w500,
                                         color: ColorConstant.blueTextColor
                                     ),
                                   ),
                                       SizedBox(
                                         width: 4.0,
                                       ),
                                       Text(
                                         "in ${_secondsRemaining}s",
                                         style: TextStyle(
                                             fontFamily: FontConstants.fontFamily,
                                             fontSize: FontConstants.f14,
                                             fontWeight: FontConstants.w500,
                                             color: ColorConstant.blackTextColor
                                         ),
                                       )
                                     ],
                                   )
                                       : Row(
                                     children: [
                                       GestureDetector(
                                         onTap: _resendOtp,
                                         child: Text(
                                           "Resend OTP",
                                           style: TextStyle(
                                               fontFamily: FontConstants.fontFamily,
                                               fontSize: FontConstants.f14,
                                               fontWeight: FontConstants.w800,
                                               color: ColorConstant.blueTextColor
                                           ),
                                         ),
                                       ),
                                       SizedBox(
                                         width: 4.0,
                                       ),
                                       Text(
                                         "You can now resend OTP",
                                         style: TextStyle(
                                             fontFamily: FontConstants.fontFamily,
                                             fontSize: FontConstants.f14,
                                             fontWeight: FontConstants.w700,
                                             color: ColorConstant.greyTextColor
                                         ),
                                       )
                                     ],
                                   ),
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
                 ),
              ),
            ],
          ),
        )
    );
  }

}

