import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Widget/common_button.dart';
import '../../../Constant/ColorConst/ColorConstant.dart';
import '../../../Constant/FontConstant/FontConstant.dart';
import '../../../Constant/ImageConstant/ImageConstants.dart';
import '../../../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../../../Widget/app_bar.dart';
import '../../../Widget/bottom_dashline.dart';
import '../../../Widget/eligibility_status_background.dart';

class PaymentStatusPage extends StatefulWidget {
  const PaymentStatusPage({super.key});

  @override
  State<StatefulWidget> createState() => _PaymentStatusPage();
}

class _PaymentStatusPage extends State<PaymentStatusPage>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Loan112AppBar(
        backgroundColor: Color(0xffE7F3FF),
        customLeading: InkWell(
          onTap: (){
                context.push(AppRouterName.dashboardPage);
                context.read<DashboardCubit>().callDashBoardApi();
              },
          child: Icon(Icons.arrow_back_ios,color: ColorConstant.blackTextColor),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Loan112ConcaveContainer(height: 150),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: -60,
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              color: ColorConstant.whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(ImageConstants.successIcon),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 65),
                    Text(
                      "Thankyou!",
                      style: TextStyle(
                        fontSize: FontConstants.f22,
                        fontWeight: FontConstants.w800,
                        fontFamily: FontConstants.fontFamily,
                        color: ColorConstant.blackTextColor,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      "Your Payment is successfully done!",
                      style: TextStyle(
                        fontSize: FontConstants.f14,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontConstants.w500,
                        color: ColorConstant.blackTextColor,
                      ),
                    ),
                    const SizedBox(height: 43.0),
                  ],
                ),
              ),
            ),
            // 👇 Buttons pinned to bottom
            Column(
              children: [
                BottomDashLine(),
                SizedBox(
                  height: 18.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                  child: Column(
                    children: [
                      Loan112Button(
                        text: "GO TO DASHBOARD",
                        onPressed: (){
                          context.push(AppRouterName.dashboardPage);
                          context.read<DashboardCubit>().callDashBoardApi();
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}