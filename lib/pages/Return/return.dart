import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Return/return.dart';
import 'package:winn_merchant_flutter/pages/Return/return_card.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';

// ignore: must_be_immutable
class ReturnPage extends StatelessWidget {
  ReturnPage({Key? key}) : super(key: key);
  ReturnControllers controller = Get.put(ReturnControllers());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        controller.tab.backToHome();
        throw ({null});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar().generalAppBar(
          title: "Product Return",
          leading: SizedBox(),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                text: "Request Return",
                borderRadiusSize: 10,
                textColor: Color(0xFF2D368B),
                colorButton: Colors.white,
                borderSideColor: Color(0xFF2D368B),
                onPressed: () => controller.onRequestReturnTap(context),
              ),
            ),
            GetBuilder<ReturnControllers>(
              id: 'returnProducts',
              builder: (controller) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.returnProducts.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ReturnCard(
                          returnProd: controller.returnProducts[index],
                          userName: controller.returnModel.name ?? '',
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
