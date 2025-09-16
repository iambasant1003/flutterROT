import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:rupeeontime/Cubit/loan_application_cubit/LoanApplicationState.dart';
import 'package:rupeeontime/Model/GenerateLoanOfferModel.dart';
import 'package:rupeeontime/Model/GetPurposeOfLoanModel.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import 'package:rupeeontime/Widget/common_button.dart';
import '../../../../Constant/ColorConst/ColorConstant.dart';
import '../../../../Constant/FontConstant/FontConstant.dart';
import '../../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Model/VerifyOTPModel.dart';
import '../../../../ParamModel/LoanAcceptanceParamModel.dart';
import '../../../../Utils/CleverTapEventsName.dart';
import '../../../../Utils/CleverTapLogger.dart';
import '../../../../Utils/MysharePrefenceClass.dart';
import '../../../../Utils/validation.dart';
import '../../../../Widget/app_bar.dart';

class LoanOfferScreen extends StatefulWidget{
  final int enhance;
  const LoanOfferScreen({super.key,required this.enhance});

  @override
  State<StatefulWidget> createState() => _LoanOfferScreen();
}

class _LoanOfferScreen extends State<LoanOfferScreen>{

  double minValue = 0;
  double currentValue = 0;
  double maxValue = 40000;
  double currentTenure = 0;
  double minTenure = 0;
  double maxTenure = 40;
  bool initialized = false;
  String? purPoseOfLoan;
  int interestRate = 0;
  String interestAmount = "";
  String totalPayableAmount = "";
  String purposeOfLoanId = "";
  // put this in your State
  DataModeL? selectedPurpose;
  GenerateLoanOfferModel? generateLoanOfferModel;
  GetPurposeOfLoanModel? getPurposeOfLoanModel;
  bool _isActive = true;
  bool isEnhance = false;



  @override
  void dispose() {
    _isActive = false;
    super.dispose();
  }

