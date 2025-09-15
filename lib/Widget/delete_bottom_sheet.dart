import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/FontConstant/FontConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Widget/bottom_dashline.dart';
import 'package:rupeeontime/Widget/common_button.dart';

class DeleteProfileBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteProfileBottomSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(FontConstants.horizontalPadding),
            child: Column(
              children: [
                // Icon
                Image.asset(ImageConstants.deleteProfileIcon,height: 50,width: 50),
                SizedBox(height: 12),

                // Title
                Text(
                  "Delete Profile will do the Following",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontConstants.w800,
                      fontSize: FontConstants.f18,
                      fontFamily: FontConstants.fontFamily,
                      color: ColorConstant.blackTextColor
                  ),
                ),
                SizedBox(height: 16),

                // Info Box
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(ImageConstants.deleteProfileInformation,height: 18,width: 18),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "Navigate through the account deletion process to securely remove your Account from our system. This process will make your account permanently unusable.",
                          style: TextStyle(
                              fontSize: FontConstants.f12,
                              fontWeight: FontConstants.w500,
                              fontFamily: FontConstants.fontFamily,
                              color: ColorConstant.dashboardTextColor
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Bullet Points
                buildBulletPoint(
                    "Deleting your profile will permanently remove all your account data from our system"),
                buildBulletPoint(
                    "Once deleted your account cannot be recovered and all the associated information will be lost"),
                buildBulletPoint(
                    "Ensure all the pending transaction, repayments, or loan processes are completed before initiating the deletion"),
                SizedBox(height: 24),
              ],
            ),
          ),

          BottomDashLine(),
          SizedBox(height: 12),
          // Action Buttons
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: FontConstants.horizontalPadding),
            child: Row(
              children: [
                Expanded(
                  child:  TextButton(
                      onPressed: (){
                        context.pop();
                      },
                      child: Text(
                        "No, Cancel",
                        style: TextStyle(
                            fontSize: FontConstants.f14,
                            fontWeight: FontConstants.w700,
                            fontFamily: FontConstants.fontFamily,
                            color: Color(0xffD93C65)
                        ),
                      )
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                    child: Loan112Button(
                      text: "Yes, Confirm",
                      onPressed: (){
                         onConfirm();
                        // Future.delayed(Duration(milliseconds: 300), () {
                        //   context.pop();
                        // });
                      },
                      fontSize: FontConstants.f14,
                      fontWeight: FontConstants.w700,
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Image.asset(ImageConstants.deleteProfileInstruction,height: 18,width: 18),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: FontConstants.f12,
                  fontFamily: FontConstants.fontFamily,
                  fontWeight: FontConstants.w500,
                  color: Color(0xff60708F)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
