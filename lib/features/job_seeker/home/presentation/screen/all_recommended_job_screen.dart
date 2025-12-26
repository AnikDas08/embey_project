import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:embeyi/core/component/card/job_card.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/features/job_seeker/home/presentation/controller/recomended_jod_controller.dart';
import 'package:embeyi/features/job_seeker/home/presentation/widgets/auto_apply.dart';

import '../../../../../core/config/api/api_end_point.dart';

class AllRecommendedJobScreen extends StatelessWidget {
  AllRecommendedJobScreen({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecomendedJodController());

    // Setup infinite scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // Load more when user is 200px from bottom
        controller.loadMoreJobs();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: 'Recommended Jobs',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // Check for initial loading state
          if (controller.isLoadingJobs.value && controller.jobPost.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if job list is empty
          if (controller.jobPost.isEmpty) {
            return Center(
              child: CommonText(
                text: 'No recommended jobs found.',
                fontSize: 16.sp,
                color: AppColors.secondaryText,
              ),
            );
          }

          // Main content with jobs and pagination
          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: controller.jobPost.length + 1, // +1 for auto-apply and loading indicator
            itemBuilder: (context, index) {
              // Auto Apply Widget at the top
              if (index == 0) {
                return Column(
                  children: [
                    AutoApply(
                      isEnabled: controller.autoApplHere.value,
                      onToggle: (newValue) {
                        controller.toggleAutoApply(newValue);
                      },
                    ),
                    SizedBox(height: 8.h),
                  ],
                );
              }

              // Loading indicator or "no more" message at the end
              if (index == controller.jobPost.length) {
                if (controller.isLoadingMore.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // Show "No more jobs" message if at the end
                if (!controller.hasMorePages.value && controller.jobPost.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: Text(
                        'No more jobs to load',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(height: 20.h);
              }

              // Job Card
              final jobPost = controller.jobPost[index - 1]; // -1 because of auto-apply at index 0

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
                companyLogo = 'assets/images/noImage.png';
              } else if (thumbnail.startsWith('http')) {
                companyLogo = thumbnail;
              } else {
                companyLogo = ApiEndPoint.imageUrl + thumbnail;
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
                  isSaved: jobPost.isFavourite ?? false,
                  isRemote: isRemote,
                  onTap: () {
                    if (jobPost.id != null && jobPost.id!.isNotEmpty) {
                      Get.toNamed(
                        JobSeekerRoutes.jobDetails,
                        arguments: jobPost.id,
                      );
                    }
                  },
                  onFavoriteTap: () {
                    final jobId = jobPost.id;
                    if (jobId != null && jobId.isNotEmpty) {
                      controller.toggleFavorite(jobId);
                    }
                  },
                ),
              );
            },
          );
        }),
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