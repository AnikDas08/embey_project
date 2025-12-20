import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/pop_up/interview_schedule_popup.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/text_field/common_text_field.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../controller/resume_controller.dart';

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecruiterResumeController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppbar(
        title: 'View Resume',
        centerTitle: true,
        actions: [
          Obx(() => Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: controller.isDownloading.value
                ? Padding(
              padding: EdgeInsets.all(12.r),
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.white,
                  ),
                  value: controller.downloadProgress.value,
                ),
              ),
            )
                : IconButton(
              onPressed: controller.resumeUrl.value.isNotEmpty
                  ? () => controller.downloadResume()
                  : null,
              icon: CommonImage(
                imageSrc: AppIcons.download,
                width: 20.w,
                height: 20.h,
              ),
              style: IconButton.styleFrom(
                backgroundColor: controller.resumeUrl.value.isNotEmpty
                    ? AppColors.success
                    : AppColors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(0.r),
              ),
            ),
          )),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (controller.resumeUrl.value.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64.sp,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 16.h),
                  CommonText(
                    text: 'No resume available',
                    fontSize: 16.sp,
                    color: AppColors.grey,
                  ),
                ],
              ),
            );
          }

          return SfPdfViewer.network(
            controller.resumeUrl.value,
            enableDoubleTapZooming: true,
            enableTextSelection: true,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            onDocumentLoadFailed: (details) {
              Get.snackbar(
                'Error',
                'Failed to load PDF: ${details.error}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        // Check if any button should be shown
        final hasAnyButton = controller.showShortlistButton.value ||
            controller.showInterviewButton.value ||
            controller.showRejectButton.value;

        if (!hasAnyButton) {
          // If no action buttons, only show message button
          return SafeArea(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: CommonButton(
                titleText: 'Message',
                onTap: () {
                  Get.toNamed(
                    RecruiterRoutes.message,
                    arguments: {
                      'chatId': '1234567890',
                      'name': 'John Doe',
                      'image': AppImages.profile,
                    },
                  );
                },
                buttonColor: AppColors.transparent,
                titleColor: AppColors.primary,
                buttonHeight: 38.h,
                titleSize: 14.sp,
              ),
            ),
          );
        }

        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10.w,
                  children: [
                    if (controller.showShortlistButton.value)
                      Expanded(
                        child: CommonButton(
                          titleText: 'Shortlist',
                          buttonColor: AppColors.secondaryPrimary,
                          borderColor: AppColors.secondaryPrimary,
                          isGradient: false,
                          onTap: () {
                            controller.shortlistJob();
                          },
                          buttonHeight: 38.h,
                          titleColor: AppColors.white,
                          titleSize: 12.sp,
                        ),
                      ),
                    if (controller.showInterviewButton.value)
                      Expanded(
                        child: CommonButton(
                          titleText: 'Interview',
                          buttonColor: AppColors.success,
                          borderColor: AppColors.success,
                          isGradient: false,
                          onTap: () {
                            controller.clearInterviewForm();
                            showDialog(
                              context: context,
                              builder: (context) => InterviewSchedulePopup(
                                onSubmit: (date, time, interviewType, note) {
                                  controller.interviewDate.text = date;
                                  controller.interviewTime.text = time;
                                  controller.interviewType.value = interviewType.toLowerCase();
                                  controller.interviewNote.text = note;

                                  // Call API
                                  controller.scheduleInterview();
                                },
                              ),
                            );
                          },
                          buttonHeight: 38.h,
                          titleColor: AppColors.white,
                          titleSize: 12.sp,
                        ),
                      ),
                    if (controller.showRejectButton.value)
                      Expanded(
                        child: CommonButton(
                          titleText: 'Reject',
                          buttonColor: AppColors.red,
                          borderColor: AppColors.red,
                          isGradient: false,
                          onTap: () {
                            // Clear reject reason before showing dialog
                            controller.rejectReason.clear();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonText(
                                      text: 'Rejected Reason',
                                      textAlign: TextAlign.start,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Icon(Icons.close),
                                    )
                                  ],
                                ),
                                content: CommonTextField(
                                  controller: controller.rejectReason,
                                  labelText: 'Rejected Reason',
                                  maxLines: 5,
                                  paddingHorizontal: 10.w,
                                  paddingVertical: 10.h,
                                ),
                                actions: [
                                  CommonButton(
                                    titleText: 'Submit',
                                    onTap: () {
                                      controller.rejectJob();
                                    },
                                    buttonHeight: 42.h,
                                    titleColor: AppColors.white,
                                    titleSize: 14.sp,
                                  ),
                                ],
                              ),
                            );
                          },
                          buttonHeight: 38.h,
                          titleColor: AppColors.white,
                          titleSize: 12.sp,
                        ),
                      ),
                  ],
                ),
                10.height,
                CommonButton(
                  titleText: 'Message',
                  onTap: () {
                    Get.toNamed(
                      RecruiterRoutes.message,
                      arguments: {
                        'chatId': '1234567890',
                        'name': 'John Doe',
                        'image': AppImages.profile,
                      },
                    );
                  },
                  buttonColor: AppColors.transparent,
                  titleColor: AppColors.primary,
                  buttonHeight: 38.h,
                  titleSize: 14.sp,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}