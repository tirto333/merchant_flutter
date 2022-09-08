import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/models/return_model.dart';
import 'package:intl/intl.dart';

class ReturnCard extends StatelessWidget {
  final ReturnProd returnProd;
  final String userName;

  const ReturnCard({Key? key, required this.returnProd, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 20,
            color: Colors.black.withOpacity(0.10),
          ),
        ],
        border: Border.all(
          color: Color(0xFFF2F2F2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    returnProd.returnGenerate!,
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 16,
                  width: 0.5,
                  color: Color(0xFFE3E3E3),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    DateFormat("d MMMM yyyy").format(returnProd.createdAt!),
                    style: TextStyle(
                      color: Color(0xFF696969),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 16,
                  width: 0.5,
                  color: Color(0xFFE3E3E3),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    userName,
                    style: TextStyle(
                      color: Color(0xFF696969),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 0.5,
            width: Get.width,
            color: Color(0xFFE3E3E3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID",
                        style: TextStyle(
                          color: Color(0xFF696969),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        returnProd.orderMerchant!.orderGenerate!,
                        style: TextStyle(
                          color: Color(0xFF292929),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                /*Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 28,
                  width: 0.5,
                  color: Color(0xFFE3E3E3),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(
                          color: Color(0xFF696969),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4),
                      requestStatus(0),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
          returnProd.returnDetails == null ||
              returnProd.returnDetails!.length == 0
              ? SizedBox()
              : Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 0.5,
            width: Get.width,
            color: Color(0xFFE3E3E3),
          ),
          returnProd.returnDetails == null ||
              returnProd.returnDetails!.length == 0
              ? SizedBox()
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Product",
                      style: TextStyle(
                        color: Color(0xFF696969),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Quantity",
                      style: TextStyle(
                        color: Color(0xFF696969),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 14),
                    SizedBox(
                      width: 65,
                      child: Text(
                        "Status",
                        style: TextStyle(
                          color: Color(0xFF696969),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: returnProd.returnDetails!.length,
                  itemBuilder: (context, index) {
                    return productList(
                      returnProd.returnDetails![index].product!.name!,
                      returnProd.returnDetails![index].quantity!,
                      index,
                      showDivider:
                      index != (returnProd.returnDetails!.length - 1),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productList(String title, int qty,int index, {bool? showDivider}) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF292929),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 14),
            SizedBox(
              width: 58,
              child: Text(
                qty.toString(),
                style: TextStyle(
                  color: Color(0xFF292929),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: 65,
              child: requestStatus(index),
            ),
          ],
        ),
        showDivider == true
            ? Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: 0.5,
              width: Get.width,
              color: Color(0xFFE3E3E3),
            ),
          ],
        )
            : SizedBox(),
      ],
    );
  }

  Widget requestStatus(int index) {
    int status = 0;
    if (returnProd.returnDetails == null ||
        returnProd.returnDetails!.length == 0 ||
        returnProd.returnDetails![index].status == null ||
        returnProd.returnDetails![index].status == "waiting") {
      status = 0;
    } else if (returnProd.returnDetails![index].status == "activated") {
      status = 1;
    }else if(returnProd.returnDetails![index].status == "rejected"){
      status = 2;
    }
    return Text(
      status == 0 ? "Waiting" : status == 1 ? "Accepted" : "Rejected",
      style: TextStyle(
        color: status == 0 ? Colors.orange : status == 1 ? Color(0xFF1EB536) : Color(0xFFED1C24),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
