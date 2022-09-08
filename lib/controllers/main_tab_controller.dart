import 'package:get/get.dart';
import 'package:winn_merchant_flutter/pages/Cart/cart.dart';
import 'package:winn_merchant_flutter/pages/Home/home.dart';
import 'package:winn_merchant_flutter/pages/Order/main.dart';
import 'package:winn_merchant_flutter/pages/Profile/my_profile.dart';
import 'package:winn_merchant_flutter/pages/Promotion/promotion.dart';
import 'package:winn_merchant_flutter/pages/Return/return.dart';
import 'package:winn_merchant_flutter/screens/main_tab.dart';

class MainPageController extends GetxController {
  var bottomNavBarIndex = 0.obs;
  var cartCount = 0.obs;

  void onInit() {
    super.onInit();
    ever(cartCount, (value) {
      update(['content-page']);
    });
  }

  List tabs() {
    return [
      HomePage(),
      MyOrderPage(),
      PromotionPage(),
      ReturnPage(),
      MyProfilePage()
    ];
  }

  void updateContent({int index = 0}) {
    bottomNavBarIndex.value = index;
    update(['content-page']);
  }

  void changePage({int index = 0}) {
    bottomNavBarIndex.value = index;
    update(['content-page']);
  }

  void backToHome() {
    bottomNavBarIndex.value = 0;
    update(['content-page']);
  }

  void tabCart() {
    bottomNavBarIndex.value = 3;
    update(['content-page']);
  }

  void resetIndex() {
    bottomNavBarIndex.value = 0;
    update(['content-page']);
    Get.to(MainPage());
  }

  void changeCount({int? count}) {
    cartCount.value = count ?? 0;
  }
}
