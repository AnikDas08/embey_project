import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/pop_up/job_apply_popup.dart';
import 'package:embeyi/core/component/pop_up/success_dialog.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/job_details_widgets.dart';
import '../controller/job_details_controller.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobDetailsController());

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: CommonAppbar(title: 'Job Description', centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.jobData.value == null) {
          return Center(
            child: CommonText(
              text: 'No job details available',
              fontSize: 16.sp,
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 220.h,
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CommonImage(
                          imageSrc: controller.getThumbnail().isNotEmpty
                              ? ApiEndPoint.imageUrl+controller.getThumbnail()
                              : AppImages.jobDetails,
                          fill: BoxFit.cover,
                          height: 220.h,
                          width: double.infinity,
                        ),
                      ),

                      20.height,

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
                              jobTitle: controller.getJobTitle(),
                              location: controller.getLocation(),
                              salary: controller.getSalary(),
                            ),

                            10.height,

                            // Job Info Tags
                            JobInfoTags(
                              isFullTime: controller.isFullTime(),
                              experience: controller.getExperience(),
                              postedDate: controller.getPostedDate(),
                              endDate: controller.getDeadline(),
                            ),

                            10.height,

                            // Job Dates
                            JobDetailsSectionHeader(
                              title:
                              'Posted ${controller.getPostedDate()}, end Date ${controller.getDeadline()}.',
                              color: AppColors.secondaryText,
                            ),
                            8.height,
                            const JobDetailsSectionHeader(
                              title: 'Your Profile Matches 90% with this Job',
                            ),

                            12.height,

                            CompanyInfoCard(
                              companyName: controller.getCompanyName(),
                              companyLogo: controller.getCompanyLogo().isNotEmpty
                                  ? controller.getCompanyLogo()
                                  : AppImages.companyLogo,
                              onTap: () {
                                Get.toNamed(JobSeekerRoutes.companyOverview);
                              },
                            ),

                            20.height,
                          ],
                        ),
                      ),

                      16.height,
                      CommonText(
                        text: 'Job Description',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        bottom: 10,
                      ).start,

                      DescriptionText(
                        text: controller.getDescription(),
                      ),

                      16.height,

                      if (controller.getRequiredSkills().isNotEmpty) ...[
                        CommonText(
                          text: 'Required Skills',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          bottom: 10,
                        ).start,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller
                              .getRequiredSkills()
                              .map((skill) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: CommonText(
                              text: skill,
                              fontSize: 12.sp,
                              color: AppColors.primary,
                            ),
                          ))
                              .toList(),
                        ),
                        16.height,
                      ],

                      CommonText(
                        text: 'Category: ${controller.getCategory()}',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryText,
                      ),

                      24.height,
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Apply Button
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(color: AppColors.surfaceBackground),
              child: SafeArea(
                top: false,
                child: CommonButton(
                  titleText: 'Apply Now',
                  buttonRadius: 8,
                  onTap: () {
                    // Handle apply action
                    showDialog(
                      context: context,
                      builder: (context) => JobApplyPopup(
                        postId: controller.jobId??"",
                        jobTitle: controller.getJobTitle(),
                        companyName: controller.getCompanyName(),
                        companyLogo: controller.getCompanyLogo().isNotEmpty
                            ? controller.getCompanyLogo()
                            : AppImages.jobDetails,
                        location: controller.getLocation(),
                        deadline: controller.getDeadline(),
                        isFullTime: controller.isFullTime(),
                        isRemote: false,
                        companyDescription: controller.getDescription(),
                        onApply: () {
                          SuccessDialog.showApplicationSuccess(
                            message:
                            'Your application has been Successful. We\'ll keep you updated.',
                          buttonText: 'Done',
                            onBackToHome: () => Get.back(),
                          );
                        },
                      ),
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
}