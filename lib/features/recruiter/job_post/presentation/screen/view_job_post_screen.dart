import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/job_seeker/jobs/presentation/widgets/job_details_widgets.dart' hide DescriptionText;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/view_job_controller.dart';
import '../widgets/description_text.dart';

class ViewJobPostScreen extends StatelessWidget {
  const ViewJobPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewJobController());

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: CommonAppbar(title: 'View Job Post', centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.jobDetails.value == null) {
          return const Center(child: Text('No job details available'));
        }

        final job = controller.jobDetails.value!;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Thumbnail
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CommonImage(
                          imageSrc: job.thumbnail.isNotEmpty
                              ? ApiEndPoint.imageUrl+job.thumbnail
                              : AppImages.jobDetails,
                          fill: BoxFit.fill,
                        ),
                      ),

                      20.height,

                      // Job Details Card
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                          children: [
                            // Job Title Section
                            JobTitleSection(
                              jobTitle: job.title,
                              location: job.location,
                              salary: '\$${job.minSalary} - \$${job.maxSalary}',
                            ),

                            10.height,

                            // Job Info Tags
                            JobInfoTags(
                              isFullTime: job.isFullTime,
                              experience: job.experienceLevel,
                              postedDate: _getPostedDate(job.createdAt),
                              endDate: job.formattedDeadline,
                            ),

                            10.height,

                            // Posted and End Date
                            JobDetailsSectionHeader(
                              title: 'Posted ${_getPostedDate(job.createdAt)}, End Date ${job.formattedDeadline}',
                              color: AppColors.secondaryText,
                            ),
                            8.height,
                          ],
                        ),
                      ),

                      16.height,

                      // Job Category
                      if (job.category.isNotEmpty) ...[
                        CommonText(
                          text: 'Category',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          bottom: 10,
                        ).start,
                        DescriptionText(text: job.category),
                        16.height,
                      ],

                      // Job Type & Level
                      CommonText(
                        text: 'Job Details',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        bottom: 10,
                      ).start,
                      DescriptionText(
                        text: 'Type: ${_formatJobType(job.jobType)} • Level: ${_formatJobLevel(job.jobLevel)}',
                      ),

                      16.height,

                      // Job Description
                      CommonText(
                        text: 'Job Description',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        bottom: 10,
                      ).start,

                      DescriptionText(text: job.description),

                      16.height,

                      // Required Skills
                      if (job.requiredSkills.isNotEmpty) ...[
                        CommonText(
                          text: 'Required Skills',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          bottom: 10,
                        ).start,
                        DescriptionText(
                          text: job.requiredSkills.join(', '),
                        ),
                        16.height,
                      ],

                      // Responsibilities
                      if (job.responsibilities.isNotEmpty) ...[
                        CommonText(
                          text: 'Responsibilities',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          bottom: 10,
                        ).start,
                        ...job.responsibilities.map(
                              (responsibility) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: DescriptionText(text: '• $responsibility'),
                          ),
                        ),
                        16.height,
                      ],

                      // Benefits
                      if (job.benefits.isNotEmpty) ...[
                        CommonText(
                          text: 'Benefits',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          bottom: 10,
                        ).start,
                        ...job.benefits.map(
                              (benefit) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: DescriptionText(text: '• $benefit'),
                          ),
                        ),
                        16.height,
                      ],

                      // Recruiter Info
                      CommonText(
                        text: 'Recruiter Information',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        bottom: 10,
                      ).start,
                      DescriptionText(
                        text: 'Name: ${job.recruiter.name}\nEmail: ${job.recruiter.email}',
                      ),

                      24.height,
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Edit Button
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(color: AppColors.surfaceBackground),
              child: SafeArea(
                top: false,
                child: CommonButton(
                  titleText: 'Edit Post',
                  buttonRadius: 8,
                  onTap: () {
                    Get.toNamed(RecruiterRoutes.editJobPost,arguments:
                    {
                      "postId":controller.postId
                    }
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _getPostedDate(String createdAt) {
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return '1 Day Ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} Days Ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'Week' : 'Weeks'} Ago';
      } else {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'Month' : 'Months'} Ago';
      }
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatJobType(String jobType) {
    return jobType.replaceAll('_', ' ').split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String _formatJobLevel(String jobLevel) {
    return jobLevel.replaceAll('_', ' ').split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}