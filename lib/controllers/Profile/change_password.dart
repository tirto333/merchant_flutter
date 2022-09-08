import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

class ChangePasswordController extends GetxController {
  TextEditingController oldPassword = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();

  bool oldPasswordReqPass = false;
  bool newPasswordReqPass = false;
  bool confirmPasswordReqPass = false;
  bool isComplete = false;

  //Other Controller
  RestApi api = Get.find<RestApi>();

  void onInit() {
    super.onInit();
  }

  void onClose() {
    oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }

  void validate() {
    if (oldPassword.text.trim() != '') {
      // if (oldPassword.text.length >= 8 && oldPassword.text.contains(RegExp(
      //     r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$'))) {
      // if (oldPassword.text.length >= 8) {
      //   oldPasswordReqPass = true;
      //   isComplete = true;
      // } else {
      //   oldPasswordReqPass = false;
      //   isComplete = false;
      //   update(['change-password']);
      //   return;
      // }
      oldPasswordReqPass = true;
      isComplete = true;
    } else {
      oldPasswordReqPass = false;
      isComplete = false;
      update(['change-password']);
      return;
    }

    if (newPassword.text.trim() != '') {
      if (newPassword.text.length >= 8 && newPassword.text.contains(RegExp(
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$'))) {
        newPasswordReqPass = true;
        isComplete = true;
        update(['change-password']);
      } else {
        newPasswordReqPass = false;
        isComplete = false;
        update(['change-password']);
        return;
      }
    } else {
      newPasswordReqPass = false;
      isComplete = false;
      update(['change-password']);
      return;
    }

    if (confirmPassword.text.trim() != '') {
      if (newPassword.text == confirmPassword.text &&
          confirmPassword.text.length >= 8) {
        confirmPasswordReqPass = true;
        isComplete = true;
        update(['change-password']);
      } else {
        confirmPasswordReqPass = false;
        isComplete = false;
        update(['change-password']);
        return;
      }
    } else {
      confirmPasswordReqPass = false;
      isComplete = false;
      update(['change-password']);
      return;
    }

  }

  void changePassword(context) async {
    try {
      CustomShowDialog().openLoading(context);

      var data = {
        "old_password": oldPassword.text,
        "new_password": newPassword.text,
        "confirm_password": confirmPassword.text,
      };

      var response = await api.dynamicPost(
        endpoint: '/change-password',
        data: data,
        page: 'change-password',
        contentType: "application/json",
        section: 'user',
      );

      if (response.statusCode == 200) {
        oldPassword.text = '';
        newPassword.text = '';
        confirmPassword.text = '';
        CustomShowDialog().closeLoading();
        Get.back();
        Get.snackbar(
          'Success',
          'Password berhasil diubah',
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
}
