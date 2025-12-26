import 'package:embeyi/core/component/image/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';

import '../../utils/constants/app_icons.dart';

class SuccessDialog {
  /// Shows a reusable success dialog with customizable content
  static void show({
    required String message,
    String? buttonText,
    VoidCallback? onTap,
    IconData? icon,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with circular background
              CommonImage(imageSrc: "assets/images/success.png", width: 120.w, height: 120.h),
              SizedBox(height: 24.h),
              CommonText(
                text: 'Congratulations!',
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),

              // Success message
              CommonText(
                text: message,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryText,
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
              SizedBox(height: 32.h),

              // Action button
              CommonButton(
                titleText: buttonText ?? "OK",
                onTap: onTap ?? () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a success dialog specifically for application submission
  static void showApplicationSuccess({
    required String message,
    required String buttonText,
    VoidCallback? onBackToHome,
  }) {
    show(
      message: message,
      buttonText: buttonText,
      onTap: onBackToHome ?? () => Get.back(),
    );
  }

  /// Shows a success dialog with custom navigation
  static void showWithNavigation({
    required String message,
    required String buttonText,
    required String routeName,
    Map<String, dynamic>? arguments,
    bool offAllNamed = false,
  }) {
    show(
      message: message,
      buttonText: buttonText,
      onTap: () {
        if (offAllNamed) {
          Get.offAllNamed(routeName, arguments: arguments);
        } else {
          Get.toNamed(routeName, arguments: arguments);
        }
      },
    );
  }
}