  @override
  void initState() {
    DebugPrint.prt("Is Enhance Button ${widget.enhance}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateLoanOfferApiCall();
    });
  }



  generateLoanOfferApiCall() async{
    var leadId = await MySharedPreferences.getLeadId();
    context.read<LoanApplicationCubit>().getPurposeOfLoanApiCall(
        {
          "leadId": leadId
        }
    );
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Loan112AppBar(
        customLeading: InkWell(
          onTap: () async{
            context.pop();
            //await getCustomerDetailsApiCall();
          },
          child: Icon(Icons.arrow_back_ios, color: ColorConstant.whiteColor),
        ),
        title: Text(
          "Loan Offer",
          style: TextStyle(
            fontSize: FontConstants.f20,
            fontWeight: FontConstants.w800,
            fontFamily: FontConstants.fontFamily,
            color: ColorConstant.whiteColor,
          ),
        ),
      ),
      body: BlocListener<LoanApplicationCubit,LoanApplicationState>(
        listenWhen: (prev,next){
          return prev != next;
        },
        listener: (context, state) {
          if (!_isActive) return;

          if (state is LoanApplicationLoading || state is LoanAcceptanceLoading) {
            EasyLoading.show(status: "Please wait...");
          }

          else if (state is GenerateLoanOfferSuccess) {
            EasyLoading.dismiss();
            generateLoanOfferModel = state.generateLoanOfferModel;
            getPurposeOfLoanModel = state.getPurposeOfLoanModel;

            currentTenure = double.parse((generateLoanOfferModel?.data?.maxLoanTenure ?? 0).toString());
            minTenure = double.parse((generateLoanOfferModel?.data?.minLoanTenure ?? 0).toString());
            maxTenure = double.parse((generateLoanOfferModel?.data?.maxLoanTenure ?? 0).toString());
            currentValue = double.parse((generateLoanOfferModel?.data?.maxLoanAmount ?? 0).toString());
            minValue = double.parse((generateLoanOfferModel?.data?.minLoanAmount ?? 0).toString());
            maxValue = double.parse((generateLoanOfferModel?.data?.maxLoanAmount ?? 0).toString());
            interestRate = generateLoanOfferModel?.data?.interestRate ?? 0;
            DebugPrint.prt("Minimum Loan Amount $minTenure");
            DebugPrint.prt("Maximum Loan Amount $maxTenure");
            DebugPrint.prt("Model data $generateLoanOfferModel, $getPurposeOfLoanModel");

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;

              calculateLoan(
                principal: currentValue,
                tenure: currentTenure,
                interestRate: double.parse((interestRate).toString()),
              );

              setState(() {});
            });
          }

          else if (state is GenerateLoanOfferError) {
            EasyLoading.dismiss();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                openSnackBar(context, state.generateLoanOfferModel.message ?? "Unknown Error");
                if(state.generateLoanOfferModel.statusCode == 402){
                  context.replace(AppRouterName.loanOfferFailed,extra: state.generateLoanOfferModel);
                }
              }
            });
          }

          else if (state is GetPurposeOfLoanFailed) {
            EasyLoading.dismiss();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                openSnackBar(context, state.getPurposeOfLoanModel.message ?? "Unknown Error");
              }
            });
          }

          else if (state is LoanAcceptanceSuccess) {
            EasyLoading.dismiss();
            DebugPrint.prt("Loan Accepted");
            if(isEnhance){
              DebugPrint.prt("Loan Accepted Enhance");
              CleverTapLogger.logEvent(CleverTapEventsName.LOAN_QUOTE_ENHANCE, isSuccess: true);
            }else{
              DebugPrint.prt("Loan Accepted not Enhance");
              CleverTapLogger.logEvent(CleverTapEventsName.LOAN_QUOTE_ACCEPT, isSuccess: true);
            }

            Future(() async {
              if (!_isActive) return;
              if(!isEnhance){
                DebugPrint.prt("Loan Accepted not Enhance 2");
                await checkConditionCalculateDistanceApiCall();
              }
              else{
                //await getCustomerDetailsApiCall();
              }
              if (!_isActive) return;
              DebugPrint.prt("Loan Accepted Enhance back Called");
              context.pop();
            });
          }

          else if (state is LoanAcceptanceError) {
            EasyLoading.dismiss();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                openSnackBar(context, state.loanAcceptanceModel.message ?? "Unknown Error");
                if(state.loanAcceptanceModel.statusCode == 403){
                  context.pop();
                  //getCustomerDetailsApiCall();
                  CleverTapLogger.logEvent(CleverTapEventsName.LOAN_QUOTE_REJECT, isSuccess: true);
                }else{
                  if(isEnhance){
                    CleverTapLogger.logEvent(CleverTapEventsName.LOAN_QUOTE_ENHANCE, isSuccess: false);
                  }else{
                    CleverTapLogger.logEvent(CleverTapEventsName.LOAN_QUOTE_ACCEPT, isSuccess: false);
                  }
                }
              }
            });
          }
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                  child: Container(
                    color: ColorConstant.appThemeColor,
                  )
              ),
              if(generateLoanOfferModel != null && getPurposeOfLoanModel != null)...[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 20,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      loanOfferContainer(context),

                    ],
                  ),
                )
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: SizedBox(
          height: widget.enhance == 0?
          150:82,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              BottomDashLine(),
              widget.enhance == 0?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 250,
                      child: Loan112Button(
                        text: "Request to Enhance Offer",
                        fontSize: FontConstants.f14,
                        fontWeight: FontConstants.w600,
                        fontFamily: FontConstants.fontFamily,
                        onPressed: (){
                          loanAcceptanceApiCall(context,3);
                        },
                      ),
                    ),
                  ],
                ),
              ):
              SizedBox.shrink(),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 61
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showRejectConfirmationDialog(context);
                      },
                      child: Container(
                        width: 107,
                        height: 40,
                        decoration: BoxDecoration(
                           color: Colors.grey.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(50.0))
                        ),
                        child: Center(
                          child: Text(
                            "Reject",
                            style: TextStyle(
                              fontSize: FontConstants.f14,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontConstants.w600,
                              color: ColorConstant.brownColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // optional spacing
                    InkWell(
                      onTap: (){
                        loanAcceptanceApiCall(context, 1);
                      },
                      child: Container(
                        width: 107,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorConstant.appThemeColor,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(50.0))
                        ),
                        child: Center(
                          child: Text(
                            "Accept",
                            style: TextStyle(
                              fontSize: FontConstants.f14,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontConstants.w600,
                              color: ColorConstant.appThemeColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loanAcceptanceApiCall(BuildContext context, int loanAcceptedId) async {
    if(loanAcceptedId == 3){
      isEnhance = true;
    }
    if (purposeOfLoanId != "") {
      var otpModel = await MySharedPreferences.getUserSessionDataNode();
      VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
      var leadIdData = await MySharedPreferences.getLeadId();


      if (!context.mounted) return; // ✅ make sure context is valid

      Loanacceptanceparammodel loanacceptanceparammodel = Loanacceptanceparammodel();
      loanacceptanceparammodel.custId = verifyOtpModel.data?.custId;
      loanacceptanceparammodel.leadId = leadIdData;
      loanacceptanceparammodel.loanAmount = currentValue.toInt();
      loanacceptanceparammodel.tenure = currentTenure.toInt();
      loanacceptanceparammodel.loanPurposeId = int.parse(purposeOfLoanId);
      loanacceptanceparammodel.loanAcceptId = loanAcceptedId;

      context.read<LoanApplicationCubit>().loanAcceptanceApiCall(loanacceptanceparammodel.toJson());
    } else {
      if (!context.mounted) return; // ✅ context check before showing snackbar
      openSnackBar(context, "Please select purpose of loan");
    }
  }

  Widget loanOfferContainer(BuildContext context){
    return BlocBuilder<LoanApplicationCubit,LoanApplicationState>(
        builder: (context,state){
          if(generateLoanOfferModel != null && getPurposeOfLoanModel != null){
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: BoxDecoration(
                    color: Color(0xffD4F7FF),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                  ),
                  //padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xffD4F7FF),
                                borderRadius: BorderRadius.all(Radius.circular(24.0))
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 12.0
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 6.0,
                                  ),
                                  purposeOfLoanButton(context,getPurposeOfLoanModel!),
                                  SizedBox(
                                    height: 32.0,
                                  ),
                                  principalSliderAndValue(context),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  tenureSliderAndValue(context,valueType:generateLoanOfferModel?.data?.loanTenureText??""),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          interestAndProcessingFeeUi(context,generateLoanOfferModel: generateLoanOfferModel),
                          SizedBox(
                            height: 16,
                          ),
                          calculationUI(context),

                          SizedBox(
                            height: 16,
                          ),

                          SizedBox(
                            height: 220.0,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }else{
            return Column(
              children: [

              ],
            );
          }
        }
    );
  }

  Widget purposeOfLoanButton(BuildContext context, GetPurposeOfLoanModel getPurposeOfLoanModel) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<DataModeL>(
        isExpanded: true,
        hint: Text(
          'Select Purpose of Loan*',
          style: TextStyle(
            fontSize: FontConstants.f14,
            color: ColorConstant.appThemeColor,
            fontWeight: FontConstants.w700,
            fontFamily: FontConstants.fontFamily,
          ),
        ),
        items: getPurposeOfLoanModel.data!
            .map((item) => DropdownMenuItem<DataModeL>(
          value: item,
          child: Text(
            item.loanPurposeName ?? "",
            style: TextStyle(
              fontSize: FontConstants.f14,
              color: ColorConstant.appThemeColor,
              fontWeight: FontConstants.w700,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
        ))
            .toList(),
        value: selectedPurpose,
        onChanged: (value) {
          setState(() {
            selectedPurpose = value;
            purposeOfLoanId = value?.loanPurposeId ?? "";
          });

          DebugPrint.prt("Loan Purpose Id $purposeOfLoanId");
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ColorConstant.appThemeColor,
            ),
            color: ColorConstant.whiteColor,
          ),
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: ColorConstant.appThemeColor,
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

  double step = 500;
  Widget principalSliderAndValue(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PRINCIPAL",
              style: TextStyle(
                  fontSize: FontConstants.f12,
                  fontFamily: FontConstants.fontFamily,
                  fontWeight: FontConstants.w500,
                  color: ColorConstant.blackTextColor
              ),
              textAlign: TextAlign.start,
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration:BoxDecoration(
                  color: ColorConstant.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: BoxBorder.all(color: ColorConstant.appThemeColor,width: 2)
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.currency_rupee,
                    color: ColorConstant.appThemeColor,
                  ),
                  Text(
                    '| Rs. ${currentValue.toInt()}',
                    style: TextStyle(
                        fontSize: FontConstants.f12,
                        fontWeight: FontConstants.w600,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.blackTextColor
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: ColorConstant.appThemeColor,
            inactiveTrackColor: Colors.grey,
            thumbColor: ColorConstant.appThemeColor,
            overlayColor: Colors.blue.withOpacity(0.2),
            thumbShape: CustomThumbShape(),
            trackHeight: 4,
          ),
          child: Slider(
            value: currentValue,
            min: minValue,
            max: maxValue,
            // ❌ removed divisions → no dots on UI
            label: currentValue.toStringAsFixed(0),
            onChanged: (value) {
              // ✅ Snap to nearest 500
              double roundedValue = (value / step).round() * step;
              setState(() {
                currentValue = roundedValue;
              });

              DebugPrint.prt("Current Principal Amount $currentValue");

              Future.delayed(const Duration(milliseconds: 500), () {
                calculateLoan(
                  principal: currentValue,
                  tenure: currentTenure,
                  interestRate: double.parse(interestRate.toString()),
                );
              });
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '',
              style: TextStyle(
                  fontSize: FontConstants.f14,
                  fontWeight: FontConstants.w600,
                  fontFamily: FontConstants.fontFamily,
                  color: ColorConstant.blackTextColor
              ),
            ),
            Text(
              'Max Rs. ${maxValue.toInt()}',
              style: TextStyle(
                fontSize: FontConstants.f14,
                fontWeight: FontConstants.w600,
                fontFamily: FontConstants.fontFamily,
                color: ColorConstant.blackTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget tenureSliderAndValue(BuildContext context,{valueType = "Days"}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TENURE",
              style: TextStyle(
                  fontSize: FontConstants.f12,
                  fontFamily: FontConstants.fontFamily,
                  fontWeight: FontConstants.w500,
                  color: ColorConstant.blackTextColor
              ),
              textAlign: TextAlign.start,
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration:BoxDecoration(
                  color: ColorConstant.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: BoxBorder.all(color: ColorConstant.appThemeColor,width: 2)
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: ColorConstant.appThemeColor,
                  ),
                  Text(
                    '| ${currentTenure.toInt()} Days',
                    style: TextStyle(
                        fontSize: FontConstants.f12,
                        fontWeight: FontConstants.w600,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.blackTextColor
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: ColorConstant.appThemeColor,
              inactiveTrackColor: Colors.grey,
              thumbColor: ColorConstant.appThemeColor,
              overlayColor: Colors.blue.withOpacity(0.2),
              thumbShape: CustomThumbShape(),
              trackHeight: 4,
            ),
            child: Slider(
              value: currentTenure,
              min: minTenure,
              max: maxTenure,
              // ❌ removed divisions → smooth slider with no dots
              label: currentTenure.round().toString(),
              onChanged: (value) {
                setState(() {
                  currentTenure = value.roundToDouble(); // round to whole internally
                });
                Future.delayed(const Duration(milliseconds: 500), () {
                  calculateLoan(
                    principal: currentValue,
                    tenure: currentTenure,
                    interestRate: double.parse(interestRate.toString()),
                  );
                });
              },
            )
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '',
              style: TextStyle(
                  fontSize: FontConstants.f14,
                  fontWeight: FontConstants.w600,
                  fontFamily: FontConstants.fontFamily,
                  color: ColorConstant.blackTextColor
              ),
            ),
            Text(
              'Max ${maxTenure.toInt()} Days',
              style: TextStyle(
                fontSize: FontConstants.f14,
                fontWeight: FontConstants.w600,
                fontFamily: FontConstants.fontFamily,
                color: ColorConstant.blackTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget interestAndProcessingFeeUi(BuildContext context,{GenerateLoanOfferModel? generateLoanOfferModel}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ColorConstant.containerBackground,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              gradient: const RadialGradient(
                center: Alignment.center,   // gradient center
                radius: 1.0,                // how far it spreads
                colors: [
                  // Dark teal in center
                  Color(0xFF169DBD),
                  Color(0xFF0A6075),// Light teal on edges
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: FontConstants.horizontalPadding,
                  vertical: FontConstants.horizontalPadding
              ),
              child: Column(
                children: [
                  Image.asset(ImageConstants.interestIcon,height: 24,width: 24),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    generateLoanOfferModel?.data?.interestRateText ??
                        "Interest 1.00% p.d.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: FontConstants.f14,
                        fontWeight: FontConstants.w600,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.whiteColor
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ColorConstant.containerBackground,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              gradient: const RadialGradient(
                center: Alignment.center,   // gradient center
                radius: 1.0,                // how far it spreads
                colors: [
                  // Dark teal in center
                  Color(0xFF169DBD),
                  Color(0xFF0A6075),// Light teal on edges
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: FontConstants.horizontalPadding,
                  vertical: FontConstants.horizontalPadding
              ),
              child: Column(
                children: [
                  Image.asset(ImageConstants.lonProcessIcon,height: 24,width: 24),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    generateLoanOfferModel?.data?.processingFeeText ??
                        "Processing Fee 10%",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: FontConstants.f14,
                        fontWeight: FontConstants.w600,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.whiteColor
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget calculationUI(BuildContext context){
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Principal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Principal",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                 '₹ ${(currentValue % 1 == 0)
                      ? currentValue.toInt().toString()
                      : currentValue.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Interest Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Interest 1% per day",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '₹ $interestAmount',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),



            const SizedBox(height: 12),
            const Divider(thickness: 1),

            // Total Payable Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Payable",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '₹ ${totalPayableAmount}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget totalAmountUI(BuildContext context,{amountType,amountValue}){
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
          color: ColorConstant.containerBackground,
          borderRadius: BorderRadius.all(Radius.circular(6.0))
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: FontConstants.horizontalPadding
        ),
        child: Column(
          children: [
            Text(
              amountType ?? "",
              style: TextStyle(
                  fontSize: FontConstants.f12,
                  fontFamily: FontConstants.fontFamily,
                  fontWeight: FontConstants.w600,
                  color: ColorConstant.dashboardTextColor
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              amountValue == null ? "":
              "Rs.$amountValue",
              style: TextStyle(
                  fontSize: FontConstants.f14,
                  fontWeight: FontConstants.w700,
                  fontFamily: FontConstants.fontFamily,
                  color: ColorConstant.blueTextColor
              ),
            )
          ],
        ),
      ),
    );
  }

  calculateLoan({
    required double principal,
    required double tenure,
    required double interestRate,
  }) {
    double interest = principal * (interestRate / 100) * tenure;
    double totalPayable = principal + interest;
    setState(() {
      interestAmount = (interest % 1 == 0)
          ? interest.toInt().toString()
          : interest.toStringAsFixed(2);

      totalPayableAmount = (totalPayable % 1 == 0)
          ? totalPayable.toInt().toString()
          : totalPayable.toStringAsFixed(2);
    });
  }

  Future<void> checkConditionCalculateDistanceApiCall() async{
    final position = await getCurrentPositionFast();
    final geoLat = position.latitude.toString();
    final geoLong = position.longitude.toString();

    var otpModel = await MySharedPreferences.getUserSessionDataNode();
    VerifyOTPModel verifyOtpModel = VerifyOTPModel.fromJson(jsonDecode(otpModel));
    var leadId = verifyOtpModel.data?.leadId ?? "";
    if (leadId == "") {
      leadId = await MySharedPreferences.getLeadId();
    }
    if (!context.mounted) return;
    var dataObj =  {
      "custId":verifyOtpModel.data?.custId,
      "leadId":leadId,
      "sourceLatitude":geoLat,
      "sourceLongitude":geoLong
    };
    context.read<LoanApplicationCubit>().calculateDistanceApiCall(dataObj);
    Future.delayed(Duration(milliseconds: 300));
  }

  void showRejectConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            "Confirm Reject",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure want to reject this loan offer?",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // Dismiss dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            TextButton(
              onPressed: () async{
                context.pop();
                loanAcceptanceApiCall(context,2);
              },
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

}

class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(30, 30);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // Outer circle with light blue border & white fill
    final Paint outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.lightBlue.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, 12, outerPaint);
    canvas.drawCircle(center, 12, borderPaint);

    // Inner dot (dark blue)
    final Paint innerDotPaint = Paint()
      ..color = ColorConstant.appThemeColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 5, innerDotPaint);
  }
}

// LoanAcceptedId Value
// 1- Accept
//2- Reject
//3 - Enhancement




