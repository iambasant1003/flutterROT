import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rupeeontime/Constant/ColorConst/ColorConstant.dart';
import 'package:rupeeontime/Constant/ImageConstant/ImageConstants.dart';
import 'package:rupeeontime/Widget/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../Constant/FontConstant/FontConstant.dart';

class CustomerKycWebview extends StatefulWidget {
  final String kycWebUrl;
  const CustomerKycWebview({super.key, required this.kycWebUrl});

  @override
  State<CustomerKycWebview> createState() => _CustomerKycWebviewState();
}

class _CustomerKycWebviewState extends State<CustomerKycWebview> {
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
          onPageFinished: (url) async {
            EasyLoading.dismiss();

            /// ✅ Hide toolbar after delay
            Future.delayed(const Duration(seconds: 5), () {
              _hideToolbarInsideWebPage();
            });
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

  /// ✅ Function to hide the header toolbar inside the web page
  void _hideToolbarInsideWebPage() {
    _controller.runJavaScript("""
      (function() {
        var header = document.querySelector('.header-ele');
        if(header){
          header.style.display = 'none';
        }
      })();
    """);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  Loan112AppBar(
        customLeading: InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: ColorConstant.whiteColor),
        ),
        title: Text(
          "Fetch Bank Statement",
          style: TextStyle(
            fontSize: FontConstants.f20,
            fontWeight: FontConstants.w800,
            fontFamily: FontConstants.fontFamily,
            color: ColorConstant.whiteColor,
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24)
            )
          ),
            child: WebViewWidget(controller: _controller)),
      ),
    );
  }
}
