import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';

import '../../data/model/interview_details.dart';
import '../controller/complete_interview_controller.dart';

class CompleteInterviewDetailsScreen extends StatelessWidget {
  const CompleteInterviewDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompleteInterviewDetailsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppbar(
        title: 'Interview',
        showLeading: true,
        centerTitle: true,
        backgroundColor: AppColors.white,
        textColor: AppColors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText(
                  text: controller.errorMessage.value,
                  fontSize: 14.sp,
                  color: AppColors.red,
                ),
                16.height,
                CommonButton(
                  titleText: 'Retry',
                  onTap: () => controller.fetchApplicationDetails(),
                ),
              ],
            ),
          );
        }

        if (controller.applicationData.value == null) {
          return Center(
            child: CommonText(
              text: 'No data available',
              fontSize: 14.sp,
              color: AppColors.secondaryText,
            ),
          );
        }

        final data = controller.applicationData.value!;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildJobTitleSection(controller, data),
                16.height,
                _buildInterviewerCard(controller, data),
                16.height,
                if (data.feedback != null && data.feedback!.isNotEmpty)
                  _buildFeedbackSection(controller, data),
                if (data.feedback != null && data.feedback!.isNotEmpty)
                  16.height,
                _buildHiringStatusSection(controller, data),
                16.height,
                _buildTimelineSection(controller, data),
                16.height,
                _buildResumeSection(controller, data),
                24.height,
                _buildMessageButton(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildJobTitleSection(
      CompleteInterviewDetailsController controller, ApplicationData data) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText(
            text: data.post.title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          8.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonImage(
                imageSrc: AppIcons.location,
                size: 18.w,
                imageColor: AppColors.secondaryText,
              ),
              4.width,
              Flexible(
                child: CommonText(
                  text: data.post.location,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryText,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          12.height,
          CommonText(
            text: controller.getFormattedSalary(),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
            textAlign: TextAlign.center,
          ),
          12.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChip(controller.getJobTypeLabel(data.post.jobType)),
              8.width,
              _buildChip(controller.getInterviewTypeLabel(
                  data.interviewDetails?.interviewType)),
              8.width,
              _buildChip(data.yearOfExperience),
            ],
          ),
          12.height,
          CommonText(
            text: controller.getPostedInfo(),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryText,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    if (label.isEmpty) return SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: CommonText(
        text: label,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryText,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInterviewerCard(
      CompleteInterviewDetailsController controller, ApplicationData data) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.filledColor,
            ),
            child: ClipOval(
              child: data.user.image.isNotEmpty
                  ? Image.network(
                ApiEndPoint.imageUrl + "${data.user.image}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return CommonImage(
                      imageSrc: AppImages.profile, size: 60.w);
                },
              )
                  : CommonImage(imageSrc: AppImages.profile, size: 60.w),
            ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: data.user.name,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  textAlign: TextAlign.left,
                ),
                4.height,
                CommonText(
                  text: data.post.title,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  textAlign: TextAlign.left,
                ),
                4.height,
                CommonText(
                  text: data.yearOfExperience,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryText,
                  textAlign: TextAlign.left,
                ),
                4.height,
                if (data.interviewDetails != null)
                  CommonText(
                    text:
                    'Interview Date: ${controller.getFormattedDate(data.interviewDetails!.date)} At ${data.interviewDetails!.time}',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                    textAlign: TextAlign.left,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(
      CompleteInterviewDetailsController controller, ApplicationData data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: 'Feedback',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.left,
          ),
          8.height,
          CommonText(
            text: data.feedback ?? '',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryText,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildHiringStatusSection(
      CompleteInterviewDetailsController controller, ApplicationData data) {
    final status = data.hiringStatus ?? '';
    Color statusColor;
    String statusLabel;

    switch (status.toLowerCase()) {
      case 'hired':
        statusColor = Colors.green;
        statusLabel = 'Hired';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusLabel = 'Rejected';
        break;
      case 'shortlisted':
        statusColor = Colors.blue;
        statusLabel = 'Shortlisted';
        break;
      case 'on hold':
        statusColor = Colors.orange;
        statusLabel = 'On Hold';
        break;
      default:
        statusColor = AppColors.secondaryText;
        statusLabel = status;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          CommonText(
            text: 'Hiring Status: ',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.left,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusColor),
            ),
            child: CommonText(
              text: statusLabel,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: statusColor,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(
      CompleteInterviewDetailsController controller, ApplicationData data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: 'Timeline',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            textAlign: TextAlign.left,
          ),
          16.height,
          ...data.history.asMap().entries.map((entry) {
            final index = entry.key;
            final history = entry.value;
            final isLast = index == data.history.length - 1;

            return Column(
              children: [
                if (index > 0) 16.height,
                _buildTimelineItem(
                  controller: controller,
                  title: history.title,
                  date: controller.getFormattedDate(history.date),
                  description: history.description,
                  isLast: isLast,
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required CompleteInterviewDetailsController controller,
    required String title,
    required String date,
    required String description,
    required bool isLast,
  }) {
    // Determine color based on title
    Color statusColor = AppColors.primaryColor;
    if (title.toLowerCase() == 'rejected') {
      statusColor = Colors.red;
    } else if (title.toLowerCase() == 'hired' || title.toLowerCase() == 'shortlisted') {
      statusColor = Colors.green;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color: AppColors.borderColor,
              ),
          ],
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: title,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                textAlign: TextAlign.left,
              ),
              4.height,
              CommonText(
                text: date,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryText,
              ),
              if (description.isNotEmpty) ...[
                4.height,
                CommonText(
                  text: description,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryText,
                  textAlign: TextAlign.left,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResumeSection(
      CompleteInterviewDetailsController controller, ApplicationData data) {
    return GestureDetector(
      onTap: () => controller.downloadResume(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          shadows: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            CommonImage(imageSrc: AppIcons.pdf, size: 24.w),
            12.width,
            Expanded(
              child: CommonText(
                text: data.resume.split('/').last,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
                textAlign: TextAlign.left,
              ),
            ),
            CommonImage(
              imageSrc: AppIcons.download,
              size: 20.w,
              imageColor: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageButton(CompleteInterviewDetailsController controller) {
    return CommonButton(
      titleText: 'Message',
      titleSize: 16,
      titleWeight: FontWeight.w600,
      buttonHeight: 50.h,
      buttonRadius: 8.r,
      titleColor: AppColors.primaryColor,
      buttonColor: AppColors.white,
      isGradient: false,
      borderColor: AppColors.primaryColor,
      onTap: () => controller.onMessageTap(),
    );
  }
}