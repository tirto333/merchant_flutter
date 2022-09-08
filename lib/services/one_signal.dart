import 'dart:io';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:winn_merchant_flutter/config/config.dart';

String oneSignalId = Config.oneSignalId;

class OneSignalSdk {
  bool oktest = false;
  final initOnsignal = OneSignal.shared.setAppId(oneSignalId);

  Future<void> promtUser() async {
    if (Platform.isAndroid) {
      return;
    }
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  Future<OSDeviceState?> getPermissionState() {
    return OneSignal.shared.getDeviceState();
  }

  void initialize() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent notification) {});

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
  }
}
