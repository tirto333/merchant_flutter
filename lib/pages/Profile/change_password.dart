import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Profile/change_password.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_form_field.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final ChangePasswordController controller =
      Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().generalAppBar(
        title: "Change Password",
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () async {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GetBuilder<ChangePasswordController>(builder: (_) {
          return SingleChildScrollView(
            child: Column(
              children: [
                GetBuilder<ChangePasswordController>(
                  id: 'change-password',
                  builder: (_) {
                    return buildPasswordForm(context);
                  },
                ),
                // buildPasswordForm(),
                SizedBox(height: 10),
                GetBuilder<ChangePasswordController>(
                  id: 'change-password',
                  builder: (_) {
                    return CustomButton(
                      text: "Change Password",
                      borderRadiusSize: 10,
                      colorButton: controller.isComplete
                          ? primaryColor
                          : Color(0xFFE3E3E3),
                      borderSideColor: controller.isComplete
                          ? primaryColor
                          : Color(0xFFE3E3E3),
                      textColor: Colors.white,
                      onPressed: controller.isComplete
                          ? () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              controller.changePassword(context);
                            }
                          : null,
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildPasswordForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WinnFormField(
          controller: controller.oldPassword,
          title: 'old password'.toUpperCase(),
          // suffixIcon: true,
          obsecure: true,
          fillColor: Color(0xFFF2F2F2),
          colorTitle: Color(0xFF292929),
          hint: "Old Password",
          // passReq: controller.oldPasswordReqPass,
          onChanged: (val) {
            controller.validate();
          },
          // helper: "Min 8 Characters",
        ),
        SizedBox(height: 20),
        WinnFormField(
          controller: controller.newPassword,
          title: 'new password'.toUpperCase(),
          // suffixIcon: true,
          obsecure: true,
          fillColor: Color(0xFFF2F2F2),
          colorTitle: Color(0xFF292929),
          hint: "New Password",
          passReq: controller.newPasswordReqPass,
          onChanged: (val) {
            controller.validate();
          },
          // helper: "A specific combination of letters, numbers, and characters must be included in the password.",
        ),
        SizedBox(height: 20),
        WinnFormField(
          controller: controller.confirmPassword,
          title: 'confirm new password'.toUpperCase(),
          // suffixIcon: true,
          obsecure: true,
          textInputAction: TextInputAction.done,
          fillColor: Color(0xFFF2F2F2),
          colorTitle: Color(0xFF292929),
          hint: "Confirm New Password",
          passReq: controller.confirmPasswordReqPass,
          onChanged: (val) {
            controller.validate();
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
