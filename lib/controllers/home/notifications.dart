import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Order/main.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/notification_model.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';


class NotificationController extends GetxController {
  List<Notifications> notifications = [];
  int selectedIndex = -1;
  RestApi api = Get.put(RestApi());
  OrderController orderController = Get.put(OrderController());

  void init() {
    getNotification();
    selectedIndex = -1;
  }

  void onBackTap() {
    Get.back();
  }

  void onNotificationTap(int index) {

    selectedIndex = index;

    update(['notification_list']);

    if(notifications[index].notificationType == "payment" && notifications[index].orderId != null)
    {
      orderController.detailOrder(orderId: notifications[index].orderId);
    }
    if(notifications[index].notificationIsRead == false){
      readNotification(notifications[index].id!);
    }
  }

  Future getNotification() async {
    try {
      var response = await api.dynamicGet(
        section: 'user',
        endpoint: '/notification',
        page: 'notification',
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        NotificationModel model = NotificationModel.fromJson(response.data);
        if (model.data != null) {
          notifications = model.data!;
          update(['notification_list']);
        }
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

  Future readNotification(int id) async {
    try {
      var response = await api.dynamicUpdate(
        section: 'user',
        endpoint: '/notification/$id',
        data: [],
        page: 'notification',
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        Map<String,dynamic> data = response.data;

        if(data['status'] == "Success"){
          getNotification();
        }else{
          Get.snackbar(
            data['status'],
            data['message'].toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
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
