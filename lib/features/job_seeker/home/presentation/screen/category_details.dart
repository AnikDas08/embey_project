import 'package:embeyi/core/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:embeyi/core/component/bottom_shit/filder_bottom_shit.dart';
import 'package:embeyi/core/component/card/job_card.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/features/job_seeker/home/presentation/controller/category_detailcontroller.dart';
import 'package:embeyi/features/job_seeker/home/presentation/widgets/auto_apply.dart';
import 'package:embeyi/features/job_seeker/home/presentation/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoryDetails extends StatelessWidget {
  CategoryDetails({super.key});
  final controller = Get.put(CategoryDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design')),
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoadingJobs.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Show empty state
        if (controller.jobPost == null || controller.jobPost!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off, size: 64.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No jobs available',
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Show job list
        return SingleChildScrollView(
          child: GetBuilder<CategoryDetailController>(
            init: CategoryDetailController(),
            builder: (controller) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: HomeSearchBar(
                    onFilterTap: () {
                      Get.bottomSheet(
                        isScrollControlled: true,
                        FilterBottomSheet(
                          onApply: () {
                            // Handle apply tap
                          },
                          onClose: () {
                            // Handle close tap
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    onChanged: (value) {
                      // Handle search
                      //controller.searchJobs(value);
                    },
                  ),
                ),
                SizedBox(height: 20.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.jobPost!.length,
                    itemBuilder: (context, index) {
                      final jobPost = controller.jobPost![index];

                      // Calculate salary range safely
                      final minSalary = jobPost.minSalary ?? 0;
                      final maxSalary = jobPost.maxSalary ?? 0;
                      final salaryRange = '\$$minSalary - \$$maxSalary/month';

                      // Get location safely
                      final location = jobPost.location ?? 'Location not specified';

                      // Get job and recruiter titles safely
                      final jobTitle = jobPost.title ?? 'No Title Specified';
                      final companyName = jobPost.recruiter ?? 'Company N/A';

                      // Format deadline date
                      String timePosted = '01 Dec 25';
                      if (jobPost.deadline != null) {
                        try {
                          final deadline = jobPost.deadline!;
                          timePosted = '${deadline.day.toString().padLeft(2, '0')} ${_getMonthName(deadline.month)} ${deadline.year.toString().substring(2)}';
                        } catch (e) {
                          print("Error formatting date: $e");
                        }
                      }

                      // Determine job properties safely
                      final jobType = jobPost.jobType?.toUpperCase();
                      final isFullTime = jobType == 'FULL_TIME';
                      final isRemote = jobType == 'REMOTE';

                      // Get company logo with base URL
                      final thumbnail = jobPost.thumbnail ?? '';
                      final companyLogo = thumbnail.isNotEmpty
                          ? 'https://shariful5001.binarybards.online$thumbnail'
                          : 'assets/images/noImage.png';

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
                          isFavorite: jobPost.isFavourite,
                          isApplied: jobPost.isApplied!,
                          onTap: () {
                            if (jobPost.id != null && jobPost.id!.isNotEmpty) {
                              print("Job tapped: ${jobPost.id}");
                              Get.toNamed(JobSeekerRoutes.jobDetails, arguments: jobPost.id);
                            }
                          },
                          onFavoriteTap: () {
                            final jobId = jobPost.id;
                            controller.toggleFavorite(jobId!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
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