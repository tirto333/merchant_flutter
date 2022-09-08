import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/home/notifications.dart';


class Notifications extends StatelessWidget {
  Notifications({Key? key}) : super(key: key);
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            buildList(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: controller.onBackTap,
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 20,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Center(
                child: Text(
                  "Notifications",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
        Container(
          height: 1,
          color: Color(0xffEFEFEF),
        ),
      ],
    );
  }

  Widget buildList() {
    return Expanded(
      child: GetBuilder<NotificationController>(
        id: 'notification_list',
        builder: (context) {
          return ListView.builder(
            itemCount: controller.notifications.length,
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: InkWell(
                  onTap: () => controller.onNotificationTap(index),
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: controller.selectedIndex != index
                          ? null
                          : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(0, 0),
                          blurRadius: 10,
                        ),
                      ],
                      border: controller.selectedIndex == index
                          ? null
                          : Border.all(color: Color(0xFFF2F2F2), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.notifications[index].notificationTitle
                                  .toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3),
                            SizedBox(
                              width: Get.width - 70,
                              child: Text(
                                controller
                                    .notifications[index].notificationDescription
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF858585),
                                ),
                              ),
                            ),
                          ],
                        ),
                        controller.notifications[index].notificationIsRead ==
                            true
                            ? SizedBox()
                            : Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFED1C24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
