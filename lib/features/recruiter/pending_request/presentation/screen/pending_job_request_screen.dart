import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../controller/pending_job_request_controller.dart';
import '../../../home/presentation/widgets/candidate_card.dart';

class PendingJobRequestScreen extends StatelessWidget {
  const PendingJobRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PendingJobRequestController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(controller),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostDropdown(controller),
              16.height,
              _buildCandidatesList(controller),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(PendingJobRequestController controller) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
        onPressed: () => Get.back(),
      ),
      title: Obx(
            () => Text(
          'Request (${controller.totalRequestCount})',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildPostDropdown(PendingJobRequestController controller) {
    return Obx(
          () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderColor, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedPostId.value,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.black,
              size: 20.sp,
            ),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            items: [
              // "All Posts" option
              DropdownMenuItem<String>(
                value: 'all',
                child: Text(
                  'All Posts',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              // Individual post options using unique IDs
              ...controller.posts.map((post) {
                return DropdownMenuItem<String>(
                  value: post['id'] as String,
                  child: Text(
                    post['title'] as String,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.selectPost(newValue);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCandidatesList(PendingJobRequestController controller) {
    return Obx(() {
      // Show loading indicator while fetching applications
      if (controller.isLoadingApplications.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.r),
            child: const CircularProgressIndicator(),
          ),
        );
      }

      // Show empty state if no applications after filtering
      if (controller.filteredApplications.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.r),
            child: Text(
              'No pending requests found',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.black.withOpacity(0.5),
              ),
            ),
          ),
        );
      }

      // Display filtered list of applications
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.filteredApplications.length,
        itemBuilder: (context, index) {
          final application = controller.filteredApplications[index];

          // Map API data to CandidateCard
          return CandidateCard(
            name: application.user.name,
            jobTitle: application.title,
            experience: application.experienceYears,
            description: application.user.bio,
            matchPercentage: application.jobMatch,
            profileImage: ApiEndPoint.imageUrl + application.user.image,
            onTap: () => controller.viewCandidateProfile(application.id),
          );
        },
      );
    });
  }
}