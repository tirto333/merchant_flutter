import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Order/main.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/address_card.dart';
// import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderController controller = Get.find<OrderController>();

  OrderDetailPage({
    this.orderDate,
    this.companyName,
    this.generateId,
    this.status,
    this.totalPrice,
    this.photoUrl,
    this.productName,
    this.productType,
    this.payment,
  });

  final String? orderDate;
  final String? companyName;
  final String? generateId;
  final String? status;
  final String? totalPrice;
  final String? photoUrl;
  final String? productName;
  final String? productType;
  final String? payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Detail",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<OrderController>(
        id: 'order-detail',
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: ListView(
              children: [
                SizedBox(height: 10),
                buildStatus(context),
                SizedBox(height: 15),
                buildOrderDetail(context),
                SizedBox(height: 10),
                Divider(
                  height: 10,
                  thickness: 1,
                ),
                SizedBox(height: 10),
                // buildAddress(context),
                // SizedBox(height: 10),
                // Divider(
                //   height: 10,
                //   thickness: 1,
                // ),
                // SizedBox(height: 10),
                buildProductOverview(context),
              ],
            ),
          );
        },
      ),
      // bottomNavigationBar: GetBuilder<OrderController>(
      //   id: 'order-detail',
      //   builder: (_) {
      //     return buildBottomButton(context);
      //   },
      // ),
    );
  }

  Widget buildOrderDetail(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WinnGeneralText(
            title: "ORDER DETAILS".toUpperCase(),
            border: TextDecoration.none,
            colorTitle: greySub,
            textAlign: TextAlign.start,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WinnGeneralText(
                        title: 'ORDER ID : ',
                        border: TextDecoration.none,
                        colorTitle: Colors.black87,
                        textAlign: TextAlign.start,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(width: 3),
                      Row(
                        children: [
                          Expanded(
                            child: WinnGeneralText(
                              title:
                                  controller.selectedOrder?.order?.generateId,
                              border: TextDecoration.none,
                              colorTitle: Colors.black87,
                              textAlign: TextAlign.start,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 3),
                          InkWell(
                              onTap: () {
                                Clipboard.setData(new ClipboardData(
                                        text: controller
                                            .selectedOrder?.order?.generateId))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Order Id copied successfully")));
                                });
                              },
                              child: SvgPicture.asset('assets/icons/copy.svg')),
                          // SvgPicture.asset('assets/icons/copy.svg')
                        ],
                      ),
                    ],
                  )),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      detailOrderInfo(
                        section: "Order ID:",
                        value: controller.selectedOrder?.order?.generateId!.substring(0, 10),
                        //value: generateId!.substring(0,10),
                      ),
                      SizedBox(width: 3),
                      SvgPicture.asset('assets/icons/copy.svg')
                    ],
                  ),
                ],
              ),*/
              Container(
                width: MediaQuery.of(context).size.width / 2.3,
                child: detailOrderInfo(
                  section: "DATE : ",
                  value: DateFormat("dd MMMM y").format(
                    DateTime.parse(
                      controller.selectedOrder?.order?.orderCreatedDate ?? '',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: detailOrderInfo(
                  section: "Payment : ",
                  value: controller.selectedOrder?.order?.payment ?? '-',
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.3,
                child: detailOrderInfo(
                  section: "Shipping : ",
                  // value: controller.selectedOrder?.order?.shipping ?? '',
                    value: "Courier Shipping"
                ),
              ),
            ],
          )*/
        ],
      ),
    );
  }

  Row detailOrderInfo({
    String? section,
    String? value,
  }) {
    return Row(
      children: [
        WinnGeneralText(
          title: section,
          border: TextDecoration.none,
          colorTitle: Colors.black87,
          textAlign: TextAlign.start,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        SizedBox(width: 3),
        WinnGeneralText(
          title: value,
          border: TextDecoration.none,
          colorTitle: Colors.black87,
          textAlign: TextAlign.start,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget buildStatus(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey.shade400,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 2,
              color: Colors.grey.shade300,
            )
          ],
        ),
        width: MediaQuery.of(context).size.width - 2 * 10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WinnGeneralText(
                  title: "Status",
                  border: TextDecoration.none,
                  colorTitle: Colors.black87,
                  textAlign: TextAlign.start,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                SizedBox(height: 5),
                WinnGeneralText(
                  title: "${controller.selectedOrder?.order?.status}"
                      .toUpperCase(),
                  // title: status.toString().toUpperCase(),
                  border: TextDecoration.none,
                  colorTitle: orangeColor,
                  textAlign: TextAlign.start,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                controller.orderTracker();
              },
              child: WinnGeneralText(
                title: 'lihat'.toUpperCase(),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                colorTitle: Color(0xFF2D368B),
                border: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomButton(context) {
    return Container(
      height: 150,
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // if (controller.selectedOrder?.order?.status == 'received')
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: CustomButton(
              text: "Buy Again",
              borderRadiusSize: 10,
              textColor: Colors.white,
              colorButton: primaryColor,
              borderSideColor: Colors.transparent,
            ),
          ),
          // if (controller.selectedOrder?.order?.status == 'received')
          CustomButton(
            text: "Return Product",
            borderRadiusSize: 10,
            textColor: Colors.black87,
            colorButton: Colors.white,
            borderSideColor: greySub,
          ),
          // if (controller.selectedOrder?.order?.status == 'waiting-payment')
          CustomButton(
            text: "Payment",
            borderRadiusSize: 10,
            textColor: Colors.white,
            colorButton: Colors.green[400],
            borderSideColor: Colors.green[400],
            onPressed: () {
              // controller.launchInWebViewWithJavaScript(
              //     controller.selectedOrder?.order?.paymentUrl ?? '');
            },
          ),
          // if (controller.selectedOrder?.order?.status == 'sending')
          CustomButton(
            text: "Received",
            borderRadiusSize: 10,
            textColor: Colors.white,
            colorButton: primaryColor,
            borderSideColor: Colors.transparent,
            onPressed: () {
              // controller.orderedReceived(context);
            },
          ),
        ],
      ),
    );
  }

  Widget buildProductOverview(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WinnGeneralText(
            title: "PRODUCT OVERVIEW",
            border: TextDecoration.none,
            colorTitle: greySub,
            textAlign: TextAlign.start,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 10),
          productOverview(context),
          SizedBox(height: 5),
          // priceSection(
          //   section: "Sub-Total",
          //   price: controller.selectedOrder?.subTotal,
          // ),
          SizedBox(height: 10),
          // priceSection(
          //   section: "Courier Shipping (${controller.selectedOrder?.weight}Kg)",
          //   price: controller.selectedOrder?.shippingPrice,
          // ),
          SizedBox(height: 10),
          // priceSection(
          //   section: 'Convenience Fee',
          //   price: controller.selectedOrder?.conveniecePrice,
          // ),
          SizedBox(height: 10),
          // priceSection(
          //   section: 'Total',
          //   price: controller.selectedOrder?.totalPrice,
          //   textBold: FontWeight.bold,
          // ),
        ],
      ),
    );
  }

  Padding buildAddress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WinnGeneralText(
            title: 'Shipping Address'.toUpperCase(),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            colorTitle: greySub,
            textAlign: TextAlign.start,
            border: TextDecoration.none,
          ),
          SizedBox(height: 10),
          AddressCard(
            label: "controller.selectedOrder?.address?.label,",
            name: "controller.selectedOrder?.address?.name,",
            phone: "controller.selectedOrder?.address?.phone",
            status: "controller.selectedOrder?.address?.status",
            address: "controller.selectedOrder?.address?.address",
            onTap: null,
          ),
        ],
      ),
    );
  }

  Row priceSection({String? section, double? price, FontWeight? textBold}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        WinnGeneralText(
          title: '$section',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          colorTitle: Colors.black87,
          textAlign: TextAlign.start,
          border: TextDecoration.none,
        ),
        Text(
          NumberFormat.currency(
            decimalDigits: 0,
            symbol: 'Rp. ',
          ).format(
            price ?? 0,
          ),
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontSize: 14,
            fontWeight: textBold ?? FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget productOverview(context) {
    return Column(
      children: List.generate(
        controller.selectedOrder!.productOverviews!.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: ListBody(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WinnGeneralText(
                          title: controller.selectedOrder!
                              .productOverviews![index].productCode,
                          // 'x${controller.selectedOrder!.productOverviews![index].quantity}',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          colorTitle: Colors.black87,
                          textAlign: TextAlign.start,
                          border: TextDecoration.none,
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: WinnGeneralText(
                            title: controller.selectedOrder!
                                .productOverviews![index].productName,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            colorTitle: Colors.black87,
                            textAlign: TextAlign.start,
                            border: TextDecoration.none,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'x${controller.selectedOrder!.productOverviews![index].quantity}',
                      // NumberFormat.currency(
                      //   decimalDigits: 0,
                      //   symbol: 'Rp.',
                      // ).format(
                      //   controller
                      //       .selectedOrder!.productOverviews![index].subTotal,
                      // ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
