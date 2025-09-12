

import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Utils/Debugprint.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../Constant/ColorConst/ColorConstant.dart';
import '../../../../Constant/FontConstant/FontConstant.dart';
import '../../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Model/VerifyOTPModel.dart';
import '../../../../Utils/MysharePrefenceClass.dart';
import '../../../../Widget/app_bar.dart';
import 'package:image/image.dart' as img;

import 'fullscreen_camera.dart';


class SelfieCameraPage extends StatefulWidget {
  const SelfieCameraPage({super.key});

  @override
  State<SelfieCameraPage> createState() => _SelfieCameraPageState();
}

class _SelfieCameraPageState extends State<SelfieCameraPage> with WidgetsBindingObserver{

  File? imagePath;
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
      body: Stack(
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
                              "Selfie Verification",
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
                              "Please keep your face in center to click your perfect photo.",
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
                            SizedBox(
                              height: 300,
                              child: GestureDetector(
                                onTap: () async{
                                  final imagePath = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const FullScreenCameraPage()),
                                  );

                                  if (imagePath != null) {
                                    context.replace(AppRouterName.selfieUploadedPage, extra: imagePath);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(ImageConstants.selfieImageIcon),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: FontConstants.horizontalPadding),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Note:-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: FontConstants.f14,
                                        fontWeight: FontConstants.w500,
                                        fontFamily: FontConstants.fontFamily,
                                        color: ColorConstant.dashboardTextColor
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Please remove spectacle & cap before capturing your selfie.",
                                      //textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: FontConstants.f14,
                                          fontWeight: FontConstants.w500,
                                          fontFamily: FontConstants.fontFamily,
                                          color: ColorConstant.dashboardTextColor
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Text(
                                "Click your selfie",
                                style: TextStyle(
                                  fontSize: FontConstants.f14,
                                  fontWeight: FontConstants.w700,
                                  fontFamily: FontConstants.fontFamily,
                                  color: ColorConstant.blackTextColor
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  final imagePath = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const FullScreenCameraPage()),
                                  );

                                  if (imagePath != null) {
                                    context.replace(AppRouterName.selfieUploadedPage, extra: imagePath);
                                  }
                                },
                                child: Container(
                                  width: 80,  // adjust size as needed
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black54, // or any color you like
                                      width: 2.0,           // thickness of border
                                    ),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }



}
