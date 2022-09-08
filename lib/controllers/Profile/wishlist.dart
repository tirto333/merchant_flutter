import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Product/product.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/Whislist/wishlist.dart';
import 'package:winn_merchant_flutter/models/product.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

import '../main_tab_controller.dart';

class WishlistController extends GetxController {
  var wishProducts = <Wishlist>[].obs;
  int startProduct = 0;
  int total = 5;
  int totalProducts = 0;
  bool isLoading = false;
  bool bestLoading = false;
  bool complete = false;

  Product? selectedProduct;
  var bestSeller = <Product>[].obs;

  RestApi api = Get.find<RestApi>();
  ProductController? product = Get.find<ProductController>();
  MainPageController tab = Get.find<MainPageController>();

  void onInit() async {
    await initial();
    super.onInit();
    ever(tab.bottomNavBarIndex, (value) {
      if (tab.bottomNavBarIndex.value == 4) {
        initial();
      }
    });
  }

  Future<void> unSaveProduct(String id,String wishId,BuildContext context) async {
    CustomShowDialog().openLoading(context);
    var response = await api.dynamicDelete(
      endpoint: '/wishlist-delete/${wishId.toString()}',
      page: 'wishlist-delete',
      section: 'user',
      data: {
        "product_id": id,
      },
      contentType: 'application/json',
    );

    if (response.statusCode == 200) {
      await initial();
    }
    CustomShowDialog().closeLoading();
  }

  void changeComplete() {
    complete = true;
    update();
  }

  Future initial() async {
    try {
      wishProducts = <Wishlist>[].obs;
      startProduct = 0;
      total = 0;
      totalProducts = 0;
      complete = false;

      var resProd = await api.dynamicGet(
        endpoint: '/wishlist?start=0&limit=5',
        page: 'wishlist-user',
        contentType: 'application/json',
        section: 'user',
      );

      WishlistData? productData = WishlistResModel.fromJson(resProd.data).data;
      totalProducts = productData?.count ?? 0;
      productData?.rows?.forEach((element) {
        wishProducts.add(element);
      });

      update(['wishlist-content']);
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

  Future loadMoreProduct({
    String? section = 'product',
    var data,
  }) async {
    startProduct += 5;
    total += 5;

    var resProd = await api.dynamicGet(
      endpoint: '/wishlist?start=$startProduct&limit=5',
      page: 'wishlist-user',
      contentType: 'application/json',
      section: 'user',
    );

    WishlistData? productData = WishlistResModel.fromJson(resProd.data).data;
    productData?.rows?.forEach((element) {
      wishProducts.add(element);
    });
  }

  void toDetail({int? id}) async {
    await product?.toDescriptionProduct(id: id);

    var resProd = await api.dynamicGet(
      endpoint: '/wishlist?start=0&limit=5',
      page: 'wishlist-user',
      contentType: 'application/json',
      section: 'user',
    );

    wishProducts = <Wishlist>[].obs;

    WishlistData? productData = WishlistResModel.fromJson(resProd.data).data;

    productData?.rows?.forEach((element) {
      wishProducts.add(element);
    });

    update(['wishlist-content']);
  }
}
