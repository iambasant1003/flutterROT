import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loan112_app/BlocProvider/app_repository_provider.dart';
import '../../BlocProvider/bloc_provider.dart';
import '../../Utils/Debugprint.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'Constant/ColorConst/ColorConstant.dart';
import 'Constant/ConstText/ConstText.dart';
import 'Routes/app_router.dart';
import 'Utils/AppConfig.dart';

/// 👇 declare a global RouteObserver
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatefulWidget {
  final String environment;

  const MyApp({super.key, required this.environment});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AppConfig.init(widget.environment);
    configLoading();
    _getPackageName();
  }

  Future<void> _getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DebugPrint.prt("Package Name IOS ${packageInfo.packageName}");
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: appRepositoryProviders,
      child: MultiBlocProvider(
        providers: appBlocProviders,
        child: ScreenUtilInit(
          designSize: const Size(414, 896),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: ConstText.appName,
                theme: ThemeData(
                  useMaterial3: false,
                  fontFamily: ConstText.fontType,
                  primaryColor: ColorConstant.appThemeColor,
                  scaffoldBackgroundColor: ColorConstant.whiteColor,
                  appBarTheme: AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: ColorConstant.appThemeColor,
                    ),
                  ),
                ),
                routerConfig: appRouter, // 👈 keep this only
                builder: EasyLoading.init(),
              ),
            );
          },
        ),
      ),
    );
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.orange
      ..backgroundColor = Colors.grey[100]
      ..indicatorColor = ColorConstant.appThemeColor
      ..textColor = Colors.grey
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}
