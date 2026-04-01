import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/recruiter/home/presentation/widgets/recruiter_job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/config/route/recruiter_routes.dart';
import '../controller/all_job_post_controller.dart';

class AllJobPostScreen extends StatelessWidget {
  const AllJobPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllJobPostController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(controller),
          Expanded(
            child: Obx(() => RefreshIndicator(
              onRefresh: () => controller.refreshData(),
              color: AppColors.primaryColor,
              // If loading first time, show a scrollable spinner
              child: (controller.isLoadingJobs.value && controller.recentJobs.isEmpty)
                  ? _buildLoadingState()
                  : _buildMainList(controller),
            )),
          ),
          _buildCreateJobButton(controller),
        ],
      ),
    );
  }

  Widget _buildMainList(AllJobPostController controller) {
    if (controller.recentJobs.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 200.h),
          const Center(child: Text("No jobs found")),
        ],
      );
    }

    return ListView.builder(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.r),
      itemCount: controller.recentJobs.length + 1,
      itemBuilder: (context, index) {
        if (index == controller.recentJobs.length) {
          return _buildFooter(controller);
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
          onTap: () => Get.toNamed(RecruiterRoutes.jobCardDetails, arguments: {"postId": job.id}),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 200.h),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildFooter(AllJobPostController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: controller.isLoadingMore.value
            ? const CircularProgressIndicator()
            : !controller.hasMoreData.value && controller.recentJobs.isNotEmpty
            ? const Text("No more jobs to load")
            : const SizedBox.shrink(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text('All Job Posts', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.black)),
      centerTitle: true,
    );
  }

  Widget _buildTabBar(AllJobPostController controller) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(() => Row(
        children: [
          Expanded(child: _buildTabButton(label: 'Active Jobs', isSelected: controller.selectedTabIndex.value == 0, onTap: () => controller.selectTab(0))),
          12.width,
          Expanded(child: _buildTabButton(label: 'Closed Jobs', isSelected: controller.selectedTabIndex.value == 1, onTap: () => controller.selectTab(1))),
        ],
      )),
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
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.secondaryText)),
      ),
    );
  }

  Widget _buildCreateJobButton(AllJobPostController controller) {
    return Container(
      padding: EdgeInsets.all(16.r),
      color: Colors.white,
      child: SafeArea(child: CommonButton(titleText: 'Create New Job Post', buttonHeight: 50.h, onTap: controller.createNewJobPost)),
    );
  }
}