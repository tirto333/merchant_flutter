import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Order/main.dart';
// import 'package:winn_merchant_flutter/pages/Order/order_detail.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';
import 'package:winn_merchant_flutter/widgets/order_card.dart';

class MyOrderPage extends StatefulWidget {
  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  final OrderController controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        controller.tab.backToHome();
        throw ({null});
      },
      child: DefaultTabController(
        initialIndex: controller.index,
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: WinnGeneralText(
              title: 'My Order',
              colorTitle: Colors.black87,
              fontSize: 18,
              border: TextDecoration.none,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            bottom: TabBar(
              indicatorColor: orangeColor,
              labelColor: primaryColor,
              unselectedLabelColor: primaryColor.withOpacity(0.8),
              indicatorWeight: 3,
              isScrollable: true,
              onTap: (index) {
                controller.tabChange(tab: index);
              },
              tabs: [
                Tab(
                  icon: SvgPicture.asset('assets/icons/order_inactive.svg'),
                  child: Text(
                    "My Order",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                Tab(
                  icon: SvgPicture.asset('assets/icons/packing.svg'),
                  child: Text(
                    "Confirmed",
                    style: TextStyle(fontSize: 9),
                  ),
                ),
                Tab(
                  icon: SvgPicture.asset('assets/icons/sending.svg'),
                  child: Text(
                    "Sent",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                Tab(
                  icon: SvgPicture.asset('assets/icons/Union.svg'),
                  child: Text(
                    "Pending",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                Tab(
                  icon: SvgPicture.asset('assets/icons/history.svg'),
                  child: Text(
                    "History",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              viewTab(
                context,
                'new-order',
              ),
              viewTab(
                  context,
                  // 'processing-order',
                  'waiting-payment-order'),
              viewTab(
                context,
                'received-order',
              ),
              // viewTab(
              //   context,
              //   'waiting-payment-order'
              //   // 'pending-order',
              // ),
              viewTab(
                context,
                'rejected',
              ),
              viewTab(
                context,
                'all-order',
              ),
            ],
          ),
        ),
      ),
    );
  }

  GetBuilder<OrderController> viewTab(BuildContext context, String id) {
    return GetBuilder<OrderController>(
      id: id,
      builder: (_) {
        if (controller.orders!.length != 0) {
          return Container(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.orders!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    // child: Text(controller.orders![index].status!),
                    child: OrderCard(
                      onTap: () {
                        controller.detailOrder(
                            orderId: controller.orders![index].id);
                        // Get.to(OrderDetailPage(
                        //   orderDate: controller.orders![index].orderCreatedDate,
                        //   companyName: controller.orders![index].companyName,
                        //   generateId: controller.orders![index].generateId,
                        //   status: controller.orders![index].status,
                        //   totalPrice: controller.orders![index].totalPrice.toString(),
                        //   photoUrl: "default-product.png",
                        //   productName: "W1122",
                        //   productType: "Regulator",
                        //   payment: controller.orders![index].payment,
                        // ));
                      },
                      orderDate: controller.orders![index].orderCreatedDate,
                      userName: controller.orders![index].companyName,
                      orderGenerateId: controller.orders![index].generateId,
                      status: controller.orders![index].status,
                      totalPrice: controller.orders![index].totalPrice,
                      photoUrl:
                          '${controller.api.content}/product/${controller.orders![index].products![0].photo}',
                      productName:
                          controller.orders![index].products![0].productName,
                      productType:
                          controller.orders![index].products![0].productCode,
                      payment: controller.orders![index].payment,
                    ),
                  );
                }),
          );
          //   ListView(
          //   children: List.generate(controller.orders!.length, (index) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(
          //         vertical: 10.0,
          //         horizontal: 20.0,
          //       ),
          //       child: OrderCard(
          //         onTap: () {
          //           controller.detailOrder(
          //               orderId: controller.orders![index].id);
          //         },
          //         orderDate: controller.orders![index].orderCreatedDate,
          //         userName: controller.orders![index].userName,
          //         orderGenerateId: controller.orders![index].generateId,
          //         status: controller.orders![index].status,
          //         totalPrice: controller.orders![index].totalPrice,
          //         photoUrl:
          //             '${controller.api.content}/product/${controller.orders![index].products![0].photo}',
          //         productName:
          //             controller.orders![index].products![0].productName,
          //         productType:
          //             controller.orders![index].products![0].productCode,
          //       ),
          //     );
          //   }),
          // );
        }
        return emptyOrder(context);
      },
    );
  }

  Container emptyOrder(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Center(
        child: WinnGeneralText(
          title: 'No order',
          border: TextDecoration.none,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          colorTitle: primaryColor,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
