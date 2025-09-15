
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Constant/ColorConst/ColorConstant.dart';
import 'package:loan112_app/Cubit/dashboard_cubit/DashboardCubit.dart';
import 'package:loan112_app/Cubit/dashboard_cubit/DashboardState.dart';
import 'package:loan112_app/Model/DashBoarddataModel.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Utils/snackbarMassage.dart';
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
                backgroundColor: ColorConstant.appScreenBackgroundColor,
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



  Widget bottomNavigationWidget(BuildContext context){
    return BlocBuilder<DashboardCubit,DashboardState>(
      builder: (context,state){
        if(state is DashBoardSuccess){
            dashBoardModel = state.dashBoardModel;
        }
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: FontConstants.horizontalPadding,
                left: FontConstants.horizontalPadding,
                right: FontConstants.horizontalPadding
            ),
            child: Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF2B3C74),
                      Color(0xFF5171DA),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:FontConstants.horizontalPadding,vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: (){},
                        child: Column(
                          children: [
                            Image.asset(
                                ImageConstants.homeIcon,
                                color: selectedIndex ==0? ColorConstant.whiteColor:ColorConstant.greyTextColor,
                                width: 24,height: 24),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Home",
                              style: TextStyle(
                                fontSize: FontConstants.f12,
                                fontFamily: FontConstants.fontFamily,
                                fontWeight: FontConstants.w500,
                                color: selectedIndex ==0? ColorConstant.whiteColor:ColorConstant.greyTextColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!context.mounted) return; // this is more precise in newer Flutter
                            if(dashBoardModel?.data?.applicationSubmitted ==1){
                              context.push(AppRouterName.dashBoardStatus);
                            }else{
                              openSnackBar(context, "Loan application is not completed");
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Image.asset(ImageConstants.dashboardStatusIcon,
                                color: dashBoardModel?.data?.applicationSubmitted ==1? ColorConstant.whiteColor:ColorConstant.greyTextColor,
                                width: 24,height: 24),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Status",
                              style: TextStyle(
                                fontSize: FontConstants.f12,
                                fontFamily: FontConstants.fontFamily,
                                fontWeight: FontConstants.w500,
                                color: dashBoardModel?.data?.applicationSubmitted ==1? ColorConstant.whiteColor:ColorConstant.greyTextColor,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ),
          ),
        );
      },
    );
  }
}

