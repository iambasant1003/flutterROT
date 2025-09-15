import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan112_app/Constant/ApiUrlConstant/WebviewUrl.dart';
import 'package:loan112_app/Constant/ColorConst/ColorConstant.dart';
import 'package:loan112_app/Constant/FontConstant/FontConstant.dart';
import 'package:loan112_app/Constant/ImageConstant/ImageConstants.dart';
import 'package:loan112_app/Cubit/dashboard_cubit/DashboardCubit.dart';
import 'package:loan112_app/Model/DashBoarddataModel.dart';
import 'package:loan112_app/Routes/app_router_name.dart';
import 'package:loan112_app/Utils/Debugprint.dart';
import 'package:loan112_app/Utils/MysharePrefenceClass.dart';
import 'package:loan112_app/Utils/snackbarMassage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Widget/circular_progress.dart';
import '../../Widget/delete_bottom_sheet.dart';


class Loan112Drawer extends StatefulWidget{

  final DashBoarddataModel? dashBoarddataModel;
  final BuildContext rootContext; // ✅ add this
  const Loan112Drawer({super.key,this.dashBoarddataModel,required this.rootContext});

  @override
  State<StatefulWidget> createState() => _Loan112Drawer();
}

class _Loan112Drawer extends State<Loan112Drawer> {

  String buildNumber = "";
  String versionCode = "";


  @override
  void initState() {
    super.initState();
    DebugPrint.prt("Profile User Name ${widget.dashBoarddataModel?.data?.fullName}, Delete Visibility ${widget.dashBoarddataModel?.data?.isAccountDeleteVisibility}");
    getPackageInformation();
  }

