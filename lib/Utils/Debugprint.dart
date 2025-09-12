import 'package:flutter/foundation.dart';

class DebugPrint {
  static prt(String msg) {
    if (kDebugMode) {
      print(msg);
    }
  }
}
