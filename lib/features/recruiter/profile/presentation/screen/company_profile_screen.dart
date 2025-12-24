import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/recruiter/profile/presentation/screen/edit_company_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/config/route/recruiter_routes.dart';
import '../../../../job_seeker/jobs/presentation/widgets/company_overview_widgets.dart';
import '../../../home/presentation/widgets/recruiter_job_card.dart';
import '../controller/company_profile_controller.dart';
import '../widgets/company_overview_widgets.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompanyProfileController());

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: CommonAppbar(title: 'Company Overview'),
      body: Obx(() {
        // Show loading indicator while profile is loading
        if (controller.isLoadingProfile.value &&
            controller.companyName.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Header with Company Image and Logo
                  Obx(
                    () => CompanyHeroHeader(
                      companyImage: controller.companyLogo.value.isNotEmpty
                          ? (controller.companyLogo.value.startsWith('http')
                                ? controller.companyLogo.value
                                : ApiEndPoint.imageUrl +
                                      controller.companyLogo.value)
                          : '',
                      companyLogo: controller.companyImage.value.isNotEmpty
                          ? (controller.companyImage.value.startsWith('http')
                                ? controller.companyImage.value
                                : ApiEndPoint.imageUrl +
                                      controller.companyImage.value)
                          : '',
                    ),
                  ),

                  // Company Name and Tagline
                  Obx(
                    () => Center(
                      child: CompanyNameSection(
                        companyName: controller.companyName.value,
                        tagline: controller.companyBio.value,
                      ),
                    ),
                  ),

                  20.height,

                  // Tab Navigation
                  Obx(
                    () => CompanyTabNavigation(
                      selectedIndex: controller.selectedTabIndex.value,
                      onTabSelected: controller.onTabSelected,
                    ),
                  ),

                  24.height,

                  // Tab Content
                  Obx(() => _buildTabContent(controller)),

                  24.height,
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTabContent(CompanyProfileController controller) {
    switch (controller.selectedTabIndex.value) {
      case 0: // Home Tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CompanySectionTitle(title: 'Gallery'),
            12.height,
            Obx(() {
              if (controller.isLoadingImage.value &&
                  controller.galleryImages.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.galleryImages.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20,
                  ),
                  child: Center(
                    child: Text(
                      'No gallery images available',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }

              return CompanyGalleryGrid(
                images: controller.galleryImages,
                crossAxisCount: 4,
              );
            }),
            24.height,

            Padding(
              padding: const EdgeInsets.all(20),
              child: CommonButton(
                titleText: 'Edit Profile',
                onTap: () {
                  Get.to(() => const EditCompanyProfileScreen());
                },
              ),
            ),
          ],
        );

      case 1: // About Tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About Us Section
            if (controller.aboutUs.value.isNotEmpty) ...[
              const CompanySectionTitle(title: 'About Us'),
              12.height,
              CompanyAboutContent(aboutText: controller.aboutUs.value),
              24.height,
            ],

            // Mission Section
            if (controller.mission.value.isNotEmpty) ...[
              const CompanySectionTitle(title: 'Mission'),
              12.height,
              CompanyAboutContent(aboutText: controller.mission.value),
              24.height,
            ],

            // Company Details
            if (controller.totalEmployees.value > 0 ||
                controller.companyType.value.isNotEmpty ||
                controller.founded.value > 0 ||
                controller.revenue.value.isNotEmpty) ...[
              const CompanySectionTitle(title: 'Company Details'),
              12.height,
              CompanyDetailsSection(
                totalEmployees: controller.totalEmployees.value,
                companyType: controller.companyType.value,
                founded: controller.founded.value,
                revenue: controller.revenue.value,
              ),
              24.height,
            ],

            // Contact Information
            if (controller.website.value.isNotEmpty ||
                controller.address.value.isNotEmpty ||
                controller.contact.value.isNotEmpty ||
                controller.email.value.isNotEmpty) ...[
              const CompanySectionTitle(title: 'Contact Information'),
              12.height,
              CompanyContactSection(
                website: controller.website.value,
                address: controller.address.value,
                contact: controller.contact.value,
                email: controller.email.value,
              ),
            ],
          ],
        );

      case 2: // Jobs Tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.height,

            //CompanyJobsList(jobs: controller.companyJobs),
            //ProfileJobHistoryScreen(controller: controller)
            _buildTabBar(controller),

            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: _buildJobsList(controller),
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
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
                isSelected: controller.selectedTabIndexJobs.value == 0,
                onTap: () => controller.selectTab(0),
              ),
            ),
            12.width,
            Expanded(
              child: _buildTabButton(
                label: 'Closed Jobs',
                isSelected: controller.selectedTabIndexJobs.value == 1,
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
    return Obx(() {
      if (controller.isLoadingJob.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: CircularProgressIndicator(color: AppColors.primaryColor),
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
            userImages: job.userImages,
            // Pass the list here
            onTap: () {
              Get.toNamed(
                RecruiterRoutes.jobCardDetails,
                arguments: {"postId": job.id},
              );
            },
          );
        },
      );
    });
  }
}
