import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Address/main.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/address_card.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

import 'edit_address.dart';

class SavedAddressPage extends StatelessWidget {
  final SavedAddressController controller = Get.put(SavedAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().generalAppBar(
        title: "Saved Address",
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CustomButton(
              text: "Add New Address",
              colorButton: Colors.white,
              borderRadiusSize: 5,
              borderSideColor: primaryColor,
              onPressed: () async {
                CustomShowDialog().openLoading(context);
                controller.addEditController.addAddress();
                Timer(Duration(milliseconds: 1000), () {
                  CustomShowDialog().closeLoading();
                  showModalBottomSheet(
                    isDismissible: true,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => EditAddressPage(),
                  );
                });
              },
            ),
            SizedBox(height: 20),
            GetBuilder<SavedAddressController>(
              id: 'list-address',
              builder: (_) {
                return buildAddressList(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddressList(context) {
    print("dipanggil");
    return Container(
      height: MediaQuery.of(context).size.height * 0.737,
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(controller.addresses.length, (index) {
          if (controller.addresses.length > 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: AddressCard(
                label: controller.addresses[index].label,
                name: controller.addresses[index].name,
                phone: controller.addresses[index].phone,
                status: controller.addresses[index].status,
                address: controller.addresses[index].address,
                onTap: () {
                  CustomShowDialog().openLoading(context);
                  controller.addEditController.editAddress(index);
                  Timer(Duration(milliseconds: 2000), () {
                    CustomShowDialog().closeLoading();
                    showModalBottomSheet(
                      isDismissible: true,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => EditAddressPage(),
                    );
                  });
                },
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Center(
                child: Text("Don't have address"),
              ),
            );
          }
        }),
      ),
    );
  }
}
