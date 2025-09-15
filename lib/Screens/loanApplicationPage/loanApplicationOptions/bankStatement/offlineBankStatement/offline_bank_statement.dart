


import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ConstText/ConstText.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/common_textField.dart';
import 'package:widgets_easier/widgets_easier.dart';
import '../../../../../Constant/ColorConst/ColorConstant.dart';
import '../../../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../../../Cubit/UploadBankStatementStatusCubit.dart';
import '../../../../../Model/VerifyOTPModel.dart';
import '../../../../../Routes/app_router_name.dart';
import '../../../../../Utils/CleverTapEventsName.dart';
import '../../../../../Utils/CleverTapLogger.dart';
import '../../../../../Utils/MysharePrefenceClass.dart';
import '../../../../../Widget/app_bar.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';


class FetchOfflineBankStatement extends StatefulWidget{
  const FetchOfflineBankStatement({super.key});

  @override
  State<StatefulWidget> createState() => _FetchOfflineBankStatement();
}

class _FetchOfflineBankStatement extends State<FetchOfflineBankStatement>{

  List<String> bankStatementInstruction = [
    "Maximum 2 MB file size allowed.",
    "Only pdf files allowed.",
    "Provide the latest 3 months' bank statements.",
    "Upload only salaried account bank statement pdf file."
  ];

  bool passWordVisible = false;
  Uint8List? pdfBytes;
  bool needsPassword = false;
  String? passwordError;
  String? fileNamePath;
  String? fileSize;
  String? fileName;

  final TextEditingController _passwordController = TextEditingController();


