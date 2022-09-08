import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final double? sizeWidth;
  final double? sizeHeight;
  final double? borderRadiusSize;
  final Color? borderSideColor;
  final Color? colorButton;
  final Color? textColor;
  final double? fontSize;
  final double? elevation;

  const CustomButton({
    Key? key,
    this.text,
    this.onPressed,
    this.sizeWidth,
    this.sizeHeight,
    this.borderRadiusSize,
    this.borderSideColor,
    this.colorButton,
    this.textColor,
    this.fontSize,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          Size(sizeWidth ?? double.infinity, sizeHeight ?? 60),
        ),
        backgroundColor:
            MaterialStateProperty.all(colorButton ?? secondaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSize ?? 30),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(color: borderSideColor ?? secondaryColor),
        ),
        elevation: MaterialStateProperty.all(elevation ?? 2),
      ),
      child: Center(
        child: Text(
          text ?? "",
          style: TextStyle(
            color: textColor ?? primaryColor,
            fontSize: fontSize ?? 16,
          ),
        ),
      ),
    );
  }
}
