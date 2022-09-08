import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/pages/Address/saved_address.dart';
import 'package:winn_merchant_flutter/pages/Profile/change_password.dart';
import 'package:winn_merchant_flutter/pages/Profile/chat.dart';
import 'package:winn_merchant_flutter/pages/Profile/personal_info.dart';
import 'package:winn_merchant_flutter/pages/Profile/wishlist.dart';
import 'package:winn_merchant_flutter/screens/intro/splash.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

import '../main_tab_controller.dart';

class MyProfileController extends GetxController {
  final RestApi api = Get.find<RestApi>();
  MainPageController tab = Get.find<MainPageController>();

  List<dynamic> password(String section) {
    if (section == 'section') {
      return [
        'Change Password'
      ];
    } else {
      return [
        () {
          Get.to(
            ChangePasswordPage(),
          );
        }
      ];
    }
  }

  List<dynamic> userProfile(String section) {
    if (section == 'section') {
      return [
        'Merchant Information',
        'Saved Address',
        'My Wishlist',
      ];
    } else {
      return [
        () {
          Get.to(
            PersonalInfoPage(),
          );
        },
        () {
          Get.to(
            SavedAddressPage(),
          );
        },
        () {
          Get.to(
            WishlistPage(),
          );
        },
        () {
        },
      ];
    }
  }

  void confirmationPop(context) {
    AlertDialog logout = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      title: Center(
        child: WinnGeneralText(
          fontSize: 18,
          title: 'Logout',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          colorTitle: Colors.black,
          border: TextDecoration.none,
        ),
      ),
      content: Container(
        height: 25,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: WinnGeneralText(
          fontSize: 14,
          title: 'Are sure want to logout ?',
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.center,
          colorTitle: Colors.black,
          border: TextDecoration.none,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              text: 'No',
              sizeWidth: MediaQuery.of(context).size.width / 5,
              sizeHeight: 5,
              borderSideColor: Colors.white,
              colorButton: Colors.white,
              textColor: Colors.black,
              fontSize: 14,
              borderRadiusSize: 15,
              onPressed: () async {
                Get.back();
              },
            ),
            CustomButton(
              text: 'Yes',
              sizeWidth: MediaQuery.of(context).size.width / 5,
              sizeHeight: 5,
              borderSideColor: primaryColor,
              colorButton: primaryColor,
              textColor: Colors.white,
              fontSize: 14,
              borderRadiusSize: 15,
              onPressed: () async {
                try {
                  Get.back();
                  CustomShowDialog().openLoading(context);
                  await api.dynamicGet(
                    section: 'user',
                    endpoint: '/logout',
                    contentType: 'application/json',
                    page: 'logout',
                  );
                  CustomShowDialog().closeLoading();
                  api.clearToken();
                  Get.offAll(SplashScreen());
                } on ErrorResModel catch (e) {
                  CustomShowDialog().closeLoading();

                  switch (e.statusCode) {
                    case 401:
                      CustomShowDialog().tokenError(e);
                      break;
                    default:
                      CustomShowDialog().generalDialog(e);
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return logout;
      },
    );
  }

  void logout(context) {
    confirmationPop(context);
  }
}
