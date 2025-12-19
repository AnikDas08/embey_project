import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/recruiter/job_post/presentation/screen/repost_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/job_card_details_controller.dart';
import '../widgets/candidate_card.dart';
import '../widgets/filter_chip_button.dart';
import '../widgets/job_detail_header_card.dart';

class JobCardDetailsScreen extends StatelessWidget {
  const JobCardDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    JobCardDetailsController controller = Get.put(JobCardDetailsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildJobDetailHeader(controller, context),
                16.height,
                _buildFilterChips(controller),
                16.height,
                _buildCandidatesList(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(JobCardDetailsController controller) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
        onPressed: () => {
          Navigator.pop(Get.context!),
        },
      ),
      title: Obx(() => Text(
        controller.jobTitle.value.isNotEmpty
            ? controller.jobTitle.value
            : 'Job Details',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      )),
      centerTitle: true,
    );
  }

  Widget _buildJobDetailHeader(
      JobCardDetailsController controller,
      BuildContext context,
      ) {
    return Obx(() {
      // 1. Check if the controller is currently fetching data
      if (controller.isLoading.value) {
        return Container(
          width: double.infinity,
          height: 180.h, // Approximate height of your header card
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.secondaryPrimary,
            ),
          ),
        );
      }

      // 2. Data is loaded, show the actual Header Card
      return JobDetailHeaderCard(
        jobTitle: controller.jobTitle.value,
        location: controller.location.value,
        isRemote: controller.isRemote.value,
        candidateCount: controller.candidateCount.value,
        deadline: controller.deadline.value,
        thumbnailImage: controller.thumbnail.value.isNotEmpty
            ? controller.thumbnail.value
            : AppImages.jobPost,
        userImages: controller.userImages.toList(), // Ensure fresh list
        isSaved: controller.isSaved.value,
        onSave: controller.toggleSave,
        onViewPost: () {
          Get.toNamed(
            RecruiterRoutes.viewJobPost,
            arguments: {'postId': controller.postId},
          );
        },
        onRePost: (){
          Get.to(()=>RepostScreen(),arguments: {'postId': controller.postId});
        },
        onDeletePost: () {
          _showDeleteDialog(context, controller);
        },
      );
    });
  }

// Cleaned up the dialog into a separate method for readability
  void _showDeleteDialog(BuildContext context, JobCardDetailsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.all(16.r),
        content: CommonText(
          text: 'Are you sure you want to Delete Job Post?',
          maxLines: 2,
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  titleText: 'No',
                  onTap: () => Get.back(),
                  buttonColor: AppColors.transparent,
                  borderColor: AppColors.black,
                  titleColor: AppColors.black,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CommonButton(
                  titleText: 'Yes',
                  onTap: () {
                    Get.back();
                    deleteDialog(context, controller);
                  },
                  buttonColor: AppColors.red,
                  borderColor: AppColors.red,
                  titleColor: AppColors.white,
                  isGradient: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void deleteDialog(BuildContext context, JobCardDetailsController controller){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.all(16.r),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                    text: "Reject Reason",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                ),
                IconButton(onPressed: (){
                  Get.back();
                }, icon: Icon(Icons.close,),)
              ],
            ),
            SizedBox(height: 12.h,),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              controller: controller.deleteReason,
            )
          ],
        ),
        actions: [
          CommonButton(
            titleText: 'Submit',
            onTap: () {
              controller.deletePost();
            },
            buttonColor: AppColors.primaryColor,
            borderColor: AppColors.primaryColor,
            titleColor: AppColors.black,
            isGradient: false,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(JobCardDetailsController controller) {
    return Obx(
          () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.filters.map((filter) {
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChipButton(
                label: filter,
                isSelected: controller.selectedFilter.value == filter,
                onTap: () => controller.selectFilter(filter),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCandidatesList(JobCardDetailsController controller) {
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

      // Show empty state if no applications found
      if (controller.applications.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.r),
            child: Column(
              children: [
                CommonText(
                  text: controller.selectedFilter.value.startsWith('Candidate')
                      ? 'No candidates applied yet'
                      : 'No candidates match this criteria',
                  fontSize: 16.sp,
                  color: AppColors.black.withOpacity(0.6),
                ),
                if (!controller.selectedFilter.value.startsWith('Candidate')) ...[
                  SizedBox(height: 16.h),
                  CommonText(
                    text: 'Try selecting "Candidate" filter to see all',
                    fontSize: 14.sp,
                    color: AppColors.black.withOpacity(0.4),
                  ),
                ],
              ],
            ),
          ),
        );
      }

      // Display list of applications
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.applications.length,
        itemBuilder: (context, index) {
          final application = controller.applications[index];

          // Map API data to CandidateCard
          return CandidateCard(
            name: application.user.name,
            jobTitle: application.title,
            experience: application.experienceYears,
            description: application.user.bio,
            matchPercentage: application.jobMatch,
            profileImage: ApiEndPoint.imageUrl+application.user.image,
            onTap: () => controller.viewCandidateProfile(application.id),
          );
        },
      );
    });
  }
}