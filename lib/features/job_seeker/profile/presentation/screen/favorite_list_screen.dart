import 'package:embeyi/core/component/card/job_card.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/text/common_text.dart';
import '../controller/favourite_controller.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouriteController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: const CommonText(
          text: 'Favorite List',
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        actions: [
          // Refresh button
          Obx(() {
            return IconButton(
              icon: controller.isLoading.value
                  ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
                  : Icon(Icons.refresh, color: AppColors.black, size: 24.sp),
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.refreshFavourites(),
            );
          }),
        ],
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value && controller.favouriteList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        // Empty state
        if (controller.favouriteList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  size: 80.sp,
                  color: AppColors.red,
                ),
                SizedBox(height: 16.h),
                CommonText(
                  text: 'No Favorites Yet',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: CommonText(
                    text: 'Jobs you favorite will appear here',
                    fontSize: 14.sp,
                    color: AppColors.secondaryText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }

        // List with data
        return RefreshIndicator(
          onRefresh: () => controller.refreshFavourites(),
          color: AppColors.primary,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            itemCount: controller.favouriteList.length,
            itemBuilder: (context, index) {
              final favourite = controller.favouriteList[index];
              final job = favourite.post;
              final thumbnail = job.thumbnail ?? '';
              final companyLogo = thumbnail.isNotEmpty
                  ? 'https://shariful5001.binarybards.online$thumbnail'
                  : 'assets/images/noImage.png';

              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: JobCard(
                  companyName: job.title,
                  location: job.location,
                  jobTitle: job.title,
                  salaryRange: job.salaryRange,
                  timePosted: job.formattedDeadline,
                  isFullTime: job.jobType == 'FULL_TIME',
                  isSaved: true,
                  companyLogo: companyLogo,
                  isFavorite: true,
                  onTap: () {
                    if (job.id != null && job.id!.isNotEmpty) {
                      print("Job tapped: ${job.id}");
                      Get.toNamed(JobSeekerRoutes.jobDetails, arguments: job.id);
                    }
                  },
                  onFavoriteTap: () {
                    // Show confirmation dialog
                    final jobId = job.id;
                    if (jobId != null && jobId.isNotEmpty) {
                      controller.toggleFavorite(jobId);
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  /// Show remove confirmation dialog
  void _showRemoveDialog(
      BuildContext context,
      FavouriteController controller,
      String favouriteId,
      int index,
      String jobTitle,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: CommonText(
            text: 'Remove Favorite',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          content: CommonText(
            text: 'Are you sure you want to remove "$jobTitle" from your favorites?',
            fontSize: 14.sp,
            color: AppColors.secondaryText,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: CommonText(
                text: 'Cancel',
                fontSize: 14.sp,
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                controller.removeFavourite(favouriteId, index);
              },
              child: CommonText(
                text: 'Remove',
                fontSize: 14.sp,
                color: AppColors.error ?? Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}