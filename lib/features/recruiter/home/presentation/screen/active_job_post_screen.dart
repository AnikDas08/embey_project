import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/text/common_text.dart';
import '../controller/active_job_post_controller.dart';
import '../widgets/recruiter_job_card.dart';

class ActiveJobPostScreen extends StatelessWidget {
  const ActiveJobPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If you already registered the controller in a binding, use Get.find.
    // Otherwise, keep Get.put(ActiveJobPostController()).
    final controller = Get.put(ActiveJobPostController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () => controller.getJobs(isInitial: true),
              child: Obx(() {
                // 1. Initial Loading State
                if (controller.isLoadingJob.value && controller.recentJobs.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Empty State (Wrapped in ListView so RefreshIndicator works)
                if (controller.recentJobs.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 200.h),
                      Center(child: CommonText(text: 'No active jobs found')),
                    ],
                  );
                }

                // 3. Main Scrollable List
                return ListView.builder(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.r),
                  itemCount: controller.recentJobs.length + 1, // +1 for footer
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
                      onTap: () {
                        Get.toNamed(RecruiterRoutes.jobCardDetails,
                            arguments: {"postId": job.id});
                      },
                    );
                  },
                );
              }),
            ),
          ),
          _buildCreateJobButton(controller),
        ],
      ),
    );
  }

  Widget _buildFooter(ActiveJobPostController controller) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: controller.isLoadingMore.value
            ? const CircularProgressIndicator()
            : (!controller.hasMoreData.value && controller.recentJobs.isNotEmpty)
            ? const Text("No more jobs to load", style: TextStyle(color: Colors.grey))
            : const SizedBox.shrink(),
      ),
    ));
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
        'Active Job Post',
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.black),
      ),
      centerTitle: true,
    );
  }

  Widget _buildCreateJobButton(ActiveJobPostController controller) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))
      ]),
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