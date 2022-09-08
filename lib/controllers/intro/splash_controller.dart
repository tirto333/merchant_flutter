import 'dart:async';

import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/screens/intro/login.dart';
import 'package:winn_merchant_flutter/screens/main_tab.dart';

class SplashController extends GetxController {
  RestApi api = Get.put(RestApi());

  void onInit() {
    redirectToLoginScreen();
    super.onInit();
  }

  void redirectMain() {
    if (api.accessToken != null) {
      Get.off(MainPage());
    }
  }

  void redirectToLoginScreen() {
    Timer(Duration(milliseconds: 100), () {
      redirectMain();
    });
  }

  void toLoginScreen() {
    // Get.to(LoginScreen());
    Get.off(LoginScreen());
  }
}
