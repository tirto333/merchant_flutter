import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class OrderTrackerScreen extends StatelessWidget {
  const OrderTrackerScreen({
    this.orderDate,
    this.paymentDate,
    this.confirmedDate,
    // this.packingDate,
    this.sendingDate,
    this.receivedDate,
    Key? key,
  }) : super(key: key);

  final String? orderDate;
  final String? paymentDate;
  final String? confirmedDate;
  // final String? packingDate;
  final String? sendingDate;
  final String? receivedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().generalAppBar(
        title: 'Order Tracker',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            trackerComponent(
              context,
              topPadding: null,
              title: 'Ordered',
              date: orderDate,
            ),
            trackerComponent(
              context,
              topPadding: 0,
              title: 'Confirmation Admin',
              date: confirmedDate,
            ),
            trackerComponent(
              context,
              topPadding: 0,
              title: 'Payment',
              date: paymentDate,
            ),
            // trackerComponent(
            //   context,
            //   topPadding: 0,
            //   title: 'Packing',
            //   date: packingDate,
            // ),
            trackerComponent(
              context,
              topPadding: 0,
              title: 'Sending',
              date: sendingDate,
            ),
            trackerComponent(
              context,
              topPadding: 0,
              title: 'Received',
              date: receivedDate,
            ),
          ],
        ),
      ),
    );
  }

  Container trackerComponent(
    BuildContext context, {
    double? topPadding,
    String? title,
    String? date,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconTracker(
            topPadding: topPadding,
            date: date,
            section: title,
          ),
          SizedBox(
            width: 15,
          ),
          trackerInfo(
            context,
            title: title,
            date: date,
          )
        ],
      ),
    );
  }

  Widget trackerInfo(
    BuildContext context, {
    String? title,
    String? date,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WinnGeneralText(
            title: title,
            border: TextDecoration.none,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            colorTitle: Colors.black87,
          ),
          SizedBox(
            height: 5,
          ),
          WinnGeneralText(
            title: date != null
                ? '${DateFormat().format(
                    DateTime.parse(date),
                  )}'
                : '',
            border: TextDecoration.none,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            colorTitle: Colors.black87,
          )
        ],
      ),
    );
  }

  Column iconTracker({
    double? topPadding,
    String? date,
    String? section,
  }) {
    return Column(
      children: [
        section == 'Ordered'
            ? Container()
            : Container(
                height: 10,
                child: VerticalDivider(
                  color: Colors.grey[400],
                ),
              ),
        Padding(
          padding: EdgeInsets.only(top: topPadding ?? 15.0),
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: date != null ? primaryColor : greySub,
              borderRadius: BorderRadius.circular(25),
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
          ),
        ),
        section == 'Received'
            ? Container(
                height: 30,
                child: VerticalDivider(
                  color: Colors.transparent,
                ),
              )
            : Container(
                height: 30,
                child: VerticalDivider(
                  color: Colors.grey[400],
                ),
              ),
      ],
    );
  }
}
