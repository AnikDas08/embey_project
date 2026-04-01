import 'package:embeyi/core/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/recruiter/home/presentation/widgets/recruiter_job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/config/route/recruiter_routes.dart';
import 'controller/job_post_controller.dart';

class JobPostScreen extends StatelessWidget {
  const JobPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecruiterJobPostController());

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(RecruiterRoutes.home);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTabBar(controller),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: controller.refreshData,
                child: _buildJobsList(controller),
              ),
            ),
            _buildCreateJobButton(controller),
          ],
        ),
        bottomNavigationBar: const SafeArea(
          child: CommonBottomNavBar(currentIndex: 2),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'All Job Posts',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: AppColors.black),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTabBar(RecruiterJobPostController controller) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: _buildTabButton(
              label: 'Active Jobs',
              isSelected: controller.selectedTabIndex.value == 0,
              onTap: () => controller.selectTab(0),
            ),
          ),
          12.width,
          Expanded(
            child: _buildTabButton(
              label: 'Closed Jobs',
              isSelected: controller.selectedTabIndex.value == 1,
              onTap: () => controller.selectTab(1),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildTabButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryPrimary : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? AppColors.secondaryPrimary : AppColors.borderColor),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.secondaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildJobsList(RecruiterJobPostController controller) {
    return Obx(() {
      if (controller.isLoadingJob.value && controller.recentJobs.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.recentJobs.isEmpty) {
        return ListView( // Needs to be a ListView so RefreshIndicator works
          children: [
            SizedBox(height: 100.h),
            Center(
              child: CommonText(
                text: 'No recent jobs found',
                fontSize: 14.sp,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.all(16.r),
        physics: const AlwaysScrollableScrollPhysics(),
        // Count + 1 to account for the footer (loader or "no more" text)
        itemCount: controller.recentJobs.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.recentJobs.length) {
            return _buildListFooter(controller);
          }

          final job = controller.recentJobs[index];
          return RecruiterJobCard(
            jobTitle: job.title,
            location: job.location,
            isFullTime: job.isFullTime,
            isRemote: job.isRemote,
            candidateCount: job.totalApplications,
            deadline: job.formattedDeadline,
            thumbnailImage: job.thumbnail,
            userImages: job.userImages,
            onTap: () => controller.viewJobDetails(job.id.toString()),
          );
        },
      );
    });
  }

  Widget _buildListFooter(RecruiterJobPostController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: controller.isLoadingMore.value
            ? CircularProgressIndicator(color: AppColors.primaryColor)
            : !controller.hasMoreData.value
            ? CommonText(text: 'No more jobs to load', fontSize: 12.sp, color: AppColors.secondaryText)
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCreateJobButton(RecruiterJobPostController controller) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: CommonButton(
          titleText: 'Create New Job Post',
          buttonHeight: 50.h,
          onTap: controller.createNewJobPost,
        ),
      ),
    );
  }
}