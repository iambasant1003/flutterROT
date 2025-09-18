import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../Constant/ColorConst/ColorConstant.dart';
import '../../Widget/app_bar.dart';

class TermsAndConditionScreen extends StatefulWidget{
  final String webUrl;
  const TermsAndConditionScreen({super.key,required this.webUrl});

  @override
  State<StatefulWidget> createState() => _TermsAndConditionScreen();

}

class _TermsAndConditionScreen extends State<TermsAndConditionScreen>{


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
      ..loadRequest(Uri.parse(widget.webUrl));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadRequest(Uri.parse(widget.webUrl));
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
            Icons.arrow_back,
            color: ColorConstant.whiteColor,
          ),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

}