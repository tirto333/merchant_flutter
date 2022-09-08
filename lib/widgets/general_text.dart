import 'package:flutter/material.dart';

class WinnGeneralText extends StatelessWidget {
  WinnGeneralText({
    @required this.title,
    this.colorTitle,
    this.border,
    this.fontSize,
    this.textAlign,
    this.fontWeight,
    this.maxLines,
  });

  final String? title;
  final Color? colorTitle;
  final TextDecoration? border;
  final double? fontSize;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      style: TextStyle(
        color: colorTitle ?? Colors.white,
        fontSize: fontSize ?? 12,
        decoration: border ?? TextDecoration.underline,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
      textAlign: textAlign ?? null,
      maxLines: maxLines ?? null,
      softWrap: true,
    );
  }
}
