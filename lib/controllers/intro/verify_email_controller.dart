import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/main_tab_controller.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/helpers/code_process.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/screens/intro/verify_email.dart';
import 'package:winn_merchant_flutter/services/one_signal.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';
import 'dart:async';

class VerifyEmailController extends GetxController {
  List<TextEditingController> nums = List.generate(
    6,
    (index) => TextEditingController(),
  );
  late String? email;
  bool isComplete = false;
  Timer? timer;
  int start = 30;

  // Other Controller
  RestApi api = Get.find<RestApi>();
  MainPageController main = Get.put(MainPageController());

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
          update(['count-down']);
        } else {
          start--;
          update(['count-down']);
        }
      },
    );
  }

  void onInit() {
    super.onInit();
  }

  void onChange() {
    for (int i = 0; i < nums.length; i++) {
      if (nums[i].text.trim() == "") {
        isComplete = false;
        update(['resend']);
        return;
      }

      if (i == nums.length - 1 && nums[i].text.trim() != "") {
        isComplete = true;
        update(['resend']);
      }
    }
  }

  void resendCode() async {
    try {
      await api.authPost(
        endpoint: '/resend-verify',
        data: {
          "email": email,
        },
        contentType: 'application/json',
        page: 'send-code',
      );
      start = 30;
      startTimer();
      Get.snackbar(
        'Success',
        'New verification code has being sent to your email',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on ErrorResModel catch (e) {
      CustomShowDialog().closeLoading();
      Get.snackbar(
        'Error',
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toEmailVerify({String? userEmail}) async {
    email = userEmail;

    nums = List.generate(
      6,
      (index) => TextEditingController(),
    );

    await api.authPost(
      endpoint: '/resend-verify',
      data: {
        "email": userEmail,
      },
      contentType: 'application/json',
      page: 'send-code',
    );

    startTimer();
    Get.off(VerifyEmailScreen());
    update();
  }

  void submit(context) async {
    try {
      CustomShowDialog().openLoading(context);

      var onesignal = await OneSignalSdk().getPermissionState();

      String stringCode = CodeProcessing().emailVerificationCode(nums);

      var response = await api.authPost(
        endpoint: '/verify',
        data: {
          "email": email,
          "verification_code": stringCode,
          "token_onesignal": onesignal?.userId,
        },
        contentType: 'application/json',
        page: 'email-verify',
      );

      if (response.statusCode == 200) {
        api.saveToken(
          tokenData: response.data['token'],
        );

        api.updateToken(
          token: response.data['token'],
        );
        CustomShowDialog().closeLoading();
        main.resetIndex();
      }
    } on ErrorResModel catch (e) {
      CustomShowDialog().closeLoading();
      Get.snackbar(
        'Error',
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
