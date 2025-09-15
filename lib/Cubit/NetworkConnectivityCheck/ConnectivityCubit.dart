// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class ConnectivityCubit extends Cubit<bool> {
//   late final StreamSubscription _subscription;
//
//   ConnectivityCubit() : super(true) {
//     Connectivity().checkConnectivity().then((result) {
//       final hasConnection = result != ConnectivityResult.none;
//       emit(hasConnection);
//     });
//
//     _subscription = Connectivity().onConnectivityChanged.listen((result) {
//       DebugPrint.prt("Network Connection Status [$result]");
//       final hasConnection = result != ConnectivityResult.none;
//       emit(hasConnection);
//     });
//   }
//
//   @override
//   Future<void> close() {
//     _subscription.cancel();
//     return super.close();
//   }
// }
