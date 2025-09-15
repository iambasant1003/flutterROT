import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:rupeeontime/Model/GetCustomerDetailsModel.dart';
import 'package:rupeeontime/ParamModel/UpdateBankDetailsParamModel.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import 'package:rupeeontime/Widget/common_textField.dart';
import '../../../../Constant/ColorConst/ColorConstant.dart';
import '../../../../Constant/FontConstant/FontConstant.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Model/BankAccountTypeModel.dart';
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Model/VerifyOTPModel.dart';
import '../../../../ParamModel/VerifyIfscParamModel.dart';
import '../../../../Utils/CleverTapEventsName.dart';
import '../../../../Utils/CleverTapLogger.dart';
import '../../../../Utils/MysharePrefenceClass.dart';
import '../../../../Utils/UpperCaseTextFormatter.dart';
import '../../../../Utils/validation.dart';
import '../../../../Widget/app_bar.dart';
import '../../../../Widget/common_screen_background.dart';

class BankingDetailScreen extends StatefulWidget{
  const BankingDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BankingDetailScreen();
}

class _BankingDetailScreen extends State<BankingDetailScreen>{


  TextEditingController ifscCode = TextEditingController();
  TextEditingController bankAccount = TextEditingController();
  TextEditingController confirmBankAccount = TextEditingController();
  TextEditingController bankName = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //String? selectedValue;
  BankAccountTypeModel? bankAccountTypeModel;
  BankAccountTypeParamModel? selectedBankType;

  @override
  void initState() {
    super.initState();
    context.read<LoanApplicationCubit>().getBankAccountTypeApiCall({});
    getBankDetails();
  }

