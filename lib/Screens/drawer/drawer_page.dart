import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ApiUrlConstant/WebviewUrl.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Cubit/dashboard_cubit/DashboardCubit.dart';
import 'package:rupeeontime/Model/DashBoarddataModel.dart';
import 'package:rupeeontime/Routes/app_router_name.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/MysharePrefenceClass.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rupeeontime/Widget/common_button.dart';
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
        color: ColorConstant.whiteColor,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xffE1ECEE),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    child: widget.dashBoarddataModel?.data?.profilePic != null?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                  backgroundColor: ColorConstant.appThemeColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(ColorConstant.appThemeColor),
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
                          height: 20,
                        ),
                        Text(
                          "${widget.dashBoarddataModel?.data?.applyLoanBanner!.appBannerProgressPercent?? 0.toString()}%",
                          //"${(0.5 * 100).toInt()}%",
                          style: TextStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontConstants.w800,
                              fontSize: FontConstants.f14,
                              color: ColorConstant.blackTextColor
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.dashBoarddataModel?.data?.fullName ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontConstants.f18,
                              fontWeight: FontConstants.w800,
                              color: ColorConstant.blackTextColor
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        callingUI(context,widget.dashBoarddataModel?.data?.mobile ?? "")
                      ],
                    ):
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                  backgroundColor: ColorConstant.appThemeColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(ColorConstant.appThemeColor),
                                ),
                              ),
                              ClipOval(
                                child: Image.asset(
                                  ImageConstants.rotProfileIcon,
                                  width: 70,
                                  height: 70
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${widget.dashBoarddataModel?.data?.applyLoanBanner!.appBannerProgressPercent?? 0.toString()}%",
                          //"${(0.5 * 100).toInt()}%",
                          style: TextStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontConstants.w800,
                              fontSize: FontConstants.f14,
                              color: ColorConstant.blackTextColor
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        (widget.dashBoarddataModel?.data?.fullName != null)?
                        Text(
                          widget.dashBoarddataModel?.data?.fullName ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontConstants.f18,
                              fontWeight: FontConstants.w800,
                              color: ColorConstant.blackTextColor
                          ),
                        ):
                        Text(
                          "Hello, User",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontConstants.f18,
                              fontWeight: FontConstants.w800,
                              color: ColorConstant.blackTextColor
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        callingUI(context,widget.dashBoarddataModel?.data?.mobile ?? "")
                      ],
                    )
                ),
              ),
              SizedBox(
                height: 27.0,
              ),
              // Menu items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
                  children: [
                    _buildMenuItem(ImageConstants.drawerFaq, "FAQs",
                      onClick: (){
                        context.pop();
                        context.push(AppRouterName.termsAndConditionWebview,extra: UrlsNods.FAQ);
                      }
                    ),
                    Divider(
                      height: 1.0,
                      color: ColorConstant.greyTextColor,
                    ),
                    _buildMenuItem(ImageConstants.dashBoardHeadphone, "Support",
                      onClick: (){
                        context.pop();
                        context.push(AppRouterName.customerSupport,extra: widget.dashBoarddataModel);
                      }
                    ),
                    Divider(
                      height: 1.0,
                      color: ColorConstant.greyTextColor,
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
                    Divider(
                      height: 1.0,
                      color: ColorConstant.greyTextColor,
                    ),
                    _buildMenuItem(ImageConstants.drawerRateUs, "Rate Us",
                        onClick: (){
                          DebugPrint.prt("Rate Us Pressed");
                          openPlayStore(context);
                    }),
                    Divider(
                      height: 1.0,
                      color: ColorConstant.greyTextColor,
                    ),
                  if(widget.dashBoarddataModel?.data?.isAccountDeleteVisibility ?? false)...[
                    Column(
                      children: [
                        _buildMenuItem(ImageConstants.drawerRateUs, "Delete Account",
                            onClick: (){
                              DebugPrint.prt("Rate Us Pressed");
                            }),
                        Divider(
                          height: 1.0,
                          color: ColorConstant.greyTextColor,
                        ),
                      ],
                    )
                  ]
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(FontConstants.horizontalPadding),
                child:  Loan112Button(
                  backGroundColor: Color(0xffD93C65),
                  onPressed: (){
                    context.pop();
                    showLogoutConfirmationDialog(context);
                  },
                  text: "Logout",
                  textColor: ColorConstant.whiteColor,
                  fontSize: FontConstants.f14,
                  fontFamily: FontConstants.fontFamily,
                  fontWeight: FontConstants.w500,
                )
              ),
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

  Widget callingUI(BuildContext context,String mobileNumber){
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ImageConstants.rotProfileCallIcon,
          height: 14,
          width: 14,
        ),
        SizedBox(
          width: 8.0,
        ),
        Text(
          mobileNumber,
          style: TextStyle(
              fontWeight: FontConstants.w600,
              fontSize: FontConstants.f12,
              fontFamily: FontConstants.fontFamily,
              color: ColorConstant.blackTextColor
          ),
        )
      ],
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
      title: Text(
          title,
         style: TextStyle(
           fontFamily: FontConstants.fontFamily,
           fontSize: FontConstants.f14,
           fontWeight: FontConstants.w600,
           color: ColorConstant.blackTextColor
         ),
      ),
      onTap: onClick,
    );
  }
}


