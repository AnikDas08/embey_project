import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import '../../../../subscription/presentation/controller/subscription_controller.dart';
import '../../../data/subscription_model.dart';

class PaymentConfirmationDialog extends StatelessWidget {
  final PackageModel package;

  const PaymentConfirmationDialog({
    super.key,
    required this.package,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gradientColor, AppColors.gradientColor2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.payment,
                size: 40.sp,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20.h),

            // Title
            CommonText(
              text: 'Payment Confirmation',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),

            // Message
            CommonText(
              text: 'You are about to purchase',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20.h),

            // Package Details Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF6FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Package Name
                  CommonText(
                    text: package.name,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12.h),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),

                  SizedBox(height: 12.h),

                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: 'Price:',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      CommonText(
                        text: package.priceText,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Recurring
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: 'Billing:',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      CommonText(
                        text: package.recurring.capitalize ?? package.recurring,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: CommonButton(
                    titleText: 'Cancel',
                    onTap: () => Get.back(),
                    buttonColor: Colors.grey.shade200,
                    titleColor: Colors.black87,
                    //borderRadius: 8,
                  ),
                ),

                SizedBox(width: 12.w),

                // Payment Button
                Expanded(
                  child: CommonButton(
                    titleText: 'Pay Now',
                    onTap: () {
                      Get.back();
                    },
                    isGradient: true,
                    titleColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}