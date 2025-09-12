import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constant/ColorConst/ColorConstant.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle? hintStyle;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? trailingWidget;
  final VoidCallback? trailingClick;
  final bool readOnly;
  final bool obscureText;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final bool? enableInteractiveSelection; // 👈 NEW

  const CommonTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.hintStyle,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.trailingWidget,
    this.trailingClick,
    this.readOnly = false,
    this.obscureText = false,
    this.onTap,
    this.textInputAction,
    this.enableInteractiveSelection, // 👈 NEW
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(8.0));
    const normalBorderColor = ColorConstant.textFieldBorderColor;
    const errorBorderColor = ColorConstant.errorRedColor;

    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: color,
        width: 1.0,
      ),
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      obscureText: obscureText,
      onTap: onTap,
      enableInteractiveSelection: enableInteractiveSelection, // 👈 apply here
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.2,
        letterSpacing: 0,
      ),
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: '',
        isDense: true,
        hintText: hintText,
        hintStyle: hintStyle ??
            const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.43,
              letterSpacing: 0,
              color: Color(0xFF98A2B3),
            ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        constraints: const BoxConstraints(minHeight: 44),
        enabledBorder: border(normalBorderColor),
        focusedBorder: border(normalBorderColor),
        errorBorder: border(errorBorderColor),
        focusedErrorBorder: border(errorBorderColor),
        errorStyle: const TextStyle(
          fontSize: 12,
          height: 1.2,
          color: errorBorderColor,
        ),
        suffixIcon: trailingWidget != null
            ? GestureDetector(
          onTap: trailingClick ?? () {},
          behavior: HitTestBehavior.translucent,
          child: trailingWidget,
        )
            : null,
      ),
    );
  }
}
