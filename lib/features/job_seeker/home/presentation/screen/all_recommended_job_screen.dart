import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:embeyi/core/component/card/job_card.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart'; // Assuming you need this
// import 'package:embeyi/core/utils/constants/app_images.dart'; // Usually not needed here
import 'package:embeyi/features/job_seeker/home/presentation/controller/recomended_jod_controller.dart';
import 'package:embeyi/features/job_seeker/home/presentation/widgets/auto_apply.dart';

import '../../../../../core/config/api/api_end_point.dart';


class AllRecommendedJobScreen extends StatelessWidget {
  const AllRecommendedJobScreen({super.key});

  // Get the controller instance. Using Get.find() is often better in StatelessWidget
  // if Get.put() was done on the previous screen, but Get.put() here is acceptable.
  RecomendedJodController get controller => Get.put(RecomendedJodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: 'Recommended Jobs',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        // Use a GetBuilder/Obx to react to changes in jobPost data
        child: GetBuilder<RecomendedJodController>(
          init: controller, // Initialize if not already done
          builder: (ctrl) {
            // Check for loading state first
            if (ctrl.isLoadingJobs.isTrue) {
              return Center(child: const CircularProgressIndicator());
            }

            // Check if job list is null or empty
            if (ctrl.jobPost == null || ctrl.jobPost!.isEmpty) {
              return Center(
                child: CommonText(
                  text: 'No recommended jobs found.',
                  fontSize: 16.sp,
                  color: AppColors.secondaryText, // Assuming you have AppColors
                ),
              );
            }

            // Correct Structure: SingleChildScrollView -> Column -> AutoApply + Single ListView
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // This widget stays
                  AutoApply(),

                  // Use the one and only ListView.builder for the job list
                  ListView.builder(
                    // You must remove the outer padding, as it's now on the SingleChildScrollView
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Ensures scrolling is handled by SingleChildScrollView
                    itemCount: ctrl.jobPost!.length,
                    itemBuilder: (context, index) {
                      final jobPost = ctrl.jobPost![index];

                      // --- Data Extraction remains the same (safely handles nulls) ---
                      final minSalary = jobPost.minSalary ?? 0;
                      final maxSalary = jobPost.maxSalary ?? 0;
                      final salaryRange = '\$$minSalary - \$$maxSalary/month';
                      final location = jobPost.location ?? 'Location not specified';
                      final jobTitle = jobPost.title ?? 'No Title Specified';
                      final companyName = jobPost.recruiter ?? 'Company N/A';

                      String timePosted = '01 Dec 25';
                      if (jobPost.deadline != null) {
                        try {
                          final deadline = jobPost.deadline!;
                          timePosted = '${deadline.day.toString().padLeft(2, '0')} ${_getMonthName(deadline.month)} ${deadline.year.toString().substring(2)}';
                        } catch (e) {
                          // Handle date formatting error
                        }
                      }

                      final jobType = jobPost.jobType?.toUpperCase();
                      final isFullTime = jobType == 'FULL_TIME';
                      final isRemote = jobType == 'REMOTE';

                      final thumbnail = jobPost.thumbnail ?? '';
                      String companyLogo;

                      if (thumbnail.isEmpty) {
                        companyLogo = 'assets/images/noImage.png'; // Fallback for empty
                      } else if (thumbnail.startsWith('http')) {
                        companyLogo = thumbnail; // Use direct URL
                      } else {
                        companyLogo = ApiEndPoint.imageUrl + thumbnail; // Prepend base URL for local paths
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: JobCard(
                          companyName: companyName,
                          location: location,
                          jobTitle: jobTitle,
                          salaryRange: salaryRange,
                          timePosted: timePosted,
                          isFullTime: isFullTime,
                          companyLogo: companyLogo,
                          showFavoriteButton: true,
                          isSaved: false,
                          isRemote: isRemote,
                          onTap: () {
                            if (jobPost.id != null && jobPost.id!.isNotEmpty) {
                              //JobSeekerRoutes.goToJobDetails(jobId: jobPost.id!);
                            }
                          },
                          onFavoriteTap: () {
                            final jobId = jobPost.id;
                            if (jobId != null && jobId.isNotEmpty) {
                              // Ensure this method exists and is correctly implemented in RecomendedJodController
                              // ctrl.toggleFavorite(jobId);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return month >= 1 && month <= 12 ? months[month] : 'Jan';
  }
}