import 'package:winn_merchant_flutter/controllers/intro/forgot_password_controller.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().generalAppBar(
        title: 'Forgot Password',
        implyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<ForgotPasswordController>(
        builder: (_) {
          return Container(
            color: Colors.white,
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: buildLoginForm(context),
                ),
                SizedBox(
                  height: 100,
                  child: Container(
                    color: primaryColor,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildLoginForm(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            WinnFormField(
              controller: controller.email,
              title: 'REGISTERED EMAIL',
              textInputType: TextInputType.emailAddress,
              hint: "Email",
              onChanged: (_) => controller.validate(),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Request New Password',
              colorButton:
                  controller.isComplete ? secondaryColor : Colors.grey[350],
              borderSideColor:
                  controller.isComplete ? secondaryColor : Colors.grey[350],
              onPressed: controller.isComplete
                  ? () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      controller.submit(context);
                    }
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
