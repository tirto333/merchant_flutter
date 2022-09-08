import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/Cart/cart.dart';
import 'package:winn_merchant_flutter/models/Cart/checkout.dart';
import 'package:winn_merchant_flutter/models/Cart/shipping.dart';
import 'package:winn_merchant_flutter/models/Cart/shipping_price.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/screens/main_tab.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

import '../main_tab_controller.dart';
import 'main.dart';

class ConfirmOrderController extends GetxController {
  Checkout? checkout;
  double? shippingFee;
  int? selectedShippingIndex;
  double priceTotal = 0;
  List<bool> selectedProduct = <bool>[];
  bool selectedAll = false;
  double total = 0;
  int totalCheckout = 0;
  List<Cart> cartProduct = <Cart>[];
  List<ShippingResModel> shippings = [
    ShippingResModel(
      name: 'Winn Courier',
      code: 'winn-courier',
      weight: 0,
      price: 0,
      disabled: false,
    ),
    ShippingResModel(
      name: 'JNE',
      code: 'jne',
      weight: 0,
      price: 0,
      disabled: false,
    ),
  ];

  // Initiate Other Controller
  RestApi api = Get.find<RestApi>();
  MainPageController tab = Get.find<MainPageController>();
  late CartController cart;

  void onInit() {
    Get.lazyPut(() => cart = CartController());
    super.onInit();
  }

