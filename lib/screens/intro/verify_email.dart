import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/intro/verify_email_controller.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';

class VerifyEmailScreen extends StatelessWidget {
  final VerifyEmailController controller = Get.find<VerifyEmailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().generalAppBar(
        title: 'Verify Email',
      ),
      body: Container(
        color: Colors.white,
        child: ListView(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: GetBuilder<VerifyEmailController>(
              id: 'resend',
              builder: (_) {
                if (_.email == null) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 0.95,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return buildVerificationCodeBox(context);
                }
              },
            ),
          ),
          SizedBox(height: 100, child: Container(color: primaryColor))
        ]),
      ),
    );
  }

  Widget buildVerificationCodeBox(context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Text(
          "Enter the code we just sent you on your email address.",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text(
          controller.email ?? '',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(controller.nums.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 13,
                width: MediaQuery.of(context).size.width / 8,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  onChanged: (val) {
                    if (index != controller.nums.length - 1 && val != '') {
                      FocusScope.of(context).nextFocus();
                    } else if (val == '' && index != 0) {
                      FocusScope.of(context).previousFocus();
                    }
                    controller.onChange();
                  },
                  maxLength: 1,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    counterText: '',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  controller: controller.nums[index],
                  textInputAction: index == controller.nums.length - 1
                      ? TextInputAction.done
                      : TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 30),
        GetBuilder<VerifyEmailController>(
          id: 'count-down',
          builder: (_) {
            if (controller.start == 0) {
              return GestureDetector(
                onTap: () {
                  _.resendCode();
                },
                child: Text(
                  "Resend Code",
                  style: TextStyle(
                    color: secondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Resend Code",
                    style: TextStyle(
                      color: orangeColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Available in: ${_.start}s",
                    style: TextStyle(
                      color: orangeColor,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              );
            }
          },
        ),
        SizedBox(height: 30),
        CustomButton(
          textColor: primaryColor,
          borderSideColor:
              controller.isComplete ? Colors.orangeAccent : orangeColor,
          colorButton:
              controller.isComplete ? Colors.orangeAccent : orangeColor,
          text: "Continue",
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
    );
  }
}