  String bankAccountYpeId = "";
  void getBankDetails() async{
    var data = await MySharedPreferences.getCustomerDetails();
    if(data != null){
      CustomerDetails customerDetails = CustomerDetails.fromJson(jsonDecode(data));
      DebugPrint.prt("Customer Data ${customerDetails.bankAccountTypeId}");
       setState(() {
         bankAccountYpeId = customerDetails.bankAccountTypeId ?? "";
         selectedBankType?.bankTypeName = customerDetails.bankAccountTypeName ?? "";
         bankName.text = customerDetails.bankAccountName ?? "";
         confirmBankAccount.text = customerDetails.cnfBankAccountNumber ?? "";
         bankAccount.text = customerDetails.bankAccountNumber ?? "";
         ifscCode.text = customerDetails.bankAccountIfsc ?? "";
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
     body: BlocListener<LoanApplicationCubit,LoanApplicationState>(
       listener: (BuildContext context, state) {
         if (!context.mounted) return;

         if (state is LoanApplicationLoading) {
           EasyLoading.show(status: "Please wait...");
         }

         else if (state is VerifyIfscCodeSuccess) {
           EasyLoading.dismiss();
           WidgetsBinding.instance.addPostFrameCallback((_) {
             if (context.mounted) {
               bankName.text = state.ifscCodeModel.data?.bankAccountName ?? "";
             }
           });
         }

         else if (state is VerifyIfscCodeFailed) {
           EasyLoading.dismiss();
           WidgetsBinding.instance.addPostFrameCallback((_) {
             if (context.mounted) {
               openSnackBar(context, state.ifscCodeModel.message ?? "Unexpected Error");
             }
           });
         }

         else if (state is UpdateBankDetailsSuccess) {
           EasyLoading.dismiss();
           CleverTapLogger.logEvent(CleverTapEventsName.BANK_DETAILS, isSuccess: true);
           WidgetsBinding.instance.addPostFrameCallback((_) {
             if (context.mounted && (state.updateBankAccountModel.success ?? false)) {
               context.pop();
               context.replace(AppRouterName.loanApplicationSubmit,extra: state.updateBankAccountModel.data);
             }
           });
         }

         else if (state is UpdateBankDetailsFailed) {
           EasyLoading.dismiss();
           CleverTapLogger.logEvent(CleverTapEventsName.BANK_DETAILS, isSuccess: false);
           WidgetsBinding.instance.addPostFrameCallback((_) {
             if (context.mounted) {
               context.pop();
               openSnackBar(context, state.updateBankAccountModel.message ?? "Unexpected Error");
             }
           });
         }

         else if (state is BankAccountTypeSuccess) {
           EasyLoading.dismiss();
           WidgetsBinding.instance.addPostFrameCallback((_) {
             if (context.mounted) {
               setState(() {
                 bankAccountTypeModel = state.bankAccountTypeModel;
                 if(bankAccountYpeId != ""){
                   selectedBankType = bankAccountTypeModel?.data![int.parse(bankAccountYpeId)-1];
                 }
               });
             }
           });
         }

         else if (state is BankAccountTypeFailed) {
           EasyLoading.dismiss();
           WidgetsBinding.instance.addPostFrameCallback((_) {
             if (context.mounted) {
               openSnackBar(context, state.bankAccountTypeModel.message ?? "Unexpected Error");
             }
           });
         }
       },
       child: GradientBackground(
         child: SafeArea(
             child: Form(
               key: formKey,
               autovalidateMode: AutovalidateMode.onUserInteraction,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Loan112AppBar(
                     customLeading: InkWell(
                       child: Icon(Icons.arrow_back_ios,color: ColorConstant.blackTextColor),
                       onTap: () async{
                         context.pop();
                        // await getCustomerDetailsApiCall();
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
                               "Banking Details",
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
                               "Please enter your Bank details for Disbursal",
                               style: TextStyle(
                                   fontSize: FontConstants.f14,
                                   fontFamily: FontConstants.fontFamily,
                                   fontWeight: FontConstants.w600,
                                   color: Color(0xff4E4F50)
                               ),
                             ),
                             SizedBox(
                               height: 24,
                             ),
                             Text(
                               "IFSC Code*",
                               style: TextStyle(
                                   fontSize: FontConstants.f14,
                                   fontFamily: FontConstants.fontFamily,
                                   fontWeight: FontConstants.w500,
                                   color: ColorConstant.dashboardTextColor
                               ),
                             ),
                             SizedBox(
                               height: 6.0,
                             ),
                             CommonTextField(
                               controller: ifscCode,
                               hintText: "Enter your IFSC Code*",
                               inputFormatters: [
                                 LengthLimitingTextInputFormatter(11),
                                 UpperCaseTextFormatter(), // Custom formatter below
                               ],
                               validator: (value){
                                 return validateIfsc(value ?? "");
                               },
                               onChanged: (value){
                                 if(value.trim().length == 11){
                                   VerifyIfscParamModel verifyIfscCodeParamModel = VerifyIfscParamModel(bankAccountIfsc: value);
                                   context.read<LoanApplicationCubit>().verifyIfscCodeApiCall(verifyIfscCodeParamModel.toJson());
                                 }
                               },
                             ),
                             SizedBox(
                               height: 12,
                             ),
                             Text(
                               "Bank A/C No*",
                               style: TextStyle(
                                   fontSize: FontConstants.f14,
                                   fontFamily: FontConstants.fontFamily,
                                   fontWeight: FontConstants.w500,
                                   color: ColorConstant.dashboardTextColor
                               ),
                             ),
                             SizedBox(
                               height: 6.0,
                             ),
                             CommonTextField(
                               controller: bankAccount,
                               hintText: "Enter your Bank A/C No*",
                               keyboardType: TextInputType.number,
                               obscureText: true,
                               maxLength: 18,
                               inputFormatters: [
                                 FilteringTextInputFormatter.digitsOnly, // only allows 0-9
                               ],
                               validator: (value) {
                                 return validateBankAccount(value);
                               },
                             ),
                             SizedBox(
                               height: 12,
                             ),
                             Text(
                               "Confirm A/C No.*",
                               style: TextStyle(
                                   fontSize: FontConstants.f14,
                                   fontFamily: FontConstants.fontFamily,
                                   fontWeight: FontConstants.w500,
                                   color: ColorConstant.dashboardTextColor
                               ),
                             ),
                             SizedBox(
                               height: 6.0,
                             ),
                             CommonTextField(
                                 controller: confirmBankAccount,
                                 hintText: "Re-enter your Bank A/C No.",
                                 keyboardType: TextInputType.number,
                                 maxLength: 18,
                               inputFormatters: [
                                 FilteringTextInputFormatter.digitsOnly, // only allows 0-9
                               ],
                                 validator: (value){
                                   if(value?.trim() != bankAccount.text.trim()){
                                     return "Account numbers do not match";
                                   }
                                   return null;
                                 },
                             ),
                             SizedBox(
                               height: 12,
                             ),
                             Text(
                               "Bank Name*",
                               style: TextStyle(
                                   fontSize: FontConstants.f14,
                                   fontFamily: FontConstants.fontFamily,
                                   fontWeight: FontConstants.w500,
                                   color: ColorConstant.dashboardTextColor
                               ),
                             ),
                             SizedBox(
                               height: 6.0,
                             ),
                             CommonTextField(
                                 controller: bankName,
                                 hintText: "Enter your Bank Name*",
                                 validator: (value){
                                   return validateBankName(value);
                                 },
                             ),
                             SizedBox(
                               height: 12,
                             ),
                             Text(
                               "Bank A/C Type*",
                               style: TextStyle(
                                   fontSize: FontConstants.f14,
                                   fontFamily: FontConstants.fontFamily,
                                   fontWeight: FontConstants.w500,
                                   color: ColorConstant.dashboardTextColor
                               ),
                             ),
                             SizedBox(
                               height: 6.0,
                             ),
                             bankAccountType(context),
                             SizedBox(
                               height: 10.0,
                             )
                           ],
                         ),
                       ),
                     ),
                   )
                 ],
               ),
             )
         ),
       ),
     ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 101,
          child: Column(
            children: [
              BottomDashLine(),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                child: Loan112Button(
                    text: "Submit",
                    onPressed: () async{
                      if(formKey.currentState!.validate()){

                      showBankVerificationBottomSheet(
                        context,
                        onYesTap: () async{
                          var otpModel = await MySharedPreferences.getUserSessionDataNode();
                          VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
                         // var leadId = verifyOtpModel.data?.leadId ?? "";
                          //if (leadId == "") {
                           var leadId = await MySharedPreferences.getLeadId();
                          //}

                          UpdateBankDetailsParamModel updateBankDetailsData =
                          UpdateBankDetailsParamModel(
                              custId: verifyOtpModel.data?.custId ?? "",
                              leadId: leadId,
                              account: bankAccount.text.trim(),
                              confirmAccount: confirmBankAccount.text.trim(),
                              ifsc: ifscCode.text.trim(),
                              accountType: selectedBankType?.bankTypeId ?? "",
                              type: "1"
                          );
                          context.read<LoanApplicationCubit>().updateBankDetailsApiCall(updateBankDetailsData.toJson());
                        },
                        onNoTap: () async{
                          // Your NO logic here
                          Navigator.pop(context);
                        },
                      );
                      }
                    }
                ),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget bankAccountType(BuildContext context){
    return FormField<String>(
      validator: (value) {
        if (selectedBankType == null) {
          return 'Please select your bank account type.';
        }
        return null;
      },
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<BankAccountTypeParamModel>(
                isExpanded: true,
                hint: Text(
                  'Select Bank A/C Type*',
                  style: TextStyle(
                    fontSize: FontConstants.f14,
                    color: ColorConstant.blackTextColor,
                    fontWeight: FontConstants.w400,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                items: bankAccountTypeModel?.data
                    ?.map((item) => DropdownMenuItem<BankAccountTypeParamModel>(
                  value: item,
                  child: Text(
                    item.bankTypeName ?? "",
                    style: TextStyle(
                      fontSize: FontConstants.f14,
                      color: ColorConstant.blackTextColor,
                      fontWeight: FontConstants.w500,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                ))
                    .toList(),
                value: selectedBankType,
                onChanged: (value) {
                  setState(() {
                    selectedBankType = value;
                    //field.didChange(value); // important to update validation state
                  });
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
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }




  Future<dynamic> showBankVerificationBottomSheet(BuildContext context,{required Future<void> Function() onYesTap,required Future<void> Function() onNoTap}) {
   return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 24,bottom: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                  child:  Column(
                    children: [
                      Image.asset("assets/icons/bankverify_icon.png",height: 50,width: 50),
                      const SizedBox(height: 20),

                      // Title / Warning Text
                      Text(
                        "This is your final attempt to verify your bank details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontConstants.w800,
                            fontSize: FontConstants.f18,
                            fontFamily: FontConstants.fontFamily,
                            color: ColorConstant.blackTextColor
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1EAFF),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD1EAFF).withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // NO Button
                      TextButton(
                        onPressed: onNoTap,
                        child:  Text(
                          "NO",
                          style: TextStyle(
                              color: ColorConstant.errorRedColor,
                              fontSize: FontConstants.f16,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontConstants.w700
                          ),
                        ),
                      ),

                      // YES Button
                      SizedBox(
                        width: 85,
                        height: 55,
                        child: Loan112Button(
                          text: "Yes",
                          onPressed: onYesTap,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


}

