import 'package:flutter/material.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class WinnFormField extends StatefulWidget {
  WinnFormField({
    @required this.controller,
    @required this.title,
    this.colorTitle,
    this.textInputAction,
    this.textInputType,
    this.suffixIcon = false,
    this.passReq = false,
    this.onChanged,
    this.obsecure = false,
    this.fillColor,
    this.minLines,
    this.maxLines,
    this.hint,
    this.helper,
  });

  final TextEditingController? controller;
  final Color? colorTitle;
  final String? title;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool suffixIcon;
  final bool passReq;
  final Function(String)? onChanged;
  final bool obsecure;
  final Color? fillColor;
  final int? minLines;
  final int? maxLines;
  final String? hint;
  final String? helper;

  @override
  _WinnFormFieldState createState() => _WinnFormFieldState();
}

class _WinnFormFieldState extends State<WinnFormField> {
  bool _passwordVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WinnGeneralText(
          title: widget.title,
          colorTitle: widget.colorTitle,
          border: TextDecoration.none,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          onChanged: widget.onChanged ?? (val) {},
          obscureText: widget.obsecure ? _passwordVisibility : false,
          minLines: widget.minLines ?? 1,
          maxLines: widget.maxLines ?? 1,
          decoration: InputDecoration(
            hintText: widget.hint,
            fillColor: widget.fillColor ?? Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            suffixIcon: widget.suffixIcon
                ? IconButton(
                    onPressed: widget.suffixIcon
                        ? () {
                            setState(
                              () {
                                _passwordVisibility = !_passwordVisibility;
                              },
                            );
                          }
                        : null,
                    icon: _passwordVisibility
                        ? Icon(
                            Icons.visibility,
                          )
                        : Icon(
                            Icons.visibility_off,
                          ),
                  )
                : widget.passReq
                    ? Icon(
                        Icons.check_outlined,
                      )
                    : null,
          ),
          controller: widget.controller,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          keyboardType: widget.textInputType ?? TextInputType.text,
        ),
        WinnGeneralText(
          title: widget.helper,
          colorTitle: widget.colorTitle,
          border: TextDecoration.none,
        ),
      ],
    );
  }
}
