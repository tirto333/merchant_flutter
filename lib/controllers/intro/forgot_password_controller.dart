import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController email = new TextEditingController();

  // Initiate Other controller
  RestApi api = Get.find<RestApi>();
  bool isComplete = false;

  void submit(context) async {
    try {
      CustomShowDialog().openLoading(context);
      var response = await api.authPost(
        endpoint: '/forgot-password',
        data: {
          "email": email.text,
        },
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        CustomShowDialog().closeLoading();
        email.text = '';
        Get.back();
        Get.snackbar(
          'Success',
          'Password has been reset, please check your email',
          // 'New Password sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white
        );
      } else {
        CustomShowDialog().closeLoading();
        Get.snackbar(
          'Error',
          response.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
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

  void validate() {
    if (isValid) {
      isComplete = true;
    } else {
      isComplete = false;
    }
    update();
  }

  bool get isValid {
    return email.text.trim() != '';
  }
}