  Future<void> _pickPdf() async {
    setState(() {
      needsPassword = false;
      passwordError = null;
      pdfBytes = null;
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    DebugPrint.prt("Pdf bytes file choosen ${result?.files.single.bytes}");

    if (result != null && result.files.single.bytes != null) {
      pdfBytes = result.files.single.bytes!;
      fileNamePath = result.files.single.path;
      fileName = result.files.single.name;
      fileSize = (result.files.single.size / 1024).toStringAsFixed(1);
      _checkPdf();
    }
  }

  Future<bool> _checkPdf({String? password}) async {
    try {
      // Try to load PDF
      PdfDocument(
        inputBytes: pdfBytes!,
        password: password,
      );
      DebugPrint.prt("Pdf Loaded Successfully");

      setState(() {
        needsPassword = false;
        passwordError = null;
      });

      return true; // ✅ verified

    } catch (e) {
      DebugPrint.prt("Exception occurred $e");
      if (e.toString().contains('password')) {
        // Password is required or incorrect
        setState(() {
          needsPassword = true;
          if (password != null && password.isNotEmpty) {
            passwordError = 'Incorrect password';
          } else {
            passwordError = null; // just ask for password
          }
        });
        DebugPrint.prt("Need Password $needsPassword, $passwordError");
      } else {
        // Some other PDF error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open PDF: ${e.toString()}')),
        );
      }

      return false; // ❌ failed
    }
  }




  @override
  void initState() {
    super.initState();
    context.read<UploadBankStatementStatusCubit>().hideSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoanApplicationCubit,LoanApplicationState>(
      listener: (context, state) {
        if (!context.mounted) return; // safeguard for unmounted context

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is LoanApplicationLoading) {
            EasyLoading.show(status: "Please wait...");
          } else if (state is UploadBankStatementSuccess) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.DOCUMENTATION_BANK_STATEMENT, isSuccess: true);
            context.read<UploadBankStatementStatusCubit>().showSuccess();
            Future.delayed(const Duration(seconds: 1), () {
              context.replace(
                AppRouterName.bankStatementAnalyzer,
                extra: state.uploadBankStatementModel.data?.timerVal,
              );
            });
          } else if (state is UploadBankStatementFailed) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.DOCUMENTATION_BANK_STATEMENT, isSuccess: false);
            DebugPrint.prt("Upload Bank Statement Failed");
            openSnackBar(context, state.uploadBankStatementModel.message ?? "Failed");
          }
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              ImageConstants.logInScreenBackGround,
              fit: BoxFit.cover,
            ),
          ),

          /// Form + Button
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Loan112AppBar(
                    customLeading: InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstant.blackTextColor,
                      ),
                    ),
                    leadingSpacing: 30,
                    title: Image.asset(
                      ImageConstants.loan112AppNameIcon,
                      height: 76,
                      width: 76,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bank Statement",
                          style: TextStyle(
                            fontSize: FontConstants.f20,
                            fontWeight: FontConstants.w800,
                            fontFamily: FontConstants.fontFamily,
                            color: ColorConstant.blackTextColor,
                          ),
                        ),
                        SizedBox(
                            height: 12.0
                        ),
                        Text(
                          "Please provide your latest bank statement.",
                          style: TextStyle(
                            fontSize: FontConstants.f14,
                            fontFamily: FontConstants.fontFamily,
                            fontWeight: FontConstants.w500,
                            color: Color(0xff344054),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: ShapeDecoration(
                            shape: DashedBorder(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorConstant.appThemeColor
                            ),
                            image: DecorationImage(
                              image: AssetImage(ImageConstants.selectBankStatementCardBackground),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child:  Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: (fileNamePath != null && fileNamePath != "")
                                        ? Container(
                                        padding: EdgeInsets.all(10.0),
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                         border: Border.all(color: ColorConstant.textFieldBorderColor)
                                       ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(ImageConstants.pdfIcon, height: 25, width: 25),
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  fileName ?? "",
                                                  style: TextStyle(
                                                    fontSize: FontConstants.f14,
                                                    fontFamily: FontConstants.fontFamily,
                                                    fontWeight: FontConstants.w700,
                                                    color: ColorConstant.blackTextColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 2.0),
                                                Text(
                                                  "$fileSize KB",
                                                  style: TextStyle(
                                                    fontSize: FontConstants.f12,
                                                    fontFamily: FontConstants.fontFamily,
                                                    fontWeight: FontConstants.w400,
                                                    color: ColorConstant.greyTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                fileNamePath = "";
                                                fileName = "";
                                                fileSize = "";
                                                pdfBytes = null;
                                                needsPassword = false;
                                              });
                                            },
                                            child: Image.asset(ImageConstants.crossActionIcon,height: 24,width: 24),
                                          )
                                        ],
                                      ),
                                    )
                                        : Image.asset(ImageConstants.bankStatementUploadIcon, height: 50, width: 50),
                                  ),
                                  SizedBox(
                                    height: 26,
                                  ),
                                  if (needsPassword) ...[
                                    //const SizedBox(height: 8),
                                    CommonTextField(
                                      obscureText: passWordVisible,
                                      controller: _passwordController,
                                      hintText: "Enter your Code here",
                                      trailingWidget: Icon(
                                        passWordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      trailingClick: (){
                                        setState(() {
                                          passWordVisible = !passWordVisible;
                                        });
                                      },
                                    ),
                                    if(needsPassword && passwordError != null)...[
                                      const SizedBox(height: 8),
                                      Text(
                                        passwordError ?? "",
                                        style: TextStyle(
                                          fontSize: FontConstants.f14,
                                          fontFamily: FontConstants.fontFamily,
                                          fontWeight: FontConstants.w500,
                                          color: ColorConstant.errorRedColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ]else...[
                                      const SizedBox(height: 16),
                                    ]
                                  ],
                                  Center(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFF0074CC)),
                                        foregroundColor: const Color(0xFF0074CC),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      ),
                                      onPressed: () async {
                                        if(pdfBytes != null){
                                          final verified = await _checkPdf(password: _passwordController.text.trim());
                                          if(verified){
                                            DebugPrint.prt("File name path $fileNamePath");
                                            var otpModel = await MySharedPreferences.getUserSessionDataNode();
                                            VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));

                                            var customerId = verifyOtpModel.data?.custId;
                                            //var leadId = verifyOtpModel.data?.leadId;
                                           // if(leadId == "" || leadId == null){
                                            var  leadId = await MySharedPreferences.getLeadId();
                                           // }

                                            uploadSalarySlipNJS(
                                                custId: customerId!,
                                                leadId: leadId,
                                                requestSource: ConstText.requestSource,
                                                docType:"bank",
                                                bankStatementFile: File(fileNamePath!),
                                                bankVerifyType: "2",
                                                statementPassword: _passwordController.text.trim()
                                            );
                                          }
                                        }else{
                                          _pickPdf();
                                        }
                                      },
                                      child:  Text(
                                        (fileNamePath != null && fileNamePath != "")?
                                        "Upload file":
                                        'Select file',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        ListView.builder(
                          itemCount: bankStatementInstruction.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            DebugPrint.prt("with Index List Data ${bankStatementInstruction[index]}");
                            //return Text(bankStatementInstruction[index]);
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 2,
                                      backgroundColor: ColorConstant.errorRedColor,
                                    ),
                                    SizedBox(width: 8.0),
                                    Expanded( // ensure text wraps properly
                                      child: Text(
                                        bankStatementInstruction[index],
                                        style: TextStyle(
                                          fontSize: FontConstants.f14,
                                          fontWeight: FontConstants.w500,
                                          fontFamily: FontConstants.fontFamily,
                                          color: ColorConstant.errorRedColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                              ],
                            );
                          },
                        ),
                        BlocBuilder<UploadBankStatementStatusCubit, bool>(
                          builder: (context, isUploaded) {
                            if (!isUploaded) {
                              return const SizedBox.shrink(); // return empty if false
                            }

                            return Column(
                              children: [
                                SizedBox(
                                  height: 35.0,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 12.0
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(FontConstants.horizontalPadding)),
                                      border: Border.all(
                                          color: ColorConstant.textFieldBorderColor,
                                          width: 1
                                      )
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(ImageConstants.bankStatementUploadSuccess,width: 80,height: 80),
                                      Column(
                                        children: [
                                          Text(
                                            "Congratulations!",
                                            style: TextStyle(
                                                fontSize: FontConstants.f18,
                                                fontFamily: FontConstants.fontFamily,
                                                fontWeight: FontConstants.w800,
                                                color: ColorConstant.blackTextColor
                                            ),
                                          ),
                                          Text(
                                            "File uploaded successfully",
                                            style: TextStyle(
                                                fontWeight: FontConstants.w500,
                                                fontFamily: FontConstants.fontFamily,
                                                fontSize: FontConstants.f14,
                                                color: ColorConstant.greyTextColor
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadSalarySlipNJS({
    required String custId,
    required String leadId,
    required String requestSource,
    required String docType,
    File? salarySlipFile,
    String? salarySlipPassword,
    String? bankVerifyType,
    String? statementPassword,
    File? bankStatementFile,
  }) async {
    final formData = FormData();

    // Add text fields
    formData.fields
      ..add(MapEntry('custId', custId))
      ..add(MapEntry('leadId', leadId))
      ..add(MapEntry('requestSource',  Platform.isIOS?
      ConstText.requestSourceIOS:
      ConstText.requestSource))
      ..add(MapEntry('docType', docType));

    if (salarySlipPassword != null) {
      formData.fields.add(MapEntry('salarySlipPassword', salarySlipPassword));
    }

    if (bankVerifyType != null) {
      formData.fields.add(MapEntry('bankVerifyType', bankVerifyType));
    }

    if (statementPassword != null) {
      formData.fields.add(MapEntry('statementPassword', statementPassword));
    }

    // Add salary slip file
    if (salarySlipFile != null && await salarySlipFile.exists()) {
      final fileName = salarySlipFile.path.split('/').last;
      formData.files.add(
        MapEntry(
          'salarySlip',
          await MultipartFile.fromFile(
            salarySlipFile.path,
            filename: fileName,
            contentType: MediaType('application', 'pdf'), // adjust based on file
          ),
        ),
      );
    }

    // Add bank statement file
    if (bankStatementFile != null && await bankStatementFile.exists()) {
      final fileName = bankStatementFile.path.split('/').last;
      formData.files.add(
        MapEntry(
          'bankStatement',
          await MultipartFile.fromFile(
            bankStatementFile.path,
            filename: fileName,
            contentType: MediaType('application', 'pdf'), // adjust if needed
          ),
        ),
      );
    }

    DebugPrint.prt("Form Data To Upload $formData");
    context.read<LoanApplicationCubit>().uploadBankStatementApiCall(formData);

  }
}