  void confirmRequestOrder(BuildContext context) async {
    var response = await api.dynamicGet(
      section: 'cart',
      endpoint: '/cart',
      page: 'cart',
      contentType: 'application/json',
    );

    CartData? cartData = CartResModel.fromJson(response.data).data;
    print("DATA CART UPDATE $cartData");
    //
    // cart.deleteProduct(context, true);

    try {
      CustomShowDialog().openLoading(context);

      List<int> choosen = [];

      for (int i = 0; i < selectedProduct.length; i++) {
        if (selectedProduct[i]) choosen.add(cartProduct[i].id ?? 1);
      }

      var response = await api.dynamicDelete(
        endpoint: '/delete-cart-selected',
        data: {
          "id": choosen,
        },
        page: 'delete-cart',
        section: 'cart',
        contentType: 'application/json',
      );

      CustomShowDialog().closeLoading();

      if (response.statusCode == 200) {
        // await getProductInCart();
        CustomShowDialog().closeLoading();
        Get.offUntil(GetPageRoute(page: () => MainPage()), (route) => true);
        update(['content-cart']);

        tab.updateContent(index: 1);
      }
    } on ErrorResModel catch (e) {
      CustomShowDialog().closeLoading();

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

    // if (response.statusCode == 200) {
    //   cart.getCartProduct();
    //   CustomShowDialog().closeLoading();
    //   Get.offUntil(
    //       GetPageRoute(page: () => MainPage()), (route) => true);
    //   tab.updateContent(index: 1);
    // }
  }

  Future getProductInCart() async {
    print("getCartProduct");
    try {
      selectedAll = false;
      var totalCount = 0;
      total = 0;
      totalCheckout = 0;
      cartProduct = <Cart>[];
      selectedProduct = <bool>[];

      var response = await api.dynamicGet(
        section: 'cart',
        endpoint: '/cart',
        page: 'cart',
        contentType: 'application/json',
      );

      CartData? cartData = CartResModel.fromJson(response.data).data;

      if (cartData?.rows!.length != 0) {
        cartData?.rows?.forEach((element) {
          selectedProduct.add(element.isCheckout);
          cartProduct.add(element);
          totalCount += element.quantity ?? 1;
          // totalCount += element.qty ?? 1;
          if (element.isCheckout) {
            total += element.totalPrice ?? 0;
            totalCheckout += element.quantity ?? 0;
            // totalCheckout += element.qty ?? 0;
          }
        });
      }

      if (selectedProduct.length > 0) {
        bool allChecked = selectedProduct.contains(false);
        selectedAll = allChecked ? false : true;
      }

      update(['content-cart']);

      Get.offUntil(GetPageRoute(page: () => MainPage()), (route) => true);
      tab.updateContent(index: 1);
      tab.changeCount(count: totalCount);
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

  Future getCheckout() async {
    try {
      List<int> products = [];

      cartProduct.forEach((element) {
        products.add(element.id ?? 1);
      });

      // print("ID CARD ${cartProduct.first.id}");

      var checkoutData = await api.dynamicPost(
        section: 'cart',
        endpoint: '/input-checkout',
        data: {"cart_id": products},
        page: 'checkout',
        contentType: 'application/json',
      );

      print("HASIL CHECKOUT DATA :> $checkoutData");

      // checkout = CheckoutResModel.fromJson(checkoutData.data).data!.rows;

      // if (checkout?.address != null) {
      //   for (int index = 0; index < shippings.length; index++) {
      //     var shippingResPrice = await api.dynamicPost(
      //       data: {
      //         "shipping_method": shippings[index].code,
      //       },
      //       endpoint: '/input-shipping',
      //       page: 'shipping-method',
      //       section: 'payment',
      //       contentType: 'application/json',
      //     );
      //
      //     var shippingPrice =
      //         ShippingPriceModel.fromJson(shippingResPrice.data);
      //
      //     switch (shippings[index].code) {
      //       case 'winn-courier':
      //         if (shippingPrice.data != null) {
      //           selectedShippingIndex = 0;
      //           shippingFee = shippingPrice.data?.price;
      //           shippings[index].disabled = false;
      //         } else {
      //           shippings[index].disabled = true;
      //         }
      //         break;
      //       case 'jne':
      //         if (shippingPrice.data != null) {
      //           if (shippings[0].disabled == true) {
      //             selectedShippingIndex = 1;
      //             shippingFee = shippingPrice.data?.price;
      //             shippings[index].disabled = false;
      //           }
      //         } else {
      //           shippings[index].disabled = true;
      //         }
      //         break;
      //       default:
      //         selectedShippingIndex = 1;
      //         shippingFee = shippingPrice.data?.price;
      //     }
      //
      //     shippings[index].price = shippingPrice.data?.price ?? 0;
      //     shippings[index].weight = checkout?.weight;
      //   }
      //
      //   calculatePriceTotal();
      //
      update(['confirm']);
      // }
    } on ErrorResModel catch (e) {
      print("MASUK SINI ${e.message}");
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

  void calculatePriceTotal() {
    priceTotal = 0;
    priceTotal += shippingFee ?? 0;
    priceTotal += checkout?.subtotal ?? 0;
    priceTotal += checkout?.convenienceFee ?? 0;
  }

  Future toConfirmOrder() async {
    await getCheckout();
    print("ALAMAT ${checkout!.address}");
    if (checkout!.address == null) {
      return false;
    } else {
      return true;
    }
  }

  void redirectToAddress() async {
    //Get.to(SavedAddressPage());
  }

  void changeShippingMethod({int value = 0}) {
    selectedShippingIndex = value;
    shippingFee = shippings[value].price;
    calculatePriceTotal();
    update(['confirm']);
  }

  void confirmOrder(context) async {
    try {
      CustomShowDialog().openLoading(context);

      List<int> selectedProduct = [];

      checkout!.productOverviews!.forEach((element) {
        selectedProduct.add(element.cartId ?? 0);
      });

      var data = {
        "cart_id": selectedProduct,
        "shipping_method": shippings[selectedShippingIndex ?? 0].code,
        "price_subtotal": checkout?.subtotal,
        "price_shipping": shippingFee,
        "price_convenience": checkout?.convenienceFee,
        "price_total": priceTotal,
      };

      var response = await api.dynamicPost(
        endpoint: '/order',
        section: 'cart',
        data: data,
        page: 'order-confirm',
        contentType: 'application/json',
      );
      print("HASIL CHECKOUT $response");

      if (response.statusCode == 200) {
        cart.getCartProduct();
        CustomShowDialog().closeLoading();
        // await launchInWebViewWithJavaScript(response.data['redirect_url']);
        CustomShowDialog().underDevelopment(context, () {
          Get.offUntil(GetPageRoute(page: () => MainPage()), (route) => true);
          tab.updateContent(index: 1);
        });
      }
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

  Future<void> launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
