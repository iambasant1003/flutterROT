import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Cubit/dashboard_cubit/DashboardCubit.dart';
import 'package:rupeeontime/Cubit/dashboard_cubit/DashboardState.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../Constant/ColorConst/ColorConstant.dart';
import '../../Constant/FontConstant/FontConstant.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import '../../Routes/app_router_name.dart';
import '../../Utils/CleverTapEventsName.dart';
import '../../Utils/CleverTapLogger.dart';
import '../../Utils/MysharePrefenceClass.dart';
import '../../Utils/snackbarMassage.dart';
import '../../Widget/app_bar.dart';
import '../../Widget/common_button.dart';

class DashboardVerifyOTP extends StatefulWidget{
  const DashboardVerifyOTP({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardVerifyOTP();
}

class _DashboardVerifyOTP extends State<DashboardVerifyOTP>{


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
    CleverTapLogger.logEvent(CleverTapEventsName.DELETE_ACCOUNT_OTP_RESENT, isSuccess: true);
    context.read<DashboardCubit>().callDeleteCustomerProfileApi();
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
              BlocListener<DashboardCubit,DashboardState>(
                listenWhen: (prevState,currentState){
                  return prevState != currentState;
                },
                listener: (context,state){
                  if(state is DashBoardLoading){
                    EasyLoading.show(status: "Please wait...");
                  }else if(state is DeleteOTPVerified){
                    CleverTapLogger.logEvent(CleverTapEventsName.DELETE_ACCOUNT_OTP_VERIFY, isSuccess: true);
                    //openSnackBar(context, state.deleteProfileOTPVerifyModel.message??"",backGroundColor: ColorConstant.blackTextColor);
                    EasyLoading.dismiss();
                    MySharedPreferences.logOutFunctionData();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go(AppRouterName.login);
                    });
                  }else if(state is DeleteOTPFailed){
                    CleverTapLogger.logEvent(CleverTapEventsName.DELETE_ACCOUNT_OTP_VERIFY, isSuccess: false);
                    EasyLoading.dismiss();
                    openSnackBar(context, state.deleteProfileOTPVerifyModel.message ?? "Unexpected Error");
                  }
                  else if(state is DeleteCustomerSuccess){
                    EasyLoading.dismiss();
                    startTimer();
                  }
                  else if(state is DeleteCustomerFailed){
                    EasyLoading.dismiss();
                    openSnackBar(context, state.deleteCustomerModel.message ?? "Unexpected Error");
                  }
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 11.0,left: 16.0),
                        child: Loan112AppBar(
                          customLeading: InkWell(
                            child: Icon(Icons.arrow_back_ios,
                                color: ColorConstant.blackTextColor),
                            onTap: () {
                              GoRouter.of(context).pop();
                            },
                          ),
                          leadingSpacing: 15,
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
                                          context.read<DashboardCubit>().callCustomerProfileOTPVerify(otp.trim());
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
                              context.read<DashboardCubit>().callCustomerProfileOTPVerify(otpController.text.trim());
                            }else{
                              openSnackBar(context, "Please Enter OTP");
                            }
                          },
                          text: "Verify otp",
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

