import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/main_tab_controller.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/Order/order_detail.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/product.dart';
import 'package:winn_merchant_flutter/models/request_model.dart';
import 'package:winn_merchant_flutter/models/return_model.dart';
import 'package:winn_merchant_flutter/pages/Return/new_request.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

class ReturnControllers extends GetxController {
  MainPageController tab = Get.find<MainPageController>();
  TextEditingController returnReason = TextEditingController();
  TextEditingController orderController = TextEditingController();
  List<TextEditingController> qtyController = [];
  List<bool> checked = List.generate(2, (index) => false);
  RestApi api = Get.put(RestApi());
  //OrderDetail? selectedOrder;
  List<Products> products = [];
  List<ReturnProd> returnProducts = [];
  ReturnModel returnModel = ReturnModel();

  @override
  void onInit() {
    super.onInit();
    getReturnProducts();
    ever(tab.bottomNavBarIndex, (value) async {
      if (tab.bottomNavBarIndex.value == 3) await getReturnProducts();
    });
  }

  Future<void> getReturnProducts() async {
    try {
      var response = await api.dynamicGet(
        endpoint: '/return',
        section: 'return',
        page: 'get-order',
        contentType: 'application/json',
      );
      if (response.statusCode == 200) {
        print("HASIL ORDER BY ID DETAIL $response");
        //selectedOrder = OrderDetailResModel.fromJson(response.data).data;
        returnModel = ReturnModel.fromJson(response.data);
        returnProducts = returnModel.data!.returnProd ?? [];
        update(['returnProducts']);
      }
    } on ErrorResModel catch (e) {
      print("HASIL ORDER BY ID DETAIL GAGAL ${e.statusCode}");
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

  void onRequestReturnTap(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (context) => NewRequest(),
    );
  }

  Future<void> onSubmitTap() async {
    try {
      List<Map<String,dynamic>> list = [];
      for(int i=0; i< checked.length; i++){
        if(checked[i]){
          list.add({
            'product_id': products[i].productId,
            'quantity': qtyController[i].text,
          });
        }
      }
      if(list.isEmpty){
        Get.snackbar(
          'Error',
          "Select a product for return",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      Map<String, dynamic> body = {
        'order_id': products.first.orderId,
        'return' : list,
        'description': returnReason.text,
      };
      var response = await api.dynamicPost(
        endpoint: '/input-return',
        page: 'product-detail',
        contentType: 'application/json',
        section: 'return',
        data: body,
      );
      if(response.statusCode == 200){
        getReturnProducts();
        Get.back();
        Get.snackbar(
          'Success',
          'Request successfully sent for return',
          snackPosition: SnackPosition.BOTTOM,
        );
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

  void onTapCheckBox(int index) {
    checked[index] = !checked[index];
    update(['newRequest']);
  }

  Future<void> onCheckTap() async {
    try {
      /*var response = await api.dynamicGet(
        endpoint: '/getOrder/${orderController.text}',
        section: 'cart',
        page: 'get-order',
        contentType: 'application/json',
      );*/

      Map<String,dynamic> body = {
        'order_generate': orderController.text,
      };
      var response = await api.dynamicPost(
        endpoint: '/return',
        section: 'return',
        page: 'get-order',
        contentType: 'application/json',
        data: body,
      );
      if (response.statusCode == 200) {
        print("HASIL ORDER BY ID DETAIL $response");
        //selectedOrder = OrderDetailResModel.fromJson(response.data).data;
        RequestModel requestModel = RequestModel.fromJson(response.data);
        products = requestModel.data ?? [];
        checked = List.generate(
            products.length, (index) => false);
        qtyController = [];
        qtyController = products
            .map<TextEditingController>(
                (e) => TextEditingController(text: e.quantity!.toString()))
            .toList();
        update(['newRequest']);
      }
    } on ErrorResModel catch (e) {
      print("HASIL ORDER BY ID DETAIL GAGAL ${e.statusCode}");
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

  void checkQty(int index) {
    if (qtyController[index].text == '') {
      return;
    } else if (int.parse(products[index].quantity!) <
        int.parse(qtyController[index].text)) {
      qtyController[index].text =
          products[index].quantity!.toString();
    } else if (int.parse(qtyController[index].text) < 1) {
      qtyController[index].text = 1.toString();
    }
  }
}
