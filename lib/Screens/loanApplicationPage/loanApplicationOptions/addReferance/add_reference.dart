import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/AddMoreReferenceCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:rupeeontime/Model/GetCustomerDetailsModel.dart';
import 'package:rupeeontime/ParamModel/AddReferenceParamModel.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import 'package:rupeeontime/Widget/common_screen_background.dart';
import 'package:rupeeontime/Widget/common_textField.dart';
import '../../../../Constant/ColorConst/ColorConstant.dart';
import '../../../../Constant/FontConstant/FontConstant.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Model/VerifyOTPModel.dart';
import '../../../../Utils/CleverTapEventsName.dart';
import '../../../../Utils/CleverTapLogger.dart';
import '../../../../Utils/MysharePrefenceClass.dart';
import '../../../../Utils/validation.dart';
import '../../../../Widget/app_bar.dart';

class AddReferenceScreen extends StatefulWidget{
  const AddReferenceScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddReferenceScreen();
}

class _AddReferenceScreen extends State<AddReferenceScreen>{



  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController referAnceNameController = TextEditingController();
  TextEditingController referAnceNumberController = TextEditingController();
  TextEditingController referAnceNameControllerTwo = TextEditingController();

  final List<String> relationsDataList = [
    "Parents",
    "Relative",
    "Friends",
    "Colleague",
    "Brother",
    "Other"
  ];

  String? selectedValue;
  String? selectedValue2;

  @override
  void initState() {
    super.initState();
    context.read<AddMoreReferenceCubit>().clear();
    getReferenceData();
  }


  void getReferenceData() async{
    String? data = await MySharedPreferences.getCustomerDetails();
    if(data != null){
      CustomerDetails customerDetails = CustomerDetails.fromJson(jsonDecode(data));
      DebugPrint.prt("Reference Type Data ${customerDetails.refrenceType}");
      setState(() {
        referAnceNameController.text = customerDetails.refrenceName ?? "";
        int index = int.tryParse(customerDetails.refrenceType ?? "0") ?? 0;

        if (index > 0 && index <= relationsDataList.length) {
          selectedValue = relationsDataList[index - 1];
        } else {
          selectedValue = null;
        }
        referAnceNumberController.text = customerDetails.refrenceMobile ?? "";
      });
    }
  }

