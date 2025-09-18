import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Model/DashBoarddataModel.dart';
import 'package:rupeeontime/Utils/Debugprint.dart';
import 'package:rupeeontime/Utils/MysharePrefenceClass.dart';
import 'package:rupeeontime/Utils/snackbarMassage.dart';
import 'package:rupeeontime/Widget/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupportUiScreen extends StatefulWidget {
  const CustomerSupportUiScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerSupportUiScreen();
}

class _CustomerSupportUiScreen extends State<CustomerSupportUiScreen> {
  int selectedIndex = 1;

  String contactEmail ="";
  String contactNumber = "";
  String contactWhatsAppNumber = "";

  final List<Map<String, dynamic>> contactOptions = [
    {
      'icon': Icons.email_outlined,
      'label': 'EMAIL US',
    },
    {
      'icon': Icons.call_outlined,
      'label': 'CALL US',
    },
    {
      'icon': Icons.chat_outlined,
      'label': 'CHAT WITH US',
    },
  ];


  @override
  void initState() {
    super.initState();
    getAllData();
  }


  void getAllData() async{
    contactEmail = await MySharedPreferences.getContactUsEmail();
    contactNumber = await MySharedPreferences.getCallUsNumber();
    contactWhatsAppNumber = await MySharedPreferences.getChatUsNumber();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appThemeColor,
      appBar: Loan112AppBar(
        showBackButton: true,
        customLeading: InkWell(
          onTap: (){
            context.pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: ColorConstant.whiteColor,
          ),
        ),
        title: Text(
          "Customer Support",
          style: TextStyle(
            fontSize: FontConstants.f18,
            fontWeight: FontConstants.w800,
            fontFamily: FontConstants.fontFamily,
            color: ColorConstant.whiteColor,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0),
            topLeft: Radius.circular(40.0),
          )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: FontConstants.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 57.0),
                Text(
                  "Assistant at your fingertip-connect with our dedicated support team for prompt solution and personalized assistance",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: FontConstants.f14,
                    fontFamily: FontConstants.fontFamily,
                    fontWeight: FontConstants.w600,
                    color: const Color(0xff4E4F50),
                  ),
                ),
                SizedBox(height: 52.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    supportTabUI(
                      context,
                      iconPath: ImageConstants.rotEmailUs, title: "Email",
                      onTap: (){
                        launchEmail(toEmail: contactEmail);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    supportTabUI(
                      context,
                      iconPath: ImageConstants.rotCallUs, title: "Call Us",
                      onTap: (){
                        dialPhoneNumber(contactNumber);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    supportTabUI(
                      context,
                      iconPath: ImageConstants.rotChatWithUS, title: "Chat with Us",
                      onTap: (){
                        openWhatsAppChat(contactWhatsAppNumber);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Image.asset(
                  ImageConstants.rotCustomerSupport
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget supportTabUI(BuildContext context,{required iconPath,required title,required onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: ColorConstant.appThemeColor,
                width: 1.0
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(
                iconPath,
                height: 23,
                width: 23,
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: FontConstants.f16,
                    fontWeight: FontConstants.w400,
                    fontFamily: FontConstants.fontFamily,
                    color: ColorConstant.appThemeColor
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: ColorConstant.appThemeColor,
                size: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> dialPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
       openSnackBar(context, 'Could not launch $phoneUri');
    }
  }


  Future<void> launchEmail({
    required String toEmail,
    String subject = '',
    String body = '',
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: toEmail,
      queryParameters: {
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      openSnackBar(context,'Could not launch $emailUri');
    }
  }


  Future<void> openWhatsAppChat(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      openSnackBar(context,'Could not open WhatsApp for number: $phoneNumber');
    }
  }


}
