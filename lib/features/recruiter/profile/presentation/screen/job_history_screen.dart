import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/recruiter/home/presentation/widgets/recruiter_job_card.dart';
import 'package:embeyi/features/recruiter/job_post/presentation/controller/job_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecruiterJobPostController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(controller),
          /*Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: _buildJobsList(controller),
              ),
            ),
          ),*/
        ],
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
        'Job History',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTabBar(RecruiterJobPostController controller) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(
        () => Row(
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

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryPrimary : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? AppColors.secondaryPrimary
                : AppColors.borderColor,
            width: 1,
          ),
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

  /*Widget _buildJobsList(RecruiterJobPostController controller) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.currentJobs.length,
        itemBuilder: (context, index) {
          final job = controller.currentJobs[index];
          return RecruiterJobCard(
            jobTitle: job['title']!,
            location: job['location']!,
            isFullTime: job['isFullTime'] as bool,
            isRemote: job['isRemote'] as bool,
            candidateCount: job['candidateCount'] as int,
            deadline: job['deadline']!,
            thumbnailImage: job['thumbnail']!,
            onTap: () => controller.viewJobDetails(job['title']!),
          );
        },
      ),
    );
  }*/
}
