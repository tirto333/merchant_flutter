import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Cart/confirm.dart';
import 'package:winn_merchant_flutter/controllers/Cart/main.dart';
import 'package:winn_merchant_flutter/controllers/main_tab_controller.dart';
import 'package:winn_merchant_flutter/models/Cart/cart.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';
import '../main_tab.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  MainPageController tab = Get.find<MainPageController>();
  final ConfirmOrderController controller = Get.find<ConfirmOrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: WinnGeneralText(
            title: "Order Request",
            colorTitle: Colors.black87,
            fontSize: 18,
            border: TextDecoration.none,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
          ),
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              controller.confirmRequestOrder(context);
            },
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/checkIcon.svg'),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Thank you for your order request!",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: primaryGreen),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "Please kindly wait for our confirmation,\nWe will let you know if your product request accepted",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF737373), fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ));
  }
}
