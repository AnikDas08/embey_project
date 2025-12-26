import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../controller/short_job_listed_controller.dart';
import '../../../home/presentation/widgets/shortlisted_candidate_card.dart';

class ShortJobListedScreen extends StatelessWidget {
  const ShortJobListedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShortJobListedController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: _buildCandidatesList(controller),
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
      title: CommonText(
        text: 'Short Listed',
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      centerTitle: true,
    );
  }

  Widget _buildCandidatesList(ShortJobListedController controller) {
    return Obx(
          () {
        // 1. Check if the controller is currently loading data
        if (controller.isLoading.value) {
          return SizedBox(
            height: Get.height * 0.7, // Centers it roughly on the screen
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary, // Or your preferred color
              ),
            ),
          );
        }

        // 2. If not loading, check if the list is empty
        if (controller.applications.isEmpty) {
          return _buildEmptyState();
        }

        // 3. Otherwise, show the list
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.applications.length,
          itemBuilder: (context, index) {
            final application = controller.applications[index];
            return ShortlistedCandidateCard(
              name: application.user.name,
              jobTitle: application.title,
              experience: application.experienceYears,
              description: application.user.bio,
              profileImage: ApiEndPoint.imageUrl+application.user.image,
              onTap: () => controller.viewCandidateProfile(application.id),
              onDelete: () => _showDeleteDialog(context, controller, index),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, ShortJobListedController controller, int index) {
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
                    controller.deletePost(controller.applications[index].id);
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Text(
          'No shortlisted candidates',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}
