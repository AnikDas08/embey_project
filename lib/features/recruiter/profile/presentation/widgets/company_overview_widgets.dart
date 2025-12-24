import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/recruiter/profile/presentation/controller/company_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/config/route/recruiter_routes.dart';
import '../../../home/presentation/widgets/recruiter_job_card.dart';
import '../controller/job_history_controller.dart';

// Overview Summary Stats Widget
class CompanyOverviewStats extends StatelessWidget {
  final int activePosts;
  final int pendingRequest;
  final int shortlistRequest;
  final int interviewRequest;

  const CompanyOverviewStats({
    super.key,
    required this.activePosts,
    required this.pendingRequest,
    required this.shortlistRequest,
    required this.interviewRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Active Posts',
                    activePosts.toString(),
                    AppColors.primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: const Color(0xFFE0E0E0),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Pending',
                    pendingRequest.toString(),
                    Colors.orange,
                  ),
                ),
              ],
            ),
            12.height,
            Divider(color: const Color(0xFFE0E0E0), height: 1),
            12.height,
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Shortlisted',
                    shortlistRequest.toString(),
                    Colors.green,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: const Color(0xFFE0E0E0),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Interviews',
                    interviewRequest.toString(),
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        CommonText(
          text: value,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
        4.height,
        CommonText(
          text: label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
        ),
      ],
    );
  }
}

// Company Details Section Widget
class CompanyDetailsSection extends StatelessWidget {
  final int totalEmployees;
  final String companyType;
  final int founded;
  final String revenue;

  const CompanyDetailsSection({
    super.key,
    required this.totalEmployees,
    required this.companyType,
    required this.founded,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          children: [
            if (totalEmployees > 0)
              _buildDetailRow('Total Employees', totalEmployees.toString()),
            if (companyType.isNotEmpty) ...[
              12.height,
              _buildDetailRow('Company Type', companyType),
            ],
            if (founded > 0) ...[
              12.height,
              _buildDetailRow('Founded', founded.toString()),
            ],
            if (revenue.isNotEmpty) ...[
              12.height,
              _buildDetailRow('Revenue', '\$$revenue'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.secondaryText,
        ),
        Expanded(
          child: CommonText(
            text: value,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// Company Contact Section Widget
class CompanyContactSection extends StatelessWidget {
  final String website;
  final String address;
  final String contact;
  final String email;

  const CompanyContactSection({
    super.key,
    required this.website,
    required this.address,
    required this.contact,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (website.isNotEmpty)
              _buildContactItem(
                Icons.language,
                'Website',
                website,
                AppColors.primary,
              ),
            if (address.isNotEmpty) ...[
              12.height,
              _buildContactItem(
                Icons.location_on_outlined,
                'Address',
                address,
                Colors.red,
              ),
            ],
            if (contact.isNotEmpty) ...[
              12.height,
              _buildContactItem(
                Icons.phone_outlined,
                'Contact',
                contact,
                Colors.green,
              ),
            ],
            if (email.isNotEmpty) ...[
              12.height,
              _buildContactItem(
                Icons.email_outlined,
                'Email',
                email,
                Colors.blue,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: iconColor,
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: label,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
              4.height,
              CommonText(
                text: value,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryText,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Empty State Widget
class CompanyEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const CompanyEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.r),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.sp,
              color: AppColors.secondaryText.withOpacity(0.5),
            ),
            16.height,
            CommonText(
              text: message,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileJobHistoryScreen extends StatelessWidget {
  final CompanyProfileController controller;
  const ProfileJobHistoryScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          _buildTabBar(controller),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: _buildJobsList(controller),
              ),
            ),
          ),
        ],
      );
  }

  Widget _buildTabBar(CompanyProfileController controller) {
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

  Widget _buildJobsList(CompanyProfileController controller) {
    return Obx(
          () {
        if (controller.isLoadingJob.value) {
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

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recentJobs.length,
          itemBuilder: (context, index) {
            final job = controller.recentJobs[index];
            return RecruiterJobCard(
              jobTitle: job.title,
              location: job.location,
              isFullTime: job.isFullTime,
              isRemote: job.isRemote,
              candidateCount: job.totalApplications,
              deadline: job.formattedDeadline,
              thumbnailImage: job.thumbnail,
              userImages: job.userImages, // Pass the list here
              onTap: () {
                Get.toNamed(RecruiterRoutes.jobCardDetails, arguments: {
                  "postId": job.id,
                });
              },
            );
          },
        );
      },
    );
  }
}