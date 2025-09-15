import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Widget/common_screen_background.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:widgets_easier/widgets_easier.dart';
import '../../../../Constant/ConstText/ConstText.dart';
import '../../../../Constant/FontConstant/FontConstant.dart';
import '../../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Model/GetUtilityDocTypeModel.dart';
import '../../../../Model/SendPhpOTPModel.dart' hide Data;
import '../../../../Model/VerifyOTPModel.dart' hide Data;
import '../../../../Utils/CleverTapEventsName.dart';
import '../../../../Utils/CleverTapLogger.dart';
import '../../../../Utils/Debugprint.dart';
import '../../../../Utils/MysharePrefenceClass.dart';
import '../../../../Utils/snackbarMassage.dart';
import '../../../../Widget/app_bar.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import '../../../../Widget/common_textField.dart';

class UtilityBillScreen extends StatefulWidget{
  const UtilityBillScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UtilityBillScreen();
}

class _UtilityBillScreen extends State<UtilityBillScreen>{


  var filePickingDeclaration = [
    "Maximum 2 MB file size allowed",
    "Only PDF,JPG,JPEG,PNG files allowed",
    "Latest month's bills required"
  ];
  int? selectedValue;
  bool passWordVisible = false;
  Uint8List? pdfBytes;
  bool needsPassword = false;
  String? passwordError;
  String? fileNamePath;
  String? fileName;
  String? fileSize;
  int count = 0;

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
      fileName = result.files.single.name;
      fileNamePath = result.files.single.path;
      fileSize = (result.files.single.size / 1024).toStringAsFixed(1);
      _checkPdf();
    }
  }

  Future<bool> _checkPdf({String? password}) async {
    try {
      // Try to load PDF
      final doc = PdfDocument(
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
    getUtilityBillDoc();
  }



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

  void getUtilityBillDoc() async{
    var otpModel = await MySharedPreferences.getUserSessionDataNode();
    VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
   // var leadId = verifyOtpModel.data?.leadId;
    //if(leadId == "" || leadId == null){
     var leadId = await MySharedPreferences.getLeadId();
     DebugPrint.prt("Lead Id Utility Bill $leadId");
    //}
    context.read<LoanApplicationCubit>().getUtilityTypeDocApiCall({"leadId":leadId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoanApplicationCubit,LoanApplicationState>(
        listener: (BuildContext context, LoanApplicationState state) {
          if (!context.mounted) return;

          if (state is LoanApplicationLoading) {
            EasyLoading.show(status: "Please wait...");
          }

          else if (state is GetUtilityDocTypeLoaded) {
            setState(() {
              getUtilityDocTypeModel = state.getUtilityDocTypeModel;
              // Filter out any data where isUploaded is false
              if (state.getUtilityDocTypeModel.data != null) {
                 filteredUtilityBillData = GetUtilityDocTypeModel(
                  data: state.getUtilityDocTypeModel.data!
                      .where((d) => d.isUploaded == false)
                      .toList(),
                );
              }


              if (selectedDocument != null && filteredUtilityBillData?.data != null) {
                Data? match;
                for (final d in filteredUtilityBillData!.data!) {
                  if (d.docsId == selectedDocument!.docsId) {
                    match = d;
                    break;
                  }
                }
                selectedDocument = match; // null if not found
              } else {
                selectedDocument = null;
              }
            });
            DebugPrint.prt("Filtered Bill ${filteredUtilityBillData?.data?.length}");
            DebugPrint.prt("Data Doc Length ${getUtilityDocTypeModel?.data?.length}");
            if((int.parse((getUtilityDocTypeModel?.data!.length ?? 0).toString())
                -int.parse((filteredUtilityBillData?.data!.length ?? 0).toString())) >=2){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.replace(AppRouterName.addReference);
                }
              });
            }
            EasyLoading.dismiss();
          }

          else if (state is LoanApplicationError) {
            EasyLoading.dismiss();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                openSnackBar(context, state.message);
              }
            });
          }

          else if (state is UploadUtilityDocSuccess) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.DOCUMENTATION, isSuccess: true);
            DebugPrint.prt("Final Result On utility Success ${state.uploadUtilityDocTypeModel.data?.finalResult}");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                setState(() {
                  fileNamePath = "";
                  fileName = "";
                  fileSize = "";
                  pdfBytes = null;
                  selectedDocument = null;
                  needsPassword = false;
                });
                getUtilityBillDoc();
              }
            });
          }

          else if (state is UploadUtilityDocError) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.DOCUMENTATION, isSuccess: false);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                openSnackBar(context, state.errorMessage ?? "");
              }
            });
          }
        },
        child: GradientBackground(
          child: SafeArea(
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
                              "Verify Residence",
                              style: TextStyle(
                                  fontSize: FontConstants.f20,
                                  fontFamily: FontConstants.fontFamily,
                                  fontWeight: FontConstants.w800,
                                  color: ColorConstant.dashboardTextColor
                              ),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              "Prove that you're in charge of your domain!",
                              style: TextStyle(
                                  fontSize: FontConstants.f14,
                                  fontFamily: FontConstants.fontFamily,
                                  fontWeight: FontConstants.w500,
                                  color: Color(0xff4E4F50)
                              ),
                            ),
                            SizedBox(
                              height: 31,
                            ),
                            chooseDocumentButton(context),
                            SizedBox(
                              height: 24.0,
                            ),
                            filePickingUI(context),
                            SizedBox(
                              height: 24.0,
                            ),
                            filePickingDeclarationUI(context)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }


  GetUtilityDocTypeModel? getUtilityDocTypeModel;
  GetUtilityDocTypeModel? filteredUtilityBillData;
  Data? selectedDocument;

  Widget chooseDocumentButton(BuildContext context) {
    if (filteredUtilityBillData?.data != null) {
      return DropdownButtonHideUnderline(
        child: DropdownButton2<Data>(
          isExpanded: true,
          hint: Text(
            'Choose Your Document',
            style: TextStyle(
              fontSize: FontConstants.f14,
              color: ColorConstant.blackTextColor,
              fontWeight: FontConstants.w400,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
          items: filteredUtilityBillData!.data!
              .map((item) => DropdownMenuItem<Data>(
            value: item,
            child: Text(
              item.docType ?? '',
              style: TextStyle(
                fontSize: FontConstants.f14,
                color: ColorConstant.blackTextColor,
                fontWeight: FontConstants.w500,
                fontFamily: FontConstants.fontFamily,
              ),
            ),
          ))
              .toList(),
          value: selectedDocument,
          onChanged: (value) {
            setState(() {
              selectedDocument = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            padding: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorConstant.textFieldBorderColor,
              ),
              color: ColorConstant.appScreenBackgroundColor,
            ),
            elevation: 0,
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: ColorConstant.greyTextColor,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }
    else {
      return SizedBox.shrink();
    }
  }

  Widget filePickingUI(BuildContext context){
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                ]
                else...[
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
                    if (pdfBytes != null) {
                      final verified = await _checkPdf(password: _passwordController.text.trim());
                      if (verified) {
                        uploadUtilityData(context); // 📤 Call upload if verified
                      }
                    } else {
                      await _pickPdf();
                    }
                  },
                  child: Text(
                    (fileNamePath != null && fileNamePath != "")?
                    "Upload file":
                    'Select file',
                    style: TextStyle(fontSize: 14),
                  ),
                )
              )
            ],
          )
      ),
    );
  }

  Widget filePickingDeclarationUI(BuildContext context){
    return ListView.builder(
        itemCount: filePickingDeclaration.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 2,
                    backgroundColor: ColorConstant.errorRedColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    filePickingDeclaration[index],
                    style: TextStyle(
                      fontSize: FontConstants.f14,
                      fontWeight: FontConstants.w500,
                      fontFamily: FontConstants.fontFamily,
                      color: ColorConstant.errorRedColor
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        }
    );
  }


  uploadUtilityData(BuildContext context) async{
    if((selectedDocument?.docType != null || selectedDocument?.docType != "") && selectedDocument != null){
      DebugPrint.prt("File name path $fileNamePath");
      var imagePathConverted = File(fileNamePath!);
      var otpModel = await MySharedPreferences.getUserSessionDataNode();
      VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));

      var customerId = verifyOtpModel.data?.custId;
      //var leadId = verifyOtpModel.data?.leadId;
      //if(leadId == "" || leadId == null){
       var leadId = await MySharedPreferences.getLeadId();
     // }

      final formData = FormData();

      // Add text parts
      formData.fields
        ..add(MapEntry('custId', customerId?? ""))
        ..add(MapEntry('leadId', leadId))
        ..add(MapEntry('requestSource',  Platform.isIOS?
        ConstText.requestSourceIOS:
        ConstText.requestSource))
        ..add(MapEntry('docType', selectedDocument?.docType ?? ""
        ));

      // Prepare file part
      final file = File(imagePathConverted.path);

      if (!await file.exists()) {
        throw Exception('File does not exist at ${file.path}');
      }

      final fileName = file.uri.pathSegments.last;
      final fileExtension = fileName.split('.').last.toLowerCase();

      String? mimeType;
      if (fileExtension == 'pdf') {
        mimeType = 'application/pdf';
      } else {
        throw Exception('Unsupported file type: $fileExtension');
      }

      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      );

      formData.files.add(MapEntry('addressDocs', multipartFile));

      context.read<LoanApplicationCubit>().uploadUtilityTypeDocApiCall(formData);
    }else{
      openSnackBar(context, "Please choose document type");
    }
  }


}

