import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/features/job_seeker/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../../../../../core/config/api/api_end_point.dart';
import '../../../widgets/info_card.dart';
import '../../../widgets/profile_section.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CommonText(
          text: 'Personal Info',
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: AppColors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GetBuilder<ProfileController>(
            builder: (controller) {
              return Column(
                children: [
                  SizedBox(height: 24.h),
                  _buildProfileSection(controller),
                  SizedBox(height: 32.h),
                  _buildPersonalDetailsCard(controller),
                  SizedBox(height: 16.h),
                  _buildContactDetailsCard(controller),
                  SizedBox(height: 16.h),
                  _buildSummaryCard(controller),
                  SizedBox(height: 40.h),
                  _buildEditProfileButton(context),
                  SizedBox(height: 24.h),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(ProfileController controller) {
    return Obx(
      ()=> ProfileSection(
        name: controller.name.value,
        designation: controller.designation.value,
        imagePath: ApiEndPoint.imageUrl+controller.profileImage.value,
      ),
    );
  }

  Widget _buildPersonalDetailsCard(ProfileController controller) {
    return InfoCard(
      children: [
        Obx(
        ()=>InfoRow(
              label: 'Gender',
              value: controller.gender.value,
          ),
        ),
        const InfoDivider(),
        Obx(
        ()=> InfoRow(
              label: 'Date Of Birth',
              value: controller.dateOfBirth.value,
          ),
        ),
        const InfoDivider(),
        Obx(
    ()=> InfoRow(
              label: 'Nationality',
              value: controller.nationality.value,
          ),
        ),
        const InfoDivider(),
        Obx(
    ()=> InfoRow(
              label: 'Language',
              value: controller.language.value,
          ),
        ),
        const InfoDivider(),
        Obx(
    ()=> InfoRow(
              label: 'Address',
              value: controller.address.value,
    ),
        ),
      ],
    );
  }

  Widget _buildContactDetailsCard(ProfileController controller) {
    return InfoCard(
      children: [
        Obx(
          ()=> InfoRow(
              label: 'Mobile',
              value: controller.mobile.value
          ),
        ),
        const InfoDivider(),
        Obx(
        ()=>InfoRow(
              label: 'Email',
              value: controller.email.value
          ),
        ),
        const InfoDivider(),
        Obx(
    ()=> InfoRow(
              label: 'LinkedIn',
              value: controller.linkedin.value
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(ProfileController controller) {
    return InfoCard(
      children: [
        CommonText(
          text: 'Summary',
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 12.h),
        Obx(
          ()=> CommonText(
            text:
                controller.summary.value,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.black,
            textAlign: TextAlign.left,
            maxLines: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return CommonButton(
      titleText: 'Edit Profile',
      titleSize: 16.sp,
      titleWeight: FontWeight.w600,
      buttonHeight: 52.h,
      buttonRadius: 12.r,
      onTap: () {
        // Navigate to edit personal info screen
        JobSeekerRoutes.goToEditPersonalInfo();
      },
    );
  }
}
