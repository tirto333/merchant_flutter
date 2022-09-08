import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:winn_merchant_flutter/controllers/intro/verify_email_controller.dart';
import 'package:winn_merchant_flutter/controllers/main_tab_controller.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/screens/intro/forgot_password.dart';
import 'package:winn_merchant_flutter/services/one_signal.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

class LoginController extends GetxController {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  // Initiate Other controller
  RestApi api = Get.find<RestApi>();
  VerifyEmailController verify = Get.put(VerifyEmailController());
  MainPageController main = Get.put(MainPageController());

  GetStorage token = GetStorage('token');

  void toForgotPassword() {
    Get.to(ForgotPasswordScreen());
  }

  void login(context) async {
    try {
      CustomShowDialog().openLoading(context);
      var onesignal = await OneSignalSdk().getPermissionState();

      var data = {
        "email": email.text,
        "password": password.text,
        "token_onesignal": onesignal?.userId,
      };

      // print("login params ${onesignal!.hasNotificationPermission}");
      // print("login params ${onesignal.emailAddress}");
      // print("login params ${onesignal.emailUserId}");

      print("DATA JSON ${jsonEncode(data)}");


      var response = await api.authPost(
        endpoint: '/login',
        data: data,
        page: 'login',
        contentType: "application/json",
      );

      print("login params $data");

      print("login response $response");

      if (response != null && response.statusCode == 200) {
        //Check Email Verified
        if (response.data['token'] == null) {
          CustomShowDialog().closeLoading();
          // verify.toEmailVerify(userEmail: email.text);
        } else {
          // api.saveToken(
          //   tokenData: response.data['token'],
          // );
          // api.updateToken(
          //   token: response.data['token'],
          // );
          token.write('access', response.data['token']);
          api.updateToken(
            token: response.data['token'],
          );
          CustomShowDialog().closeLoading();
          main.resetIndex();
        }
      }
      else{
        CustomShowDialog().closeLoading();
        Get.snackbar(
          'Error',
          "Wrong Password or Email",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on ErrorResModel catch (e) {
      print("login error ${e.message}");
      CustomShowDialog().closeLoading();
      Get.snackbar(
        'Error',
        e.message.toString(),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
