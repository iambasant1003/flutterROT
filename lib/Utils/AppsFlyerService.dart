// import 'package:appsflyer_sdk/appsflyer_sdk.dart';
//
// class AppsFlyerServiceLoan112 {
//   static final AppsFlyerServiceLoan112 _instance = AppsFlyerServiceLoan112._internal();
//   factory AppsFlyerServiceLoan112() => _instance;
//   AppsFlyerServiceLoan112._internal();
//
//   late final AppsflyerSdk _appsflyerSdk;
//
//   Future<void> initSdk() async {
//     final AppsFlyerOptions options = AppsFlyerOptions(
//       afDevKey: "xwr5L94kv38Jce8aDSNKk6",
//       //appId: , // iOS only
//       showDebug: true,
//     );
//
//     _appsflyerSdk = AppsflyerSdk(options);
//
//     await _appsflyerSdk.initSdk(
//       registerConversionDataCallback: true,
//       registerOnAppOpenAttributionCallback: true,
//       registerOnDeepLinkingCallback: true,
//     );
//   }
//
//   void logEvent(String eventName, Map eventValues) {
//     _appsflyerSdk.logEvent(eventName, eventValues);
//   }
// }
