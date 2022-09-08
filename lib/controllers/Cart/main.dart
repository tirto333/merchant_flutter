import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Product/product.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/Cart/cart.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/product.dart';
import 'package:winn_merchant_flutter/pages/detailinformation/product.dart';
import 'package:winn_merchant_flutter/screens/checkout/checkout_sucess.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

import '../main_tab_controller.dart';
import 'confirm.dart';

class CartController extends GetxController {
  bool selectedAll = false;
  List<bool> selectedProduct = <bool>[];
  List<Cart> cartProduct = <Cart>[];
  double total = 0;
  int totalCheckout = 0;
  late CartController cart;
  List cartChecked = [];
  TextEditingController qtyController = TextEditingController();
  // List cartCheckedAll = [];

  List<bool> checkCheckoutItem = <bool>[];
  bool selectedItemCheckout = false;
  Product? selectedItemProduct;

  RestApi api = Get.put(RestApi());
  ConfirmOrderController order = Get.put(ConfirmOrderController());
  MainPageController tab = Get.find<MainPageController>();

  void onInit() async {
    print("onInit");
    await getCartProduct();
    super.onInit();
    ever(tab.bottomNavBarIndex, (value) async {
      if (tab.bottomNavBarIndex.value == 3) await getCartProduct();
    });
  }

