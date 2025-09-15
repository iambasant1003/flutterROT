import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Widget/common_success.dart';
import '../../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../../Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import '../../../../Model/SendPhpOTPModel.dart';
import '../../../../Utils/MysharePrefenceClass.dart';
import '../../../../Widget/common_button.dart';


class EkycMessageScreen extends StatefulWidget{
  const EkycMessageScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EkycMessageScreen();
}

class _EkycMessageScreen extends State<EkycMessageScreen>{
  bool _isApiCalled = false;

  Future<void> _handleContinue() async {
    if (!_isApiCalled) {
      _isApiCalled = true;
      // await _getCustomerDetails();
      if (mounted) context.replace(AppRouterName.selfieScreenPath);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Loan112VerifyStatusPage(
          isSuccess: true,
          onBackPress: (){
            _handleContinue();
          },
          statusType: "Congratulations!",
          statusMessage: "You have successfully done the E-KYC.",
          iconTypePath: ImageConstants.adarIcon,
          loan112button: Loan112Button(
            onPressed: () {
              _handleContinue();
            },
            text: "CONTINUE",
          )
      ),
    );
  }


  Future<void> _getCustomerDetails() async {
    try {
      context.read<DashboardCubit>().callDashBoardApi();

      final otpModelJson = await MySharedPreferences.getPhpOTPModel();
      if (otpModelJson != null) {
        final model = SendPhpOTPModel.fromJson(jsonDecode(otpModelJson));

        if (model.data?.custProfileId != null) {
          await context.read<LoanApplicationCubit>().getCustomerDetailsApiCall({
            "cust_profile_id": model.data!.custProfileId!,
          });
        }
      }
    } catch (e) {
      debugPrint("Error in getCustomerDetailsApiCall: $e");
      // You could show a Snackbar here or handle error gracefully
    }
  }

}

