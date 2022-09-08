import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/intro/splash_controller.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: AssetImage("assets/images/maskot.png"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.89,
          fit: BoxFit.fill,
        ),
        buildBottomSheet(context),
      ],
    );
  }

  Align buildBottomSheet(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.14,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: CustomButton(
                text: "Login",
                onPressed: () {
                  controller.toLoginScreen();
                },
                colorButton: secondaryColor,
                borderSideColor: secondaryColor,
                textColor: primaryColor,
                sizeHeight: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
