import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:loan112_app/Constant/ColorConst/ColorConstant.dart';
import 'package:loan112_app/Utils/Debugprint.dart';

import 'animated_network.dart';

class Loan112AppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool showBackButton;
  final Widget? customLeading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double? leadingSpacing;
  final Color? backgroundColor;

  /// 👇 control AppBar height
  final double toolbarHeight;

  const Loan112AppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.customLeading,
    this.actions,
    this.centerTitle = false,
    this.leadingSpacing,
    this.backgroundColor,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  State<Loan112AppBar> createState() => _Loan112AppBarState();

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}

class _Loan112AppBarState extends State<Loan112AppBar> {
  bool _hasInternet = true;
  bool _showRestoredMsg = false;
  StreamSubscription<InternetStatus>? _subscription;
  Timer? _restoreTimer;

  @override
  void initState() {
    super.initState();
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    _subscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
          switch (status) {
            case InternetStatus.connected:
              DebugPrint.prt("Connected Internet");
              if (!_hasInternet) {
                setState(() {
                  _hasInternet = true;
                  _showRestoredMsg = true;
                });

                _restoreTimer?.cancel();
                _restoreTimer = Timer(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() => _showRestoredMsg = false);
                  }
                });
              }
              break;

            case InternetStatus.disconnected:
              DebugPrint.prt("Disconnected Internet");
              setState(() {
                _hasInternet = false;
                _showRestoredMsg = false;
              });
              _restoreTimer?.cancel();
              break;
          }
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _restoreTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bannerHeight = (!_hasInternet || _showRestoredMsg) ? 32.0 : 0.0;

    Widget? leadingWidget;
    if (widget.customLeading != null) {
      leadingWidget = widget.customLeading;
    } else if (widget.showBackButton) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: ColorConstant.blackTextColor,
        onPressed: () {
          context.pop();
        },
      );
    }

    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            leadingWidth: widget.leadingSpacing,
            toolbarHeight: widget.toolbarHeight,
            leading: leadingWidget != null
                ? Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: leadingWidget,
            )
                : const SizedBox.shrink(),

            /// 👇 Centered logo (default if title not passed)
            title: widget.title ??
                Image.asset(
                  "assets/images/app_logo.png", // change to your logo path
                  height: widget.toolbarHeight * 0.6,
                  fit: BoxFit.contain,
                ),

            centerTitle: true, // always center
            actions: widget.actions,
            backgroundColor: widget.backgroundColor ?? Colors.transparent,
            elevation: 0,
          ),
          /*
          AnimatedNetworkStatus(
            isNetworkAvailable: _hasInternet,
          ),
          */
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    double bannerHeight = (!_hasInternet || _showRestoredMsg) ? 32.0 : 0.0;
    return Size.fromHeight(widget.toolbarHeight + bannerHeight);
  }
}
