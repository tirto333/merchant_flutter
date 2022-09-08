import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/Order/order.dart';
import 'package:winn_merchant_flutter/models/Order/order_detail.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/pages/Order/order_detail.dart';
import 'package:winn_merchant_flutter/pages/Order/status_tracker.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

import '../main_tab_controller.dart';
class OrderController extends GetxController {
  String? section = 'all';
  int index = 0;
  List<Order>? orders = <Order>[];
  OrderDetail? selectedOrder;

  RestApi api = Get.find<RestApi>();
  MainPageController tab = Get.find<MainPageController>();

  void onInit() async {
    await getOrder();
    super.onInit();
    ever(tab.bottomNavBarIndex, (value) {
      if (tab.bottomNavBarIndex.value == 1) {
        getOrder();
      }
    });
  }

  Future getOrder() async {
    try {
      switch (index) {
        case 1:
          // section = 'sending';
          section = 'waiting-payment';
          break;
        case 2:
          section = 'received';
          break;
        // case 3:
        //   section = 'waiting-payment';
        //   break;
        case 3:
          section = 'rejected';
          break;

        case 4:
          section = 'all';
          break;

        default:
          section = 'waiting-confirmation';
        // case 1:
        //   section = 'sending';
        //   break;
        // case 2:
        //   section = 'received';
        //   break;
        // case 3:
        //   section = 'waiting-payment';
        //   break;
        // case 4:
        //   section = 'all';
        //   break;
        // default:
        //   section = 'waiting-confirmation';
      }

      var response = await api.dynamicGet(
        endpoint: '/getOrder?section=$section',
        section: 'cart',
        page: 'get-order',
        contentType: 'application/json',
      );

      print("DATA HASIL ALL CATEGORY $section ORDER $response");

      orders = OrderResModel.fromJson(response.data).data!.rows;

      switch (index) {
        case 1:
          // update(['processing-order']);
          update(['waiting-payment-order']);
          break;
        case 2:
          update(['received-order']);
          break;
        // case 3:
        //   update(['waiting-payment-order']);
        //   break;
        case 3:
          update(['rejected']);
          break;

        case 4:
          update(['all-order']);
          break;

        default:
          update(['new-order']);
        // case 1:
        //   update(['packaging-order']);
        //   break;
        // case 2:
        //   update(['sending-order']);
        //   break;
        // case 3:
        //   update(['received-order']);
        //   break;
        // default:
        //   update(['all-order']);
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

  void tabChange({int? tab}) async {
    index = tab ?? 0;
    await getOrder();
  }

  void detailOrder({int? orderId}) async {
    try {
      var response = await api.dynamicGet(
        endpoint: '/getOrder/$orderId',
        section: 'cart',
        page: 'get-order',
        contentType: 'application/json',
      );

      print("HASIL ORDER BY ID DETAIL $response");
      selectedOrder = OrderDetailResModel.fromJson(response.data).data;

      Get.to(OrderDetailPage());
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

  void orderTracker() {
    Get.to(OrderTrackerScreen(
      orderDate: selectedOrder?.order?.orderCreatedDate,
      paymentDate: selectedOrder?.order?.paymentDate,
      confirmedDate: selectedOrder?.order?.confirmedDate,
      // packingDate: selectedOrder?.order?.packingDate,
      sendingDate: selectedOrder?.order?.sendDate,
      receivedDate: selectedOrder?.order?.receivedDate,
    ));
  }

  void orderedReceived(context) async {
    try {
      CustomShowDialog().openLoading(context);

      var data = {
        "order_id": selectedOrder?.order?.id,
      };

      var response = await api.dynamicPost(
        endpoint: '/status-order?section=sending',
        page: 'payment',
        data: data,
        section: 'payment',
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        CustomShowDialog().closeLoading();
        await getOrder();
        var response = await api.dynamicGet(
          endpoint: '/getOrder/${selectedOrder?.order?.id}',
          section: 'cart',
          page: 'get-order',
          contentType: 'application/json',
        );

        selectedOrder = OrderDetailResModel.fromJson(response.data).data;

        update(['order-detail']);
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
}
