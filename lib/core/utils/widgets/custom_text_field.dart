import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final bool? enabled;
  final int? maxLines;
  final int? maxLength;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final List<BoxShadow>? boxShadow;

  const CustomTextField({
    super.key,
    this.controller,
    this.title,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.onChange,
    this.onFieldSubmitted,
    this.focusNode,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled,
    this.maxLines = 1,
    this.maxLength,
    this.borderRadius,
    this.contentPadding,
    this.style,
    this.hintStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppDeco.radius);
    final border = BorderSide(
      color: borderColor ?? AppColor.borderLight,
      width: 1.0,
    );
    final focusedBorder = BorderSide(
      color: focusedBorderColor ?? AppColor.white,
      width: 1.5,
    );
    const errorBorder = BorderSide(
      color: AppColor.red,
      width: 1.0,
    );
    const focusedErrorBorder = BorderSide(
      color: AppColor.red,
      width: 1.5,
    );

    Widget field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChange,
      onFieldSubmitted: onFieldSubmitted,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      obscureText: obscureText,
      readOnly: readOnly,
      autofocus: autofocus,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      cursorColor: AppColor.white,
      style: style ??
          (readOnly
              ? AppText.bodyMd.copyWith(color: AppColor.textGrey)
              : AppText.bodyMd),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ??
            (readOnly ? AppColor.cardLight : AppColor.cardAlt),
        hintText: hintText,
        hintStyle: hintStyle ??
            AppText.captionSm.copyWith(color: AppColor.textGrey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconConstraints: prefixIconConstraints ??
            (prefixIcon != null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null),
        suffixIconConstraints: suffixIconConstraints ??
            (suffixIcon != null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null),
        counterText: maxLength != null ? '' : null,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: radius, borderSide: border),
        enabledBorder:
            OutlineInputBorder(borderRadius: radius, borderSide: border),
        focusedBorder:
            OutlineInputBorder(borderRadius: radius, borderSide: focusedBorder),
        errorBorder:
            OutlineInputBorder(borderRadius: radius, borderSide: errorBorder),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: focusedErrorBorder,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: AppColor.borderFaint,
            width: 1.0,
          ),
        ),
        errorStyle: const TextStyle(
          color: AppColor.red,
          fontSize: 12,
        ),
      ),
    );

    if (boxShadow != null) {
      field = Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: boxShadow,
        ),
        child: field,
      );
    }

    if (title != null && title!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title!,
            style: AppText.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColor.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          field,
        ],
      );
    }

    return field;
  }
}
