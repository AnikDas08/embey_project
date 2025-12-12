import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants/app_colors.dart';
import '../text/common_text.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.prefixIconData,
    this.isPassword = false,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.validator,
    this.prefixText,
    this.paddingHorizontal = 16,
    this.paddingVertical = 20,
    this.borderRadius = 10,
    this.inputFormatters,
    this.fillColor = AppColors.transparent,
    this.hintTextColor = AppColors.textFiledColor,
    this.labelTextColor = AppColors.textFiledColor,
    this.textColor = AppColors.black,
    this.borderColor = AppColors.grey,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.onSubmitted,
    this.onTap,
    this.onChanged,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.height,
    this.isMultiline = false,
  });

  final String? hintText;
  final String? labelText;
  final String? prefixText;
  final Widget? prefixIcon;
  final IconData? prefixIconData;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? labelTextColor;
  final Color? hintTextColor;
  final Color? textColor;
  final Color borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double paddingHorizontal;
  final double paddingVertical;
  final double borderRadius;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool isPassword;
  final double? height;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool isMultiline;
  final TextAlign textAlign;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final FormFieldValidator? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    bool shouldBeMultiline = widget.isMultiline ||
        (widget.maxLines != null && widget.maxLines! > 1) ||
        widget.minLines != null;

    Widget textField = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      textAlign: widget.textAlign,
      inputFormatters: widget.inputFormatters,
      style: GoogleFonts.roboto(
        fontSize: 14.sp,
        color: widget.textColor,
        fontWeight: FontWeight.w400,
      ),
      onFieldSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      validator: widget.validator,
      decoration: InputDecoration(
        errorMaxLines: 2,
        filled: true,
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 12.sp,
          color: widget.hintTextColor,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: widget.prefixIcon ??
            (widget.prefixIconData != null
                ? Icon(widget.prefixIconData,
                color: widget.hintTextColor, size: 20.sp)
                : null),
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20.sp,
              color: AppColors.grey,
            ),
          ),
        )
            : widget.suffixIcon,
        prefix: widget.prefixText != null
            ? CommonText(
          text: widget.prefixText!,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: widget.textColor!,
        )
            : null,
        border: _buildBorder(widget.borderColor),
        enabledBorder: _buildBorder(widget.borderColor),
        focusedBorder: _buildBorder(widget.focusedBorderColor ?? widget.borderColor),
        errorBorder: _buildBorder(widget.errorBorderColor ?? widget.borderColor),
        contentPadding: EdgeInsets.symmetric(
            horizontal: widget.paddingHorizontal.w,
            vertical: shouldBeMultiline
                ? widget.paddingVertical.h
                : widget.paddingVertical.h),
      ),
    );

    if (!shouldBeMultiline && widget.height != null) {
      return SizedBox(height: widget.height, child: textField);
    }

    return textField;
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius.r),
      borderSide: BorderSide(color: color, width: 1.w),
    );
  }
}
