import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';

import 'general_text.dart';

class OrderCard extends StatelessWidget {
  OrderCard({
    this.onTap,
    @required this.orderDate,
    @required this.userName,
    @required this.orderGenerateId,
    this.orderId,
    @required this.status,
    @required this.totalPrice,
    @required this.photoUrl,
    @required this.productName,
    @required this.productType,
    this.payment,
  });

  final Function()? onTap;
  final String? orderDate;
  final String? userName;
  final String? orderGenerateId;
  final int? orderId;
  final String? status;
  final double? totalPrice;
  final String? photoUrl;
  final String? productName;
  final String? productType;
  final String? payment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 2,
              color: Colors.grey.shade100,
            )
          ],
        ),
        width: MediaQuery.of(context).size.width - 2 * 10,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: WinnGeneralText(
                      title: orderGenerateId,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      colorTitle: Colors.black87,
                      textAlign: TextAlign.center,
                      border: TextDecoration.none,
                    ),
                  ),
                  verticalDivider(),
                  Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: WinnGeneralText(
                      title: DateFormat("dd MMM y").format(
                        DateTime.parse(orderDate ?? ''),
                      ),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      colorTitle: greySub,
                      textAlign: TextAlign.center,
                      border: TextDecoration.none,
                    ),
                  ),
                  verticalDivider(),
                  Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: WinnGeneralText(
                      title: userName,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      colorTitle: greySub,
                      textAlign: TextAlign.center,
                      border: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  )),
                  child: Image.network(
                    photoUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.3 - 10 - 2 * 10,
                //   height: 90,
                //   margin: EdgeInsets.only(right: 10),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(10),
                //       bottomLeft: Radius.circular(10),
                //     ),
                //     image: DecorationImage(
                //       image: NetworkImage("$photoUrl"),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.7 - 10 - 2 - 5 * 10,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productType ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            productName ?? '',
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              width: MediaQuery.of(context).size.width - 2 * 10,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WinnGeneralText(
                        title: 'Status',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        colorTitle: greySub,
                        textAlign: TextAlign.start,
                        border: TextDecoration.none,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: WinnGeneralText(
                          title: status!.toUpperCase(),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          colorTitle: orangeColor,
                          textAlign: TextAlign.start,
                          border: TextDecoration.none,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       verticalDivider(height: 40),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           WinnGeneralText(
                //             title: 'Status',
                //             fontSize: 12,
                //             fontWeight: FontWeight.w400,
                //             colorTitle: greySub,
                //             textAlign: TextAlign.start,
                //             border: TextDecoration.none,
                //           ),
                //           Container(
                //             width: MediaQuery.of(context).size.width / 3,
                //             child: WinnGeneralText(
                //               title: status!.toUpperCase(),
                //               fontSize: 14,
                //               fontWeight: FontWeight.w600,
                //               colorTitle: orangeColor,
                //               textAlign: TextAlign.start,
                //               border: TextDecoration.none,
                //               maxLines: 2,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Container verticalDivider({double? height}) {
    return Container(
      height: height ?? 30,
      child: VerticalDivider(
        color: Colors.grey[400],
      ),
    );
  }
}
