import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Product/product.dart';
import 'package:winn_merchant_flutter/controllers/home/notifications.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/banner.dart';
import 'package:winn_merchant_flutter/models/category.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/our_products.dart';
import 'package:winn_merchant_flutter/models/product.dart';
import 'package:winn_merchant_flutter/models/Promotion/promotion.dart';
import 'package:winn_merchant_flutter/pages/Home/best_seller_product.dart';
import 'package:winn_merchant_flutter/pages/Home/categories_page.dart';
import 'package:winn_merchant_flutter/pages/Home/notification.dart';
import 'package:winn_merchant_flutter/pages/Home/search.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

import '../main_tab_controller.dart';
import 'best-seller.dart';

class HomeController extends GetxController {
  BannerData? banner;
  PromotionData? promotions;
  List<Row1>? categories;
  List<Row1>? subCategories;
  int startSubCategory = 0;
  int totalSubCategory = 0;

  int initialIndex = 0;
  int? promotionIndex = 0;
  int? headerIndex = 0;
  bool complete = false;
  bool isLoadingCategory = false;

  MainPageController tab = Get.put(MainPageController());
  ProductController product = Get.put(ProductController());
  BestSellerController bestSeller = Get.put(BestSellerController());
  NotificationController notification = Get.put(NotificationController());
  RestApi api = Get.find<RestApi>();
  bool isLoading = false;
  bool bestLoading = false;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // Best Seller Product

  var bestSellerProd = <Product>[].obs;
  int startBestSeller = 0;
  int totalBestSeller = 0;
  int totalBestSellerProducts = 0;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        await product.getProduct();
        //loadBestData();
        update(['content']);

        break;
      case ConnectivityResult.mobile:
        await product.getProduct();
        //loadBestData();
        update(['content']);

