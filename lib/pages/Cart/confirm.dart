import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Cart/confirm.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
// import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class ConfirmOrderPage extends StatelessWidget {
  final ConfirmOrderController controller = Get.find<ConfirmOrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().generalAppBar(
        title: "Customer Details",
      ),
      body: GetBuilder<ConfirmOrderController>(
        id: 'confirm',
        builder: (_) {
          return ListView(
            children: [
              SizedBox(height: 10),
              buildAddress(context),
              SizedBox(height: 10),
              Divider(height: 10, thickness: 3),
              SizedBox(height: 10),
              buildShipping(),
              SizedBox(height: 10),
              Divider(height: 10, thickness: 3),
              SizedBox(height: 10),
              buildProductOverview(context),
              SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
      bottomNavigationBar: buildBottomButton(context),
    );
  }

  Widget buildBottomButton(context) {
    return Container(
      height: 70,
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: CustomButton(
        text: "Confirm Order",
        borderRadiusSize: 10,
        textColor: Colors.white,
        colorButton: primaryColor,
        borderSideColor: Colors.transparent,
        onPressed: () {
          controller.confirmOrder(context);
        },
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
            title: 'PRODUCT OVERVIEW',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            colorTitle: Color(0xffAAAAAA),
            textAlign: TextAlign.start,
            border: TextDecoration.none,
          ),
          SizedBox(height: 10),
          productOverview(context),
          SizedBox(height: 10),
          priceSection(
            section: 'Sub-Total',
            price: controller.checkout!.subtotal,
          ),
          SizedBox(height: 10),
          priceSection(
            section: 'Courier Shipping (${controller.checkout!.weight}Kg)',
            price: controller.shippingFee,
          ),
          SizedBox(height: 10),
          priceSection(
            section: 'Convenience Fee',
            price: controller.checkout!.convenienceFee,
          ),
          SizedBox(height: 10),
          priceSection(
            section: 'Total',
            textBold: FontWeight.bold,
            price: controller.priceTotal,
          ),
        ],
      ),
    );
  }

  Widget productOverview(context) {
    return Column(
      children: List.generate(
        controller.checkout!.productOverviews!.length,
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
                          title:
                              'x${controller.checkout!.productOverviews![index].quantity}',
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
                            title: controller
                                .checkout!.productOverviews![index].productName,
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
                      NumberFormat.currency(
                        decimalDigits: 0,
                        symbol: 'Rp.',
                      ).format(
                        controller
                            .checkout!.productOverviews![index].afterDiscount,
                      ),
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

  Widget buildShipping() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              WinnGeneralText(
                title: 'SHIPPING METHOD',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                colorTitle: Color(0xffAAAAAA),
                textAlign: TextAlign.start,
                border: TextDecoration.none,
              ),
              SizedBox(width: 5),
              SvgPicture.asset('assets/icons/info.svg')
            ],
          ),
          SizedBox(height: 5),
          // ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: controller.shippings.length,
          //   itemBuilder: (context, index) {
          //     return CustomRadio<int>(
          //       label:
          //           "${controller.shippings[index].name} (x ${controller.shippings[index].weight}kg) = ${NumberFormat.currency(
          //         decimalDigits: 0,
          //         symbol: 'Rp.',
          //       ).format(
          //         controller.shippings[index].price,
          //       )}",
          //       value: index,
          //       groupValue: controller.selectedShippingIndex,
          //       onChanged: controller.shippings[index].disabled != false
          //           ? (int newValue) {
          //               CustomShowDialog().infoDialog(
          //                 'Kawasan anda belum terjangkau oleh kurir.',
          //               );
          //             }
          //           : (int newValue) {
          //               controller.changeShippingMethod(value: newValue);
          //             },
          //       padding: EdgeInsets.all(0),
          //     );
          //   },
          // )
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
            title: 'ADDRESS INFORMATION',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            colorTitle: Color(0xffAAAAAA),
            textAlign: TextAlign.start,
            border: TextDecoration.none,
          ),
          SizedBox(height: 10),
          // AddressCard(
          //   label: controller.checkout?.address?.label,
          //   name: controller.checkout?.address?.name,
          //   phone: controller.checkout?.address?.phone,
          //   status: controller.checkout?.address?.status,
          //   address: controller.checkout?.address?.address,
          //   onTap: () {
          //     controller.redirectToAddress();
          //   },
          // ),
          SizedBox(height: 10),
          CustomButton(
            text: "Change Address",
            borderRadiusSize: 5,
            colorButton: Colors.white,
            borderSideColor: Colors.grey.shade200,
            elevation: 0,
            onPressed: () {
              controller.redirectToAddress();
            },
          )
        ],
      ),
    );
  }
}
