import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'constants/app_colors.dart';

class Utils {
  /// Global scaffold messenger key so SnackBars work across all screens and transitions without overlay freezing
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void successSnackBar(String title, String message) {
    showSnackBar(
      title: title,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  static void errorSnackBar(dynamic title, String message) {
    showSnackBar(
      title: kDebugMode ? title.toString() : "Error",
      message: message,
      backgroundColor: AppColors.red,
      icon: Icons.error_outline,
    );
  }

  static void showSnackBar({
    required String title,
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Safely attempt to close legacy GetX snackbar if open
    try {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
    } catch (_) {}

    final messenger = scaffoldMessengerKey.currentState;
    final snackBarWidget = SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 22.w),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.sp,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      duration: duration,
    );

    if (messenger != null) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(snackBarWidget);
    } else if (Get.context != null) {
      try {
        final localMessenger = ScaffoldMessenger.maybeOf(Get.context!);
        if (localMessenger != null) {
          localMessenger.hideCurrentSnackBar();
          localMessenger.showSnackBar(snackBarWidget);
        }
      } catch (_) {}
    }
  }

  /// Safe back helper that safely closes dialogs or pops screens without freezing
  static void safeBack<T>({BuildContext? context, T? result}) {
    if (context != null && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
      return;
    }
    if (Get.context != null && Navigator.canPop(Get.context!)) {
      Navigator.pop(Get.context!, result);
      return;
    }
    if (Get.key.currentState?.canPop() ?? false) {
      Get.key.currentState?.pop(result);
      return;
    }
    try {
      if (Get.isDialogOpen ?? false) {
        Get.back(result: result);
        return;
      }
      if (Get.isBottomSheetOpen ?? false) {
        Get.back(result: result);
        return;
      }
      Get.back(result: result);
    } catch (_) {}
  }
}

