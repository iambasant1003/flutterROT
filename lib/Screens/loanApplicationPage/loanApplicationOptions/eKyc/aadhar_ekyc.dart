
import 'dart:convert';
import 'dart:io';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:rupeeontime/Model/VerifyOTPModel.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/CleverTapEventsName.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/app_bar.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../Constant/ConstText/ConstText.dart';
import '../../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Utils/CleverTapLogger.dart';
import '../../../../Utils/MysharePrefenceClass.dart';

class AadharKycScreen extends StatefulWidget{
  const AadharKycScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AadharKycScreen();
}

class _AadharKycScreen extends State<AadharKycScreen>{

  TextEditingController adarOTPController = TextEditingController();
  bool reInitiate = false;


  /*
  getCustomerDetailsApiCall() async{
    context.read<DashboardCubit>().callDashBoardApi();
    var nodeOtpModel = await MySharedPreferences.getUserSessionDataNode();
    VerifyOTPModel verifyOTPModel = VerifyOTPModel.fromJson(jsonDecode(nodeOtpModel));
    var otpModel = await MySharedPreferences.getPhpOTPModel();
    SendPhpOTPModel sendPhpOTPModel = SendPhpOTPModel.fromJson(jsonDecode(otpModel));
    context.read<LoanApplicationCubit>().getCustomerDetailsApiCall({
      "cust_profile_id": sendPhpOTPModel.data?.custProfileId
    });
    context.read<LoanApplicationCubit>().getLeadIdApiCall({
      "custId": verifyOTPModel.data?.custId
    });
  }

   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoanApplicationCubit,LoanApplicationState>(
        listener: (context, state) {
          if (state is LoanApplicationLoading) {
            EasyLoading.show(status: "Please Wait...");
          }

          else if (state is CustomerKYCSuccess) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.EKYC_INITIATED, isSuccess: true);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;

              context.push(AppRouterName.customerKYCWebview, extra: state.customerKycModel.data?.url).then((val) async {
                var otpModel = await MySharedPreferences.getUserSessionDataNode();
                VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
                //var leadId = verifyOtpModel.data?.leadId ?? "";
                //if (leadId == "") {
                 var leadId = await MySharedPreferences.getLeadId();
               // }

                await Future.delayed(Duration(milliseconds: 300));
                if (!context.mounted) return;
                context.read<LoanApplicationCubit>().customerKycVerificationApiCall({
                  "custId": verifyOtpModel.data?.custId,
                  "leadId": leadId
                });
              });
            });
          }

          else if (state is CustomerKYCError) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.EKYC_INITIATED, isSuccess: false);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              openSnackBar(context, state.customerKycModel.message ?? "Unknown Error");
            });
          }

          else if (state is CustomerKYCVerificationSuccess) {
            CleverTapLogger.logEvent(CleverTapEventsName.EKYC_VERIFIED, isSuccess: true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              //context.pop();
              if(state.ekycVerificationModel.data?.ekycVerifiedFlag == 1){
                EasyLoading.dismiss();
                context.replace(AppRouterName.eKycMessageScreen);
              }
            });
          }

          else if (state is CustomerKYCVerificationError) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.EKYC_VERIFIED, isSuccess: false);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              openSnackBar(context, state.ekycVerificationModel.message ?? "Unknown Error");
              setState(() {
                reInitiate = true;
              });
            });
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                ImageConstants.logInScreenBackGround,
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Loan112AppBar(
                      customLeading: InkWell(
                        child: Icon(Icons.arrow_back_ios,color: ColorConstant.blackTextColor),
                        onTap: () async{
                          context.pop();
                          //await getCustomerDetailsApiCall();
                        },
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 24.0,
                              ),
                              Text(
                                "AADHAAR E-KYC",
                                style: TextStyle(
                                    fontSize: FontConstants.f20,
                                    fontWeight: FontConstants.w800,
                                    fontFamily: FontConstants.fontFamily,
                                    color: ColorConstant.blackTextColor
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                "Experience seamless authentication with advanced eKYC technology! Simply enter the last 4 digits of your Aadhaar—no need to share the full number.",
                                style: TextStyle(
                                    fontSize: FontConstants.f14,
                                    fontWeight: FontConstants.w500,
                                    fontFamily: FontConstants.fontFamily,
                                    color: ColorConstant.dashboardTextColor
                                ),
                              ),
                              SizedBox(
                                height: 56,
                              ),
                              Center(
                                child: Image.asset(
                                  ImageConstants.adarIcon,
                                  width: 220,
                                  height: 141,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: FontConstants.f14,
                                        fontFamily: FontConstants.fontFamily,
                                        fontWeight: FontConstants.w500
                                    ), // default style
                                    children: [
                                      TextSpan(
                                        text: 'Enter last 4 digit of your ',
                                        style: TextStyle(color: ColorConstant.dashboardTextColor),
                                      ),
                                      TextSpan(
                                        text: 'aadhaar',
                                        style: TextStyle(color: ColorConstant.errorRedColor, fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: ' number',
                                        style: TextStyle(color: ColorConstant.dashboardTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: (50 * 4) + (12 * 3)), // total width
                                  child: PinCodeTextField(
                                    appContext: context,
                                    length: 4,
                                    controller: adarOTPController,
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
                                    onCompleted: (aadHarNumber) {
                                      // This is called when all 4 digits are entered
                                    },
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // << key
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                              Center(
                                child: Image.asset(ImageConstants.digiLockerIcon,width: 150,height: 36),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child:  SizedBox(
                        height: 134,
                        child: Column(
                          children: [
                            BottomDashLine(),
                            SizedBox(
                              height: 24.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: FontConstants.horizontalPadding,
                              ),
                              child: Column(
                                children: [
                                  Loan112Button(
                                    onPressed: () async {
                                      if (adarOTPController.text.trim() != "" && adarOTPController.text.trim().length == 4) {
                                        var otpModel = await MySharedPreferences.getUserSessionDataNode();
                                        VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
                                        //var leadId = verifyOtpModel.data?.leadId ?? "";
                                        //if (leadId == "") {
                                         var leadId = await MySharedPreferences.getLeadId();
                                       // }

                                        context.read<LoanApplicationCubit>().customerKycApiCall({
                                          "custId": verifyOtpModel.data?.custId,
                                          "leadId": leadId,
                                          "requestSource": Platform.isIOS?
                                              ConstText.requestSourceIOS:
                                          ConstText.requestSource,
                                          "aadharNo": adarOTPController.text.trim(),
                                          "type": 1
                                        });
                                      } else {
                                        openSnackBar(context, "Please Enter last 4 digit of your aadhar number");
                                      }
                                    },
                                    text: reInitiate ? "Reinitiate" : "Get Started",
                                  ),
                                  /*
                  Loan112Button(
                      onPressed: () async{
                        if(adarOTPController.text.trim() != "" && adarOTPController.text.trim().length == 4){
                          var otpModel = await MySharedPreferences.getUserSessionDataNode();
                          VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
                          var leadId = verifyOtpModel.data?.leadId ?? "";
                          if(leadId == ""){
                            leadId =  await MySharedPreferences.getLeadId();
                          }
                          context.read<LoanApplicationCubit>().customerKycApiCall({
                              "custId":verifyOtpModel.data?.custId,
                              "leadId": leadId,
                              "requestSource": Platform.isIOS?ConstText.requestSourceIOS:
                              ConstText.requestSource,,
                              "aadharNo":adarOTPController.text.trim(),
                              "type":1
                          });
                        }else{
                          openSnackBar(context, "Please Enter last 4 digit of your aadhar number");
                        }
                      },
                      text: "Get Started"
                  ),
                   */
                                  SizedBox(
                                    height: 24.0,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: (){
                                        context.push(AppRouterName.customerSupport);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Need  Help..?",
                                            style: TextStyle(
                                                color: Color(0xff2B3C74),
                                                fontSize: FontConstants.f14,
                                                fontWeight: FontConstants.w600,
                                                fontFamily: FontConstants.fontFamily
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            "contact us",
                                            style: TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: FontConstants.f14,
                                                fontWeight: FontConstants.w600,
                                                fontFamily: FontConstants.fontFamily
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
      /*
      bottomNavigationBar: SafeArea(
        child:  SizedBox(
          height: 124,
          child: Column(
            children: [
              BottomDashLine(),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: FontConstants.horizontalPadding,
                ),
                child: Column(
                  children: [
                    Loan112Button(
                      onPressed: () async {
                        if (adarOTPController.text.trim() != "" && adarOTPController.text.trim().length == 4) {
                          var otpModel = await MySharedPreferences.getUserSessionDataNode();
                          VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
                          var leadId = verifyOtpModel.data?.leadId ?? "";
                          if (leadId == "") {
                            leadId = await MySharedPreferences.getLeadId();
                          }

                          context.read<LoanApplicationCubit>().customerKycApiCall({
                            "custId": verifyOtpModel.data?.custId,
                            "leadId": leadId,
                            "requestSource": ConstText.requestSource,
                            "aadharNo": adarOTPController.text.trim(),
                            "type": 1
                          });
                        } else {
                          openSnackBar(context, "Please Enter last 4 digit of your aadhar number");
                        }
                      },
                      text: reInitiate ? "Reinitiate" : "Get Started",
                    ),
                    /*
                  Loan112Button(
                      onPressed: () async{
                        if(adarOTPController.text.trim() != "" && adarOTPController.text.trim().length == 4){
                          var otpModel = await MySharedPreferences.getUserSessionDataNode();
                          VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
                          var leadId = verifyOtpModel.data?.leadId ?? "";
                          if(leadId == ""){
                            leadId =  await MySharedPreferences.getLeadId();
                          }
                          context.read<LoanApplicationCubit>().customerKycApiCall({
                              "custId":verifyOtpModel.data?.custId,
                              "leadId": leadId,
                              "requestSource": Platform.isIOS?ConstText.requestSourceIOS:
                              ConstText.requestSource,,
                              "aadharNo":adarOTPController.text.trim(),
                              "type":1
                          });
                        }else{
                          openSnackBar(context, "Please Enter last 4 digit of your aadhar number");
                        }
                      },
                      text: "Get Started"
                  ),
                   */
                    SizedBox(
                      height: 8.0,
                    ),
                    Center(
                      child: InkWell(
                        onTap: (){
                          context.push(AppRouterName.customerSupport);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Need  Help..?",
                              style: TextStyle(
                                  color: Color(0xff2B3C74),
                                  fontSize: FontConstants.f14,
                                  fontWeight: FontConstants.w600,
                                  fontFamily: FontConstants.fontFamily
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "contact us",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: FontConstants.f14,
                                  fontWeight: FontConstants.w600,
                                  fontFamily: FontConstants.fontFamily
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )

       */
    );
  }

}