  // getCustomerDetailsApiCall() async{
  //   context.read<DashboardCubit>().callDashBoardApi();
  //   var otpModel = await MySharedPreferences.getPhpOTPModel();
  //   SendPhpOTPModel sendPhpOTPModel = SendPhpOTPModel.fromJson(jsonDecode(otpModel));
  //   context.read<LoanApplicationCubit>().getCustomerDetailsApiCall({
  //     "cust_profile_id": sendPhpOTPModel.data?.custProfileId
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appThemeColor,
      body: BlocListener<LoanApplicationCubit,LoanApplicationState>(
        listener: (context, state) {
          if (!context.mounted) return;

          if (state is LoanApplicationLoading) {
            EasyLoading.show(status: "Please wait...");
          }

          else if (state is AddReferenceSuccess) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.ADD_REFERENCE, isSuccess: true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.replace(AppRouterName.bankDetailsScreen);
              }
            });
          }

          else if (state is AddReferenceFailed) {
            EasyLoading.dismiss();
            CleverTapLogger.logEvent(CleverTapEventsName.ADD_REFERENCE, isSuccess: false);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                openSnackBar(context, state.addReferenceModel.message ?? "Unknown Error");
              }
            });
          }
        },
        child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Loan112AppBar(
                  customLeading: InkWell(
                    onTap: () async{
                      context.pop();
                      //await getCustomerDetailsApiCall();
                    },
                    child: Icon(Icons.arrow_back, color: ColorConstant.whiteColor),
                  ),
                  title: Text(
                    "Add Reference",
                    style: TextStyle(
                      fontSize: FontConstants.f20,
                      fontWeight: FontConstants.w800,
                      fontFamily: FontConstants.fontFamily,
                      color: ColorConstant.whiteColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:ColorConstant.whiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24)
                      )
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                        child: Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 24.0,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Note*  Only One reference allowed",
                                    style: TextStyle(
                                        fontSize: FontConstants.f14,
                                        fontWeight: FontConstants.w500,
                                        fontFamily: FontConstants.fontFamily,
                                        color: ColorConstant.dashboardTextColor
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              addReferenceFormData(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          color: ColorConstant.whiteColor,
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                BottomDashLine(),
                SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 22,left: 16,right: 16,top: 10),
                  child: Loan112Button(
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          addReferenceApiCallFunction(context);
                        }
                      },
                      text: "CONTINUE"
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addReferenceFormData(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reference Name",
          style: TextStyle(
              fontSize: FontConstants.f14,
              fontWeight: FontConstants.w600,
              fontFamily: FontConstants.fontFamily,
              color: ColorConstant.dashboardTextColor
          ),
        ),
        SizedBox(
          height: 6.0,
        ),
        CommonTextField(
            controller: referAnceNameController,
            hintText: "Enter your Reference Name",
            validator: (value){
              return validateName(value);
            },
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(
          "Relation",
          style: TextStyle(
              fontSize: FontConstants.f14,
              fontWeight: FontConstants.w600,
              fontFamily: FontConstants.fontFamily,
              color: ColorConstant.dashboardTextColor
          ),
        ),
        SizedBox(
          height: 6.0,
        ),
        selectRelationType(context,1),
        SizedBox(
          height: 12.0,
        ),
        Text(
          "Mobile No.",
          style: TextStyle(
              fontSize: FontConstants.f14,
              fontWeight: FontConstants.w600,
              fontFamily: FontConstants.fontFamily,
              color: ColorConstant.dashboardTextColor
          ),
        ),
        SizedBox(
          height: 6.0,
        ),
        CommonTextField(
            controller: referAnceNumberController,
            hintText: "Enter mobile number",
          maxLength: 10,
          keyboardType: TextInputType.phone,
          //textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
            validator: (value) {
              return validateMobileNumber(value);
            },
        ),
      ],
    );
  }



  Widget selectRelationType(BuildContext context, int type) {
    return FormField<String>(
      validator: (value) {
        if (type == 1 && selectedValue == null) {
          return 'Please select a relation';
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Select Relation',
                  style: TextStyle(
                    fontSize: FontConstants.f14,
                    color: ColorConstant.blackTextColor,
                    fontWeight: FontConstants.w400,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                items: relationsDataList
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: FontConstants.f14,
                      color: ColorConstant.blackTextColor,
                      fontWeight: FontConstants.w500,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                ))
                    .toList(),
                value: relationsDataList.contains(selectedValue) ? selectedValue : null,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  state.didChange(value);
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  padding: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }


  Widget addMoreReferenceUI(BuildContext context){
    return InkWell(
      onTap: (){
        context.read<AddMoreReferenceCubit>().updateReference(true);
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstant.appThemeColor,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          '+ Add one more reference',
          style: TextStyle(
              color: ColorConstant.whiteColor,
              fontSize: FontConstants.f14,
              fontWeight: FontConstants.w700,
              fontFamily: FontConstants.fontFamily
          ),
        ),
      ),
    );
  }

  void addReferenceApiCallFunction(BuildContext context) async{
    AddReferenceParamModel referenceParamModel = AddReferenceParamModel();
    List<Reference> referenceData = [];
      Reference reference = Reference();
      reference.referenceMobile = referAnceNumberController.text.trim();
      reference.referenceName = referAnceNameController.text.trim();
      reference.referenceRelation = relationsDataList.indexOf(selectedValue?? "")+1;
      referenceData.add(reference);

    var otpModel = await MySharedPreferences.getUserSessionDataNode();
    VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));

    var customerId = verifyOtpModel.data?.custId;
    //var leadId = verifyOtpModel.data?.leadId;
    //if(leadId == "" || leadId == null){
     var leadId = await MySharedPreferences.getLeadId();
   // }

      referenceParamModel.custId = customerId;
      referenceParamModel.leadId = leadId;
      referenceParamModel.referenceList = referenceData;

      context.read<LoanApplicationCubit>().addReferenceApiCall(referenceParamModel.toJson());

  }

}

