import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/intro/login_controller.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_form_field.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WinnGeneralText(
          title: 'Login',
          colorTitle: Colors.black87,
          fontSize: 18,
          border: TextDecoration.none,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<LoginController>(
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
              title: 'EMAIL',
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
              hint: "Email",
            ),
            SizedBox(height: 20),
            WinnFormField(
              controller: controller.password,
              title: 'Password'.toUpperCase(),
              textInputAction: TextInputAction.done,
              suffixIcon: true,
              obsecure: true,
              hint: "Password",
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.toForgotPassword();
                  },
                  child: Center(
                    child: WinnGeneralText(
                      title: 'Forgot Password',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "Login",
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }

                controller.login(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
