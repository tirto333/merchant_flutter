import 'package:flutter/material.dart';

import 'general_text.dart';

class AddressCard extends StatelessWidget {
  final void Function()? onTap;
  final String? address;
  final String? label;
  final String? name;
  final String? phone;
  final String? status;

  const AddressCard({
    Key? key,
    this.address,
    this.label,
    this.status,
    this.name,
    this.phone,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: WinnGeneralText(
                    title: label,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    border: TextDecoration.none,
                    colorTitle: Colors.black,
                  ),
                ),
                if (status == 'main')
                  WinnGeneralText(
                    title: "Main Address",
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.center,
                    border: TextDecoration.none,
                    colorTitle: Colors.grey,
                  ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WinnGeneralText(
                  title: "$name - $phone",
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                  border: TextDecoration.none,
                  colorTitle: Colors.grey,
                ),
                SizedBox(height: 5),
                WinnGeneralText(
                  title: address,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                  border: TextDecoration.none,
                  colorTitle: Colors.grey,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
