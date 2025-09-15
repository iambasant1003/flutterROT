
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Utils/Debugprint.dart';
import 'di/di_locator.dart';
import 'main.dart';


// Handle messages in background

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  DebugPrint.prt('🔕 Handling a background message: ${message.messageId}');
}


Future<void> mainCommon(String env) async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Enable Crashlytics in debug mode for testing
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Catch uncaught errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  //await AppsFlyerServiceLoan112().initSdk();

  // setup DI
  setupLocator();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: ColorConstant.appThemeColor));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Colors.pink, // status bar color
  ));
  runApp(MyApp(environment: env));
}



//In ios Release.xcconfig update that target folder
//lib/main_dev.dart

