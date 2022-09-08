import 'package:flutter/material.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class CustomAppBar {
  generalAppBar({
    @required String? title,
    double? fontSize,
    Color? titleColor,
    bool? implyLeading,
    Widget? leading,
  }) {
    return AppBar(
      elevation: 0,
      title: WinnGeneralText(
        title: title,
        colorTitle: titleColor ?? Colors.black87,
        fontSize: fontSize ?? 18,
        border: TextDecoration.none,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      automaticallyImplyLeading: implyLeading ?? true,
      leading: leading,
    );
  }

  tapAppBar({
    @required String? title,
    @required Function()? onpress,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 20,
          ),
          onPressed: onpress,
        ),
        Spacer(),
        Text(
          title ?? '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 30),
        Spacer(),
      ],
    );
  }
}
