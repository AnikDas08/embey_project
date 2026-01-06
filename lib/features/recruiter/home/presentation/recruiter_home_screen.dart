import 'package:embeyi/core/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/app_routes.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'controller/home_controller.dart';
import 'widgets/stat_card.dart';
import 'widgets/recruiter_job_card.dart';

class RecruiterHomeScreen extends StatelessWidget {
  RecruiterHomeScreen({super.key});
  final RecruiterHomeController controller = Get.put(RecruiterHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async {
                  await controller.refreshData();
                },
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.height,
                      _buildStatsGrid(),
                      24.height,
                      _buildRecentJobsSection(),
                      16.height,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(
        child: CommonBottomNavBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Logo
          Obx(() {
            return ClipOval(
              child: controller.companyImage.value.isNotEmpty
                  ? CommonImage(
                  imageSrc: ApiEndPoint.imageUrl + controller.companyImage.value,
                  size: 64.sp)
                  : CommonImage(imageSrc: AppImages.logo, size: 64.sp),
            );
          }),
          8.width,
          // Company Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => CommonText(
                  text: controller.companyName.value,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                )),
                2.height,
                Row(
                  children: [
                    CommonImage(imageSrc: AppIcons.location, size: 12.sp),
                    4.width,
                    Obx(() => CommonText(
                      text: controller.companyAddress.value==""||controller.companyAddress.value.isEmpty?"Not added location":controller.companyAddress.value,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryText,
                    )),
                  ],
                ),
              ],
            ),
          ),
          // Action Icons
          _buildActionIcon(
            AppIcons.chat,
            onTap: () {
              RecruiterRoutes.goToChat();
            },
          ),
          8.width,
          Obx(
                () => _buildActionIcon(
              AppIcons.notification,
              hasNotification: controller.notificationCounts.value > 0,
              badgeCount: controller.notificationCounts.value,
              onTap: () {
                RecruiterRoutes.goToNotifications();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(
      String imageSrc, {
        bool hasNotification = false,
        int? badgeCount,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CommonImage(imageSrc: imageSrc, size: 24.sp),
          if (hasNotification && badgeCount != null && badgeCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: badgeCount > 99 ? 3.w : 4.w,
                  vertical: badgeCount > 99 ? 1.h : 2.h,
                ),
                constraints: BoxConstraints(
                  minWidth: 14.w,
                  minHeight: 14.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryPrimary,
                  shape: badgeCount > 99 ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: badgeCount > 99 ? BorderRadius.circular(8.r) : null,
                  border: Border.all(color: Colors.white, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: badgeCount > 99 ? 7.sp : 8.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Obx(() {
      final summary = controller.profileData.value?.overviewSummary;

      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.6,
        children: [
          StatCard(
            count: (controller.activeJobs.value).toString().padLeft(2, '0'),
            label: 'Active Jobs',
            backgroundColor: AppColors.primaryColor,
            onTap: () {
              AppRoutes.goToActiveJobPost();
            },
          ),
          StatCard(
            count: (controller.pendingJobs.value ??0).toString().padLeft(2, '0'),
            label: 'Pending Request',
            backgroundColor: const Color(0xFF3AAFB9),
            onTap: () {
              AppRoutes.goToPendingJobRequest();
            },
          ),
          StatCard(
            count: (controller.shortListsJobs).toString().padLeft(2, '0'),
            label: 'Short Listed',
            backgroundColor: const Color(0xFF008F37),
            onTap: () {
              AppRoutes.goToShortJobListed();
            },
          ),
          StatCard(
            count: (controller.interviewJobs.value).toString().padLeft(2, '0'),
            label: 'Interview',
            backgroundColor: AppColors.secondaryPrimary,
            onTap: () {
              AppRoutes.goToInterviewJob();
            },
          ),
        ],
      );
    });
  }

  Widget _buildRecentJobsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: 'Recent Job Post',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    RecruiterRoutes.goToAllJobPost();
                  },
                  child: CommonText(
                    text: 'See All',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                4.width,
                Icon(
                  Icons.arrow_forward,
                  size: 16.sp,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ],
        ),
        16.height,
        _buildJobsList(),
      ],
    );
  }

  Widget _buildJobsList() {
    return Obx(
          () {
        if (controller.isLoadingJobs.value) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          );
        }

        if (controller.recentJobs.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: CommonText(
                text: 'No recent jobs found',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryText,
              ),
            ),
          );
        }

        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentJobs.length,
              itemBuilder: (context, index) {
                final job = controller.recentJobs[index];
                final thumbnailImage = job.thumbnail.startsWith("http")
                    ? job.thumbnail
                    : ApiEndPoint.imageUrl + job.thumbnail;
                return RecruiterJobCard(
                  jobTitle: job.title,
                  location: job.location,
                  isFullTime: job.isFullTime,
                  isRemote: job.isRemote,
                  candidateCount: job.totalApplications,
                  deadline: job.formattedDeadline,
                  thumbnailImage: job.thumbnail,
                  userImages: job.userImages,
                  onTap: () {
                    Get.toNamed(RecruiterRoutes.jobCardDetails, arguments: {
                      "postId": job.id,
                    });
                  },
                );
              },
            ),
            // Loading more indicator
            if (controller.isLoadingMore.value)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            // End of list indicator
            if (!controller.hasMoreData.value && controller.recentJobs.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: CommonText(
                    text: 'No more jobs to load',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}