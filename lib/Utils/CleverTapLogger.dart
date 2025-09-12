import 'package:clevertap_plugin/clevertap_plugin.dart';

import 'CleverTapEventsName.dart';

class CleverTapLogger {
  static void logEvent(String eventName, {required bool isSuccess}) {
    final status = isSuccess 
        ? CleverTapEventsName.SUCCESS 
        : CleverTapEventsName.FAILED;

    CleverTapPlugin.recordEvent(
      eventName,
      {"status": status},
    );
  }
}