  Future? toDescriptionProduct({
    int? id,
  }) async {
    try {
      var product = await api.dynamicGet(
        endpoint: '/product/${id.toString()}',
        page: 'product-detail',
        contentType: 'application/json',
        section: 'product',
      );

      selectedItemProduct =
          ProductResModel.fromJson(product.data).data?.rows?[0];
      Get.find<ProductController>().selectedProduct = selectedItemProduct;
      return Get.to(ProductDescriptionPage());
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

  Future getCartProduct() async {
    print("getCartProduct");
    try {
      selectedAll = false;
      var totalCount = 0;
      total = 0;
      totalCheckout = 0;
      cartProduct = <Cart>[];
      selectedProduct = <bool>[];
      checkCheckoutItem = <bool>[];

      var response = await api.dynamicGet(
        section: 'cart',
        endpoint: '/cart',
        page: 'cart',
        contentType: 'application/json',
      );

      CartData? cartData = CartResModel.fromJson(response.data).data;

      print("HASIL CART $cartData");

      if (cartData?.rows!.length != 0) {
        cartData?.rows?.forEach((element) {
          selectedProduct.add(element.isCheckout);
          checkCheckoutItem.add(element.isCheckout);
          print("SELECTED PRODUCT 1 $selectedProduct");
          print("SELECTED PRODUCT 2 $checkCheckoutItem");
          debugPrint("=================================");
          debugPrint("QUANTITY ${element.quantity}");
          debugPrint("=================================");
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

      if (checkCheckoutItem.length > 0) {
        if (checkCheckoutItem.contains(true)) {
          selectedItemCheckout = true;
        } else {
          selectedItemCheckout = false;
        }
      }

      if (selectedProduct.length > 0) {
        bool allChecked = selectedProduct.contains(false);
        selectedAll = allChecked ? false : true;
      }

      update(['content-cart']);

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

  Future delete(context) {
    AlertDialog logout = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      title: Center(
        child: WinnGeneralText(
          fontSize: 18,
          title: 'Delete Product',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          colorTitle: Colors.black,
          border: TextDecoration.none,
        ),
      ),
      content: Container(
        // height: 25,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: WinnGeneralText(
          fontSize: 14,
          title: 'Are sure want to delete these products ?',
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
              elevation: 1,
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
                Get.back();
                deleteProduct(context);
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

  void deleteProduct(context) async {
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
        await getCartProduct();
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
  }

  void checkout(context) async {
    try {
      CustomShowDialog().openLoading(context);
      //Check Address from confirm order

      List<int> products = [];

      cartProduct.forEach((element) {
        if (element.isCheckout) {
          products.add(element.id ?? 1);
        }
      });

      print("ID CART $products");
      print("ID CART 2 ${cartProduct.length}");

      var data = {"cart_id": products};

      print(data);
      print(data.values.first.length);
      print(data.length);

      if (data.values.first.length != 0) {
        CustomShowDialog().closeLoading();
        var response = await api.dynamicPost(
          endpoint: '/order',
          section: 'cart',
          data: data,
          page: 'order-confirm',
          contentType: 'application/json',
        );
        print("HASIL CHECKOUT $response");

        if (response.statusCode == 200) {
          print("MASUK SINI");
          await getCartProduct();
          Get.to(CheckoutSuccessScreen());
        } else {
          Get.snackbar('Redirect', 'You don\'t have main address');
          order.redirectToAddress();
        }
      } else {
        CustomShowDialog().closeLoading();
        Get.snackbar(
          'Error',
          "there are no items in the cart",
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      /*CustomShowDialog().closeLoading();
      var response = await api.dynamicPost(
        endpoint: '/order',
        section: 'cart',
        data: data,
        page: 'order-confirm',
        contentType: 'application/json',
      );
      print("HASIL CHECKOUT $response");


      if (response.statusCode == 200) {
        print("MASUK SINI");
        // cart.getCartProduct();
        // CustomShowDialog().closeLoading();
        Get.to(CheckoutSuccessScreen());
      } else {
        Get.snackbar('Redirect', 'You don\'t have main address');
        order.redirectToAddress();
      }*/

      // var checkoutData = await api.dynamicPost(
      //   section: 'cart',
      //   endpoint: '/input-checkout',
      //   data: {
      //     "cart_id": products
      //   },
      //   page: 'checkout',
      //   contentType: 'application/json',
      // );
      //
      // print("HASIL CHECKOUT DATA :> $checkoutData");

      // bool response = await order.toConfirmOrder();
      // print("RESPONSE :> $response");
      // CustomShowDialog().closeLoading();

      // if (checkoutData.statusCode == 200) {
      //   CustomShowDialog().closeLoading();
      //
      //   var data = {
      //     "cart_id": products
      //   };
      //
      //   print("ID $products");
      //
      //   var response = await api.dynamicPost(
      //     endpoint: '/order',
      //     section: 'cart',
      //     data: data,
      //     page: 'order-confirm',
      //     contentType: 'application/json',
      //   );
      //   print("HASIL CHECKOUT $response");
      //
      //   if (response.statusCode == 200) {
      //     print("MASUK SINI");
      //     // cart.getCartProduct();
      //     // CustomShowDialog().closeLoading();
      //     Get.to(CheckoutSuccessScreen());
      //   }
      //   // Get.to(ConfirmOrderPage());
      //
      // } else {
      //   Get.snackbar('Redirect', 'You don\'t have main address');
      //   order.redirectToAddress();
      // }
    } on ErrorResModel catch (e) {
      var message = "Cart does not exist";
      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          if (message == e.message) {
            Get.snackbar(
              'Error',
              "no item selected",
              snackPosition: SnackPosition.BOTTOM,
            );
            break;
          } else {
            Get.snackbar(
              'Error',
              e.message.toString(),
              snackPosition: SnackPosition.BOTTOM,
            );
            break;
          }
          break;
      }
    }
  }

  void checkAll() async {
    print("checkAll");
    try {
      List<int> products = [];

      cartProduct.forEach((element) {
        products.add(element.id ?? 1);
        // cartCheckedAll.add(element.id ?? null);
      });

      // print("isi checked all $cartCheckedAll");

      // var response = await api.dynamicUpdate(
      //   endpoint: '/checkout',
      //   section: 'cart',
      //   data: {
      //     "cart_id": products,
      //     "is_checkout": selectedAll ? false : true,
      //   },
      var response = await api.dynamicPost(
        endpoint: '/input-checkout',
        section: 'cart',
        data: {
          "cart_id": products,
        },
        page: 'cart-checkout',
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        await getCartProduct();
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

  void checkProduct({int index = 0}) async {
    print("check Product");
    Cart selectedCart = cartProduct[index];

    cartChecked = [selectedCart.id ?? null];
    try {
      var response = await api.dynamicPost(
        endpoint: '/input-checkout',
        section: 'cart',
        data: {
          "cart_id": [selectedCart.id],
        },
        page: 'cart-checkout',
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        await getCartProduct();
      }
    } on ErrorResModel catch (e) {
      print("ERROR MASUK SINI NI");
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

  void plusMinus({String? section, int? cartId}) async {
    try {
      var responseCart = await api.dynamicPost(
        endpoint: '/cart-selection?section=$section',
        section: 'cart',
        data: {
          "cart_id": cartId,
        },
        page: 'plus-minus',
        contentType: 'application/json',
      );

      if (responseCart.statusCode == 200) {
        await getCartProduct();
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

  Future addToCart({int? productId}) async {
    try {
      var response = await api.dynamicPost(
        endpoint: '/input-cart',
        section: 'cart',
        page: 'add-to-cart',
        contentType: 'application/json',
        data: {
          "product_id": productId,
        },
      );

      if (response.statusCode == 200) {
        await getCartProduct();
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

  void updateQty({int? cartId, int? quantity}) async {
    try {
      var responseCart = await api.dynamicPost(
        endpoint: '/update-cart',
        section: 'cart',
        data: {
          "cart_id": cartId,
          "quantity": quantity,
        },
        page: 'plus-minus',
        contentType: 'application/json',
      );

      if (responseCart.statusCode == 200) {
        await getCartProduct();
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
}
