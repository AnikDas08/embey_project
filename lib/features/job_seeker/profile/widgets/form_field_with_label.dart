import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';

class FormFieldWithLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? suffixIcon;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const FormFieldWithLabel({
    super.key,
    required this.label,
    required this.controller,
    this.suffixIcon,
    this.maxLines,
    this.textInputAction,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: label,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 8.h),
        CommonTextField(
          controller: controller,
          borderColor: const Color(0xFFE0E0E0),
          borderRadius: 8.r,
          paddingHorizontal: 16.w,
          paddingVertical: 14.h,
          textColor: AppColors.black,
          maxLines: maxLines,
          textInputAction: textInputAction ?? TextInputAction.next,
          keyboardType: keyboardType ?? TextInputType.text,
          readOnly: readOnly,
          onTap: onTap,
          suffixIcon: suffixIcon != null
              ? Icon(
                  suffixIcon!,
                  color: _getIconColor(suffixIcon!),
                  size: 20.sp,
                )
              : null,
        ),
      ],
    );
  }

  Color _getIconColor(IconData icon) {
    switch (icon) {
      case Icons.calendar_today:
        return const Color(0xFFA0A0A0);
      case Icons.keyboard_arrow_down:
        return const Color(0xFF666666);
      default:
        return const Color(0xFF666666);
    }
  }
}