        break;
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        print("tidak ada koneksi");
        update();
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        print("tidak ada koneksi");
        update();
        break;
    }
  }

  void onInit() {
    initial();
    super.onInit();
    isLoadingCategory = true;

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    check().then((intenet) {
      if (intenet != null && intenet) {
        print("ada internet");
        // Internet Present Case
      }
      print("no internet");
      // No-Internet Case
    });

    ever(product.products, (value) {
      update(['product']);
    });
    ever(product.bestSeller, (value) {
      update(['best-seller']);
    });
    ever(tab.bottomNavBarIndex, (value) async {
      if (tab.bottomNavBarIndex.value == 0) await initial();
    });
  }

  void search() async {
    await Get.to(SearchProductPage());
    initial();
  }

  isFav(int index, bool val) {
    bestSellerProd[index].isFavorite = val;
  }

  Future initial() async {
    print("DIPANGGIL");
    try {
      complete = false;

      await product.getProduct();

      var resBanner = await api.dynamicGet(
        section: 'banner',
        endpoint: '/banner',
        page: 'banner',
        contentType: 'application/json',
      );

      /*var resPromotion = await api.dynamicGet(
        section: 'promotion',
        endpoint: '/promotion-detail',
        page: 'promotion',
        contentType: 'application/json',
      );*/

      // var response = await api.dynamicGet(
      //   section: 'product',
      //   endpoint: '/category',
      //   page: 'product-category',
      //   contentType: "application/json",
      // );

      var resCategories = await api.dynamicGet(
        section: 'product',
        endpoint: '/our-product?start=0&limit=10',
        page: 'product-category',
        contentType: "application/json",
      );

      categories = OurProductResModel.fromJson(resCategories.data).data?.rows;

      banner = BannerResModel.fromJson(resBanner.data).data;
//      promotions = PromotionResModel.fromJson(resPromotion.data).data;

      update(['content']);
    } on ErrorResModel catch (e) {
      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          update(['content']);
          Get.snackbar(
            'Error Homepage',
            e.message.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }

  void changeComplete() {
    complete = true;
    update();
  }

  void toProductCategory({int? id, String? tittle}) async {
    try {
      complete = false;
      bestSellerProd = <Product>[].obs;
      startBestSeller = 0;
      totalBestSeller = 5;
      totalBestSellerProducts = 0;

      var bestProd = await api.dynamicGet(
        section: 'product',
        endpoint: '/product-by-category/$id',
        contentType: 'application/json',
        page: 'best-seller-token',
      );

      print("DATA CATEGORY PRODUCT ${bestProd.data}");

      ProductData? bestData = ProductResModel.fromJson(bestProd.data).data;
      totalBestSellerProducts = bestData?.count ?? 0;
      bestData?.rows?.forEach((element) {
        if (element.category == tittle) {
          bestSellerProd.add(element);
        }
      });

      update(['best-seller-product']);
      Get.to(BestSellerProductCategoryScreen(
        tittle: tittle,
      ));
      //Get.to(ProductDescriptionPage());

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

  void toProductSubCategory({int? id, String? tittle}) async {
    try {
      complete = false;
      startSubCategory = 0;
      totalSubCategory = 5;

      var subCategoryProd = await api.dynamicGet(
        section: 'product',
        endpoint: '/our-product/$id',
        contentType: 'application/json',
        page: 'best-seller-token',
      );

      print("DATA CATEGORY PRODUCT ${subCategoryProd.data}");

      subCategories =
          OurProductResModel.fromJson(subCategoryProd.data).data?.rows;

      update(['sub-categories']);
      Get.to(CategoriesPage(
        tittle: tittle,
      ));
      //Get.to(ProductDescriptionPage());

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

  void onNotificationTap() {
    notification.init();
    Get.to(() => Notifications());
  }

  Future<void> onRefresh() async {
    try {
      await initial();
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

  void loadData() async {
    isLoading = true;
    isLoadingCategory = true;

    update(['product']);
    await loadMoreProduct(section: 'product');
  }

  void loadBestData() async {
    bestLoading = true;
    isLoadingCategory = true;
    update(['best-seller']);
    await loadMoreProduct(section: 'best-seller');
  }

  Future loadMoreProduct({String? section = 'product'}) async {
    switch (section) {
      case 'best-seller':
        if (product.totalBest >= product.totalBestProducts) {
          bestLoading = false;
          isLoadingCategory = false;
          update(['best-seller']);
        } else {
          await product.loadMoreProduct(section: 'best-seller');
          bestLoading = false;
          isLoadingCategory = false;

          update(['best-seller']);
        }
        break;
      default:
        if (product.total >= product.totalProducts) {
          isLoading = false;
          update(['product']);
        } else {
          await product.loadMoreProduct(section: 'product');
          isLoading = false;
          update(['product']);
        }
    }
  }

  void bannerChange({int? index, String? section}) {
    switch (section) {
      case 'header':
        headerIndex = index;
        update(['header-content']);
        break;
      case 'promotion':
        promotionIndex = index;
        update(['promotion-content']);
        break;
      default:
    }
  }

  Future quitApp(context) {
    AlertDialog logout = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      title: Center(
        child: WinnGeneralText(
          fontSize: 18,
          title: 'Close App',
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
          title: 'Are sure want to quit the app ?',
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
              borderRadiusSize: 15,
              text: 'No',
              sizeHeight: 5,
              sizeWidth: context.size.width / 4,
              textColor: Colors.black,
              colorButton: Colors.white,
              borderSideColor: Colors.white,
              onPressed: () {
                Get.back();
              },
            ),
            CustomButton(
              borderRadiusSize: 15,
              text: 'Yes',
              sizeHeight: 5,
              sizeWidth: context.size.width / 4,
              textColor: Colors.white,
              colorButton: primaryColor,
              borderSideColor: primaryColor,
              onPressed: () {
                exit(0);
              },
            ),
          ],
        ),
      ],
    );
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return logout;
      },
    );
  }
}
