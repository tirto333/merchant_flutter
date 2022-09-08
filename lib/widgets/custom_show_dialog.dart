import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/screens/intro/Splash.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';

class CustomShowDialog {
  RestApi api = Get.find<RestApi>();

  openLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text("Loading"),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  closeLoading() {
    Get.back();
  }

  generalDialog(ErrorResModel e) {
    Get.snackbar(
      'Error',
      e.message.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  tokenError(ErrorResModel e) {
    api.clearToken();
    Get.offAll(SplashScreen());
    Get.snackbar(
      'Error Token',
      e.message.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  calendarDate(
    BuildContext context,
    Function() onPress,
    Function(DateTime) onChange,
    DateTime? initialDate,
  ) {
    Widget alert = AlertDialog(
      content: Container(
        height: 310,
        width: MediaQuery.of(context).size.width / 1.3,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                minimumYear: 1900,
                maximumYear: 2100,
                initialDateTime: initialDate ?? DateTime.now(),
                onDateTimeChanged: onChange,
                mode: CupertinoDatePickerMode.date,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CustomButton(
              text: "Done",
              sizeHeight: 30,
              borderRadiusSize: 5,
              colorButton: primaryColor,
              borderSideColor: Colors.grey.shade200,
              textColor: Colors.white,
              elevation: 0,
              onPressed: onPress,
            )
          ],
        ),
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void underDevelopment(context, Null Function() param1) {}
}
