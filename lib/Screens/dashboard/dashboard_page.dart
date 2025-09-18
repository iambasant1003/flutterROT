
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Cubit/dashboard_cubit/DashboardCubit.dart';
import 'package:rupeeontime/Cubit/dashboard_cubit/DashboardState.dart';
import 'package:rupeeontime/Model/DashBoarddataModel.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import '../../Constant/FontConstant/FontConstant.dart';
import '../../Constant/ImageConstant/ImageConstants.dart';
import '../../Utils/Debugprint.dart';
import '../../Widget/app_bar.dart';
import '../drawer/drawer_page.dart';
import 'dashboard_home.dart';

class DashBoardPage extends StatefulWidget{
  const DashBoardPage({super.key});

  @override
  State<StatefulWidget> createState() => _DashBoardPage();
}

class _DashBoardPage extends State<DashBoardPage>{



  int selectedIndex = 0;
  DashBoarddataModel? dashBoardModel;
  DashBoarddataModel? dashBoardModelVar;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async{
          context.read<DashboardCubit>().callDashBoardApi();
        },
        child: WillPopScope(
            onWillPop: () async{
              return false;
            },
            child: Scaffold(
                backgroundColor: ColorConstant.whiteColor,
                drawer: BlocBuilder<DashboardCubit,DashboardState>(
                  builder: (context,state){
                    if(state is DashBoardSuccess){
                      dashBoardModelVar = state.dashBoardModel;
                    }
                    return Loan112Drawer(
                        rootContext: context,
                        dashBoarddataModel: dashBoardModelVar
                    );
                  },
                ),
                appBar: Loan112AppBar(
                  leadingSpacing: 55,
                  toolbarHeight: 100,
                  backgroundColor: ColorConstant.appThemeColor,
                  centerTitle: true,
                  title: Builder(
                      builder: (context)=> InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          width: 165,
                          height: 91,
                          decoration: BoxDecoration(
                            color: ColorConstant.whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0)
                            )
                          ),
                          child: Center(
                            child: Image.asset(
                              ImageConstants.appIconLogo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      )
                  ),
                  customLeading: Builder(
                    builder: (context) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Image.asset(
                          ImageConstants.drawerMenuIcon,
                          color: ColorConstant.whiteColor,
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          DebugPrint.prt("Headphone is tapped");
                          context.push(AppRouterName.customerSupport);
                        },
                        child: Image.asset(
                          ImageConstants.dashBoardHeadphone,
                          height: 35,
                          width: 35,
                          color: ColorConstant.whiteColor,
                        ),
                      ),
                    )
                  ],
                ),
                body: DashBoardHome(),
                bottomNavigationBar: bottomNavigationWidget(context)
            )
        ),
    );
  }


  Widget bottomNavigationWidget(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashBoardSuccess) {
          dashBoardModel = state.dashBoardModel;
        }
        return SafeArea(
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: ColorConstant.whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home
                _buildNavItem(
                  context,
                  index: 0,
                  label: "Home",
                  icon: ImageConstants.rotDashboardHomeIcon,
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),

                // Loan Status
                _buildNavItem(
                  context,
                  index: 1,
                  label: "Loan Status",
                  icon: ImageConstants.rotDashboardStatusIcon,
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;
                      if (dashBoardModel?.data?.applicationSubmitted == 1) {
                        context.push(AppRouterName.dashBoardStatus);
                      } else {
                        openSnackBar(
                            context, "Loan application is not completed");
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// helper widget
  Widget _buildNavItem(
      BuildContext context, {
        required int index,
        required String label,
        required String icon,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstant.appThemeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
              color:
              isSelected ? ColorConstant.whiteColor : ColorConstant.greyTextColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: FontConstants.f12,
                fontFamily: FontConstants.fontFamily,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? ColorConstant.whiteColor
                    : ColorConstant.greyTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

