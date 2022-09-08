import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Return/return.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';

class NewRequest extends StatelessWidget {
  final ReturnControllers controller = Get.find<ReturnControllers>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnControllers>(
      id: 'newRequest',
      builder: (_) {
        return Container(
          color: Color(0xff757575),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  appbarRequestReturn(),
                  divider(topSpace: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 6),
                            child: Text(
                              "ORDER ID",
                              style: TextStyle(
                                color: Color(0xFF292929),
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 48,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Color(0xFFECECEC),
                                        width: 1,
                                      ),
                                    ),
                                    child: TextField(
                                      style: TextStyle(
                                        color: Color(0xFF292929),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      controller: controller.orderController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(bottom: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: controller.onCheckTap,
                                  child: Container(
                                    height: 48,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Color(0xFF2D368B),
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      "Check",
                                      style: TextStyle(
                                        color: Color(0xFF2D368B),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          divider(),
                          controller.products.isEmpty
                              ? SizedBox()
                              : Column(
                                  children: [
                                    buildOrderDetail(context),
                                    divider(),
                                    buildReason(context),
                                    SizedBox(height: 48),
                                    Center(
                                      child: CustomButton(
                                        sizeHeight: 40,
                                        sizeWidth:
                                        MediaQuery.of(context).size.width / 2.25,
                                        text: 'Submit',
                                        borderRadiusSize: 50,
                                        textColor: Colors.white,
                                        colorButton: primaryColor,
                                        borderSideColor: Colors.transparent,
                                        onPressed: controller.onSubmitTap,
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildOrderDetail(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 40),
              Text(
                "PRODUCT",
                style: TextStyle(
                  color: Color(0xFF292929),
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
              ),
              Spacer(),
              Text(
                "QTY TO RETURN",
                style: TextStyle(
                  color: Color(0xFF292929),
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView.builder(
            itemCount: controller.products.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context1, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        child: Checkbox(
                          side: BorderSide(
                            color: controller.checked[index] == true
                                ? primaryColor
                                : Color(0xFFACACAC),
                          ),
                          activeColor: primaryColor,
                          checkColor: Colors.white,
                          value: controller.checked[index],
                          onChanged: (newValue) {
                            controller.onTapCheckBox(index);
                          },
                        ),
                      ),
                      SizedBox(width: 19),
                      SizedBox(
                        width: Get.width - (88 + 20 + 40 + 19 + 14),
                        child: Text(
                          controller.products[index]
                              .productName!,
                          style: TextStyle(
                            color: Color(0xFF292929),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                      Container(
                        width: 88,
                        height: 42,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color(0xFFECECEC),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF292929),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (str) => controller.checkQty(index),
                          controller: controller.qtyController[index],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.only(bottom: 13.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  index !=
                          (controller.products.length -
                              1)
                      ? divider(topSpace: 10, bottomSpace: 10)
                      : SizedBox(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildReason(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "REASON",
            style: TextStyle(
              color: Color(0xFF292929),
              fontWeight: FontWeight.w500,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 6),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 5),
            width: Get.width,
            height: 100,
            child: TextField(
              controller: controller.returnReason,
              maxLines: 10,
              style: TextStyle(
                color: Color(0xFF292929),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: "Other",
                hintStyle: TextStyle(
                  color: Color(0xFF292929),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFECECEC), width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFECECEC), width: 1.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFECECEC), width: 1.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row appbarRequestReturn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.close),
          ),
        ),
        Expanded(
          flex: 7,
          child: Center(
            child: Text(
              'Request Return',
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF292929),
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(),
        ),
      ],
    );
  }

  Widget divider({double? topSpace, double? bottomSpace}) {
    return Container(
      margin: EdgeInsets.only(
        top: topSpace ?? 14,
        bottom: bottomSpace ?? 14,
      ),
      height: 0.5,
      width: Get.width,
      color: Color(0XFFE3E3E3),
    );
  }
}