  getPackageInformation() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionCode = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: ColorConstant.appScreenBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 150,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          color: ColorConstant.drawerHeaderColor, // top 70px color
                        ),
                        Container(
                          height: 80,
                          color: ColorConstant.appScreenBackgroundColor, // bottom 70px color
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(FontConstants.horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if(widget.dashBoarddataModel?.data?.profilePic != null)...[
                              Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Progress arc with incomplete part in lightBlue
                                          SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: CircularProgressIndicator(
                                              value: (widget.dashBoarddataModel?.data?.applyLoanBanner?.appBannerProgressPercent ?? 0) / 100,
                                              strokeWidth: 4,
                                              backgroundColor: Colors.lightBlue.shade100,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                                            ),
                                          ),
                                          ClipOval(
                                            child: Image.network(
                                              widget.dashBoarddataModel?.data?.profilePic ?? "",
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 40, color: Colors.grey),
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child:  Text(
                                                    widget.dashBoarddataModel?.data?.fullName ?? "",
                                                    style: TextStyle(
                                                        fontFamily: FontConstants.fontFamily,
                                                        fontSize: FontConstants.f18,
                                                        fontWeight: FontConstants.w800,
                                                        color: ColorConstant.blackTextColor
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          widget.dashBoarddataModel?.data?.mobile ?? "",
                                          //"9090000888",
                                          style: TextStyle(
                                              fontWeight: FontConstants.w600,
                                              fontSize: FontConstants.f12,
                                              fontFamily: FontConstants.fontFamily,
                                              color: ColorConstant.blackTextColor
                                          ),
                                        )
                                      ],
                                    ),
                                  ]
                              )
                            ]
                            else...[
                              Row(
                                children: [
                                  CircularProgressWithText(
                                    progress: (widget.dashBoarddataModel?.data?.applyLoanBanner?.appBannerProgressPercent ?? 0) / 100,
                                    isDrawer: true,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child:  Text(
                                                widget.dashBoarddataModel?.data?.fullName ?? "",
                                                style: TextStyle(
                                                    fontFamily: FontConstants.fontFamily,
                                                    fontSize: FontConstants.f18,
                                                    fontWeight: FontConstants.w800,
                                                    color: ColorConstant.blackTextColor
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        widget.dashBoarddataModel?.data?.mobile ?? "",
                                        //"9090000888",
                                        style: TextStyle(
                                            fontWeight: FontConstants.w600,
                                            fontSize: FontConstants.f12,
                                            fontFamily: FontConstants.fontFamily,
                                            color: ColorConstant.blackTextColor
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Text(
                            "${widget.dashBoarddataModel?.data?.applyLoanBanner!.appBannerProgressPercent?? 0.toString()}%",
                            //"${(0.5 * 100).toInt()}%",
                            style: TextStyle(
                                fontFamily: FontConstants.fontFamily,
                                fontWeight: FontConstants.w800,
                                fontSize: FontConstants.f14,
                                color: ColorConstant.blueTextColor
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   height: 10.0,
              // ),
              Divider(
                height: 1.0,
                color: ColorConstant.greyTextColor.withOpacity(0.5), // 50% opacity
              ),
              SizedBox(
                height: 24.0,
              ),

              // Menu items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(ImageConstants.homeIcon, "Home",
                       onClick: (){
                         // DebugPrint.prt("Home Icon Pressed");
                         context.pop();
                       }
                    ),
                    _buildMenuItem(ImageConstants.drawerFaq, "FAQs",
                      onClick: (){
                        context.pop();
                        context.push(AppRouterName.termsAndConditionWebview,extra: UrlsNods.FAQ);
                      }
                    ),
                    _buildMenuItem(ImageConstants.dashBoardHeadphone, "Support",
                      onClick: (){
                        context.pop();
                        context.push(AppRouterName.customerSupport,extra: widget.dashBoarddataModel);
                      }
                    ),
                    _buildMenuItem(ImageConstants.drawerShareApp, "Share App",
                      onClick: (){
                        DebugPrint.prt("Share Icon Pressed");
                        if(Platform.isIOS){
                          SharePlus.instance.share(
                              ShareParams(text: 'Hey, I found this cool app: https://apps.apple.com/in/app/loan112/id6747157984')
                          );
                        }else{
                          SharePlus.instance.share(
                              ShareParams(text: 'Hey, I found this cool app: https://play.google.com/store/apps/details?id=com.personalLoan.loan112')
                          );
                        }
                      }
                    ),
                    _buildMenuItem(ImageConstants.drawerRateUs, "Rate Us",
                        onClick: (){
                          DebugPrint.prt("Rate Us Pressed");
                          openPlayStore(context);
                    }),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: FontConstants.horizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap:() async{
                        showLogoutConfirmationDialog(context);
                      },
                      child: SvgPicture.asset(
                        ImageConstants.drawerPower,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              const Divider(),
              // Delete Account
              if(widget.dashBoarddataModel?.data?.isAccountDeleteVisibility ?? false)...[
                Padding(
                  padding: EdgeInsets.only(left: FontConstants.horizontalPadding,top: 10.0),
                  child: InkWell(
                    onTap: () {
                      context.pop(); // Close Drawer

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showModalBottomSheet(
                          context: context, // Now it's safe
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (ctx) {
                            return DeleteProfileBottomSheet(
                              onConfirm: () {
                                ctx.read<DashboardCubit>().callDeleteCustomerProfileApi();
                              },
                            );
                          },
                        );
                      });
                    },
                    child: Row(
                      children: [
                        Image.asset(ImageConstants.drawerDelete,height: 20,width: 20),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Delete Account",
                          style: TextStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontConstants.w600,
                              fontSize: FontConstants.f14,
                              color: ColorConstant.errorRedColor
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
              SizedBox(
                height: 24.0,
              ),
              // Version
               Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Version : $buildNumber/$versionCode",
                  style: TextStyle(
                      fontSize: FontConstants.f14,
                      fontWeight: FontConstants.w600,
                      fontFamily: FontConstants.fontFamily,
                      color: ColorConstant.greyTextColor
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            "Confirm Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to log out?",
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
                var logOutData = await MySharedPreferences.logOutFunctionData();
                if(logOutData){
                  context.go(AppRouterName.login);
                }
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            "Delete Account",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                context.read<DashboardCubit>().callDeleteCustomerProfileApi();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }






  Future<void> openPlayStore(BuildContext context) async {
    final Uri playStoreUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.personalLoan.loan112&hl=en_IN&pli=1',
    );
    final iosUrl = Uri.parse(
      "https://apps.apple.com/in/app/loan112/id6747157984"
    );
    if(Platform.isIOS){
      if (!await launchUrl(
        iosUrl,
        mode: LaunchMode.externalApplication,
      )) {
        openSnackBar(context, 'Could not launch $playStoreUrl');
      }
    }else{
      if (!await launchUrl(
        playStoreUrl,
        mode: LaunchMode.externalApplication,
      )) {
        openSnackBar(context, 'Could not launch $playStoreUrl');
      }
    }

  }


  Widget _buildMenuItem(String icon, String title,{onClick}) {
    return ListTile(
      leading: Image.asset(icon, color: ColorConstant.greyTextColor,height: 20,width: 20),
      title: Text(
          title,
         style: TextStyle(
           fontFamily: FontConstants.fontFamily,
           fontSize: FontConstants.f14,
           fontWeight: FontConstants.w600,
           color: ColorConstant.blueTextColor
         ),
      ),
      trailing: const Icon(Icons.arrow_forward, size: 16),
      onTap: onClick,
    );
  }
}


