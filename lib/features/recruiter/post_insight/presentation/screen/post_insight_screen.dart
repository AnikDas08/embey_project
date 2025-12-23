import 'package:embeyi/core/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/post_insight_controller.dart';
import '../widgets/insight_stat_card.dart';
import '../widgets/recent_applicant_card.dart';

class PostInsightScreen extends StatelessWidget {
  const PostInsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostInsightController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && controller.jobTitlesList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.jobTitlesList.isEmpty) {
          return const Center(child: Text('No posts available'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdowns(controller),
                16.height,
                _buildStatsGrid(controller),
                24.height,
                _buildRecentApplicants(controller),
                24.height,
                _buildRecentQualified(controller),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: const SafeArea(
        child: CommonBottomNavBar(currentIndex: 1),
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
        'Post Insights',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildDropdowns(PostInsightController controller) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.postIds.isEmpty) {
              return const SizedBox();
            }

            return _buildDropdown(
              value: controller.selectedPostId.value,
              items: controller.postIds,
              displayNames: controller.postIds.map((id) => controller.getTitleForId(id)).toList(),
              onChanged: controller.selectPostId,
            );
          }),
        ),
        12.width,
        Expanded(
          child: Obx(
                () => _buildDropdown(
              value: controller.selectedTimePeriod.value,
              items: controller.timePeriods,
              displayNames: controller.timePeriods,
              onChanged: controller.selectTimePeriod,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required List<String> displayNames,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.black,
            size: 20.sp,
          ),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          items: List.generate(items.length, (index) {
            return DropdownMenuItem<String>(
              value: items[index],
              child: Text(displayNames[index]),
            );
          }),
          onChanged: (String? newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ),
    );
  }

  Widget _buildStatsGrid(PostInsightController controller) {
    return Obx(
          () => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.6,
        children: [
          InsightStatCard(
            label: 'Application',
            value: controller.applicationCount.value.toString(),
            valueColor: AppColors.secondaryPrimary,
          ),
          InsightStatCard(
            label: 'Qualified',
            value: controller.qualifiedCount.value.toString(),
            valueColor: const Color(0xFF008F37),
          ),
          InsightStatCard(
            label: 'Engagement',
            value: controller.engagementRate.value,
            valueColor: const Color(0xFF2196F3),
          ),
          InsightStatCard(
            label: 'Reject',
            value: controller.rejectCount.value.toString(),
            valueColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentApplicants(PostInsightController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Applicant',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        12.height,
        Obx(
              () {
            if (controller.recentApplicants.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: Text(
                    'No recent applicants',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentApplicants.length,
              itemBuilder: (context, index) {
                final applicant = controller.recentApplicants[index];
                return RecentApplicantCard(
                  name: applicant['name'],
                  jobTitle: applicant['jobTitle'],
                  matchPercentage: applicant['matchPercentage'],
                  profileImage: ApiEndPoint.imageUrl+applicant['profileImage'],
                  onTap: () => controller.viewApplicantProfile(applicant['id']),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentQualified(PostInsightController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Qualified',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        12.height,
        Obx(
              () {
            if (controller.recentQualified.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: Text(
                    'No qualified applicants yet',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentQualified.length,
              itemBuilder: (context, index) {
                final qualified = controller.recentQualified[index];
                return RecentApplicantCard(
                  name: qualified['name'],
                  jobTitle: qualified['jobTitle'],
                  matchPercentage: qualified['matchPercentage'],
                  profileImage: ApiEndPoint.imageUrl+qualified['profileImage'],
                  onTap: () => controller.viewApplicantProfile(qualified['id']),
                );
              },
            );
          },
        ),
      ],
    );
  }
}