import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Widget/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomerKycWebview extends StatefulWidget {
  final String kycWebUrl;
  const CustomerKycWebview({super.key,required this.kycWebUrl});

  @override
  State<CustomerKycWebview> createState() => _CustomerKycWebview();
}

class _CustomerKycWebview extends State<CustomerKycWebview> {
  late final WebViewController _controller;


  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Please Wait...');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {},
          onPageFinished: (url) {
            EasyLoading.dismiss();
          },
          onWebResourceError: (error) {
            EasyLoading.dismiss();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.kycWebUrl));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadRequest(Uri.parse(widget.kycWebUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Loan112AppBar(
        customLeading: InkWell(
          onTap: (){
            context.pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.blackTextColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: (){
              context.pop();
            },
            child: Image.asset(
                ImageConstants.crossIcon,
                height: 30,
            ),
          )
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: WebViewWidget(controller: _controller),
      )
    );
  }
}
