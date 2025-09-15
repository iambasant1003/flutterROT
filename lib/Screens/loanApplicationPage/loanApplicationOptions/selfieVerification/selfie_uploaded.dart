import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ConstText/ConstText.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import '../../../../Constant/ColorConst/ColorConstant.dart';
import '../../../../Constant/FontConstant/FontConstant.dart';
import '../../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Cubit/loan_application_cubit/LoanApplicationState.dart';
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Model/VerifyOTPModel.dart';
import '../../../../Utils/CleverTapEventsName.dart';
import '../../../../Utils/CleverTapLogger.dart';
import '../../../../Utils/MysharePrefenceClass.dart';
import '../../../../Widget/app_bar.dart';
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';

class SelfieUploadedPage extends StatefulWidget {
  final String imagePath;

  const SelfieUploadedPage({super.key, required this.imagePath});

  @override
  State<StatefulWidget> createState() => _SelfieUploadedPage();
}

class _SelfieUploadedPage extends State<SelfieUploadedPage> {


  /*
  getCustomerDetailsApiCall() async {
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


  bool _isActive = true;

  @override
  void dispose() {
    _isActive = false;
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoanApplicationCubit, LoanApplicationState>(
        listenWhen: (prev, current) {
          return prev != current;
        },
        listener: (context, state) {
          if (!mounted) return;

          if (state is LoanApplicationLoading) {
            EasyLoading.show(status: "Please Wait...");
          } else if (state is UploadSelfieSuccess) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.SELFIE_UPLOAD, isSuccess: true);

            Future(() async{
              if (!_isActive) return;

              openSnackBar(
                context,
                state.uploadSelfieModel.message ??
                    "Selfie uploaded successfully",
                backGroundColor: ColorConstant.appThemeColor,
              );
              if((state.uploadSelfieModel.data?.decision ?? "").toLowerCase() == "repeat" &&
                  (state.uploadSelfieModel.data?.checkKycFlag ?? true) == false
              ){
                await MySharedPreferences.setEnhanceKey("0");
              }else{
                await MySharedPreferences.setEnhanceKey("0");
              }
              if((state.uploadSelfieModel.data?.loanAmount ?? 0)>0
                  && (state.uploadSelfieModel.data?.decision ?? "").toLowerCase() == "approve"){
                var enhanceKey = await MySharedPreferences.getEnhanceKey();
                context.pop();
                context.push(AppRouterName.loanOfferPage,extra: int.parse(enhanceKey));
              }else{
                CleverTapLogger.logEvent(CleverTapEventsName.CHECK_ELIGIBILITY_SYSTEM, isSuccess: true);
                context.replace(
                  AppRouterName.eligibilityStatus,
                  extra: state.uploadSelfieModel,
                );
              }
            });

          } else if (state is UploadSelfieError) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.SELFIE_UPLOAD, isSuccess: false);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_isActive) return;

              if (state.uploadSelfieModel.statusCode == 402) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!_isActive) return;
                  context.replace(
                    AppRouterName.eligibilityStatus,
                    extra: state.uploadSelfieModel,
                  );
                });
              }
              else if (state.uploadSelfieModel.message?.toLowerCase() == "already done") {
                if(!_isActive) return;
                openSnackBar(context, state.uploadSelfieModel.message ?? "Already done");
              }
              else {
                DebugPrint.prt("");
                context.replace(
                  AppRouterName.selfieScreenPath,
                );
                openSnackBar(
                  context,
                  state.uploadSelfieModel.message ?? "Unknown Error",
                );
              }
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
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstant.blackTextColor,
                      ),
                      onTap: () async{
                        context.pop();
                        //await getCustomerDetailsApiCall();
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: FontConstants.horizontalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24.0),
                            Text(
                              "Selfie Uploaded",
                              style: TextStyle(
                                fontSize: FontConstants.f20,
                                fontWeight: FontConstants.w800,
                                fontFamily: FontConstants.fontFamily,
                                color: ColorConstant.blackTextColor,
                              ),
                            ),
                            SizedBox(height: 63),
                            /*
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: SizedBox(
                                    height: 245,
                                    width: 245,
                                    child: Image.file(
                                      File(widget.imagePath),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                           */
                            Center(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0), // Optional rounded edges
                                  child: Image.file(
                                    File(widget.imagePath),
                                    fit: BoxFit.cover, // ✅ SHOW FULL IMAGE
                                    width: 245,
                                    height: 245,
                                  )
                              ),
                            ),
                            SizedBox(height: 43),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  context.replace(
                                    AppRouterName.selfieScreenPath,
                                  );
                                },
                                child: Text(
                                  "RECAPTURE",
                                  style: TextStyle(
                                    fontSize: FontConstants.f18,
                                    fontWeight: FontConstants.w700,
                                    fontFamily: FontConstants.fontFamily,
                                    color: ColorConstant.appThemeColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  height: 1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  color: ColorConstant.dashboardTextColor,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "OR",
                                  style: TextStyle(
                                    fontSize: FontConstants.f14,
                                    fontWeight: FontConstants.w700,
                                    fontFamily: FontConstants.fontFamily,
                                    color: ColorConstant.blackTextColor,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  height: 1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  color: ColorConstant.dashboardTextColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Loan112Button(
                              onPressed: () async {
                                var imagePathConverted = await convertToJpeg(
                                  widget.imagePath,
                                );
                                DebugPrint.prt(
                                  "Image Path ${imagePathConverted.path}",
                                );
                                var otpModel =
                                    await MySharedPreferences.getUserSessionDataNode();
                                VerifyOTPModel verifyOtpModel =
                                    VerifyOTPModel.fromJson(
                                      jsonDecode(otpModel),
                                    );

                                var customerId = verifyOtpModel.data?.custId;
                                //var leadId = verifyOtpModel.data?.leadId;
                               // if (leadId == "" || leadId == null) {
                                var  leadId =
                                      await MySharedPreferences.getLeadId();
                               // }

                                final formData = FormData();

                                // Add text parts
                                formData.fields
                                  ..add(MapEntry('custId', customerId ?? ""))
                                  ..add(MapEntry('leadId', leadId))
                                  ..add(
                                    MapEntry(
                                      'requestSource',
                                      Platform.isIOS?
                                      ConstText.requestSourceIOS:
                                      ConstText.requestSource,
                                    ),
                                  );

                                // Prepare file part
                                final file = File(imagePathConverted.path);

                                if (!await file.exists()) {
                                  throw Exception(
                                    'File does not exist at ${file.path}',
                                  );
                                }

                                final fileName = file.uri.pathSegments.last;
                                final fileExtension = fileName
                                    .split('.')
                                    .last
                                    .toLowerCase();

                                String? mimeType;
                                if (fileExtension == 'jpg' ||
                                    fileExtension == 'jpeg') {
                                  mimeType = 'image/jpeg';
                                } else if (fileExtension == 'pdf') {
                                  mimeType = 'application/pdf';
                                } else {
                                  throw Exception(
                                    'Unsupported file type: $fileExtension',
                                  );
                                }

                                final multipartFile =
                                    await MultipartFile.fromFile(
                                      file.path,
                                      filename: fileName,
                                      contentType: MediaType.parse(mimeType),
                                    );

                                formData.files.add(
                                  MapEntry('selfie', multipartFile),
                                );

                                context
                                    .read<LoanApplicationCubit>()
                                    .uploadSelfieApiCall(formData);
                              },
                              text: "CONTINUE",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> convertToJpeg(String inputPath, {int quality = 90}) async {
    final file = File(inputPath);

    // Read the original image
    final bytes = await file.readAsBytes();
    final originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception("Failed to decode image");
    }

    // Encode as JPEG
    final jpegBytes = img.encodeJpg(originalImage, quality: quality);

    // Save to a new file
    final outputPath = inputPath.replaceAll(RegExp(r'\.\w+$'), '.jpeg');
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(jpegBytes);

    return outputFile;
  }


}
