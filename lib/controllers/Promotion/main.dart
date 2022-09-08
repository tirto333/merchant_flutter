import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/Promotion/promotion_detail.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/Promotion/promotion.dart';
import 'package:winn_merchant_flutter/pages/detailinformation/promotion.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

import '../main_tab_controller.dart';

class PromotionController extends GetxController {
  PromotionData? promotions;
  // List<DataDetail>? dataPromotions;
  // var bestSellerProd = <DataDetail>[].obs;

  // Initiate Controller
  RestApi api = Get.find<RestApi>();
  MainPageController tab = Get.find<MainPageController>();

  void onInit() async {
    print("MASUK CONTROLLER PROMOTION");
    await initial();
    super.onInit();
    ever(tab.bottomNavBarIndex, (value) async {
      if (tab.bottomNavBarIndex.value == 2) await initial();
    });
  }

  Future initial() async {
    try {
      // var resPromotion = await api.dynamicGet(
      //   section: 'promotion',
      //   endpoint: '/promotion',
      //   page: 'promotion',
      //   contentType: 'application/json',
      // );

      var resPromotion = await api.dynamicGet(
        section: 'promotion',
        endpoint: '/promotion-detail',
        page: 'promotion',
        contentType: 'application/json',
      );

      print("HASIL PROMOSI NIHH $resPromotion");

      promotions = PromotionResModel.fromJson(resPromotion.data).data;
      update();
    } on ErrorResModel catch (e) {
      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          Get.snackbar('Error', e.message.toString(),
              snackPosition: SnackPosition.BOTTOM);
          break;
      }
    }
  }

  void toPromotionDetail({int? id, String? url}) async {
    try {
      // var response = await api.dynamicGet(
      //   section: 'promotion',
      //   endpoint: '/promotion/$id',
      //   contentType: 'application/json',
      //   page: 'promotion',
      // );

      var response = await api.dynamicGet(
        section: 'promotion',
        endpoint: '/promotion-detail',
        page: 'promotion',
        contentType: 'application/json',
      );

      print("HASIL PROMOSI DETAIL NIHH $response");
      promotions = PromotionResModel.fromJson(response.data).data;
      update();

      // print("HASIL PROMOSI DETAIL NIHH $response");
      // dataPromotions = PromotionDetailResModel.fromJson(response.data).data;
      // print("DATA PROMOSI DETAIL 2 $dataPromotions");
      // dataPromotions!.forEach((element) {
      //   bestSellerProd.add(element);
      // });
      // update(['detail-promotion']);
      // print("DATA PROMOSI DETAIL 2 $bestSellerProd");

      // ProductData? bestData = ProductResModel.fromJson(bestProd.data).data;
      // totalBestSellerProducts = bestData?.count ?? 0;
      // bestData?.rows?.forEach((element) {
      //   bestSellerProd.add(element);
      // });

      // update(['best-seller-product']);
      // Get.to(PromotionDetailScreen(
      //   id: bestSellerProd.first.id.toString(),
      //   image: bestSellerProd.first.image,
      //   promo: bestSellerProd.first.promo,
      //   condition: bestSellerProd.first.condition,
      //   startTimePromo: bestSellerProd.first.condition,
      //   endTimePromo: bestSellerProd.first.endTimePromo,
      // ));

    } on ErrorResModel catch (e) {
      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          Get.snackbar(
            'Error',
            e.message.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }
}
