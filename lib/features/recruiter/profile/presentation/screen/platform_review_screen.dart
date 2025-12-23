import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../../../../job_seeker/profile/presentation/controller/platform_review_controller.dart';
//import '../controller/platform_review_controller.dart';

class PlatformReviewScreen extends StatelessWidget {
  PlatformReviewScreen({super.key});

  final controller = Get.put(PlatformReviewController());
  final selectedRating = 0.obs;
  final reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: 'Platform Review',
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Review Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.star_border,
                          size: 64.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      16.height,
                      const CommonText(
                        text: 'Rate Your Experience',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      8.height,
                      CommonText(
                        text: 'Help us improve by sharing your feedback',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryText,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                32.height,

                /// Rating Section
                const CommonText(
                  text: 'How would you rate us?',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                16.height,
                Center(
                  child: Obx(
                        () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            selectedRating.value = index + 1;
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Icon(
                              index < selectedRating.value
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 48.sp,
                              color: index < selectedRating.value
                                  ? AppColors.warning
                                  : AppColors.secondaryText,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Obx(() {
                  if (selectedRating.value > 0) {
                    return Column(
                      children: [
                        8.height,
                        Center(
                          child: CommonText(
                            text: _getRatingText(selectedRating.value),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
                32.height,

                /// Review Text Area
                const CommonText(
                  text: 'Share your thoughts',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                16.height,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: reviewController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Write your review here...',
                      hintStyle: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.w),
                    ),
                    onChanged: (value) {
                      // Trigger rebuild to enable/disable button
                      selectedRating.refresh();
                    },
                  ),
                ),
                32.height,

                /// Submit Button
                Obx(
                      () => controller.isLoading.value
                      ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                      : CommonButton(
                    titleText: 'Submit Review',
                    onTap: selectedRating.value > 0 &&
                        reviewController.text.isNotEmpty
                        ? () async {
                      final success = await controller.submitReview(
                        rating: selectedRating.value,
                        comment: reviewController.text.trim(),
                      );
                      if (success) {
                        _showThankYouDialog(context);
                      }
                    }
                        : null,
                    buttonColor: selectedRating.value > 0 &&
                        reviewController.text.isNotEmpty
                        ? AppColors.primary
                        : AppColors.secondaryText,
                  ),
                ),
                24.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 64.sp),
            16.height,
            const CommonText(
              text: 'Thank You!',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            8.height,
            CommonText(
              text: 'Your review has been submitted successfully',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryText,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            24.height,
            CommonButton(
              titleText: 'Done',
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}