import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/features/job_seeker/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../../../../../core/config/route/job_seeker_routes.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

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
          text: 'My Profile',
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: AppColors.black,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GetBuilder<ProfileController>(
            builder: (controller) {
              return Column(
                children: [
                  16.height,

                  /// Profile Header Section
                  _buildProfileHeader(controller),

                  48.height,

                  /// Menu Items
                  _buildMenuItem(
                    color: AppColors.secondaryPrimary.withOpacity(0.1),
                    imageSrc: AppIcons.personal,
                    title: 'Personal Info',
                    subtitle: 'Complete',
                    onTap: () {
                      Get.toNamed(JobSeekerRoutes.personalInfo);
                    },
                  ),
                  16.height,

                  _buildMenuItem(
                    color: AppColors.primary.withOpacity(0.1),
                    imageSrc: AppIcons.education2,
                    title: 'Education',
                    subtitle: 'Complete',
                    onTap: () {
                      Get.toNamed(JobSeekerRoutes.education);
                    },
                  ),
                  16.height,
                  _buildMenuItem(
                    color: AppColors.success.withOpacity(0.1),
                    imageSrc: AppIcons.workEdit,
                    title: 'Work Experience',
                    subtitle: 'Complete',
                    onTap: () {
                      Get.toNamed(JobSeekerRoutes.workExperience);
                    },
                  ),
                  16.height,
                  _buildMenuItem(
                    color: AppColors.buttomNavBarColor.withOpacity(0.1),
                    imageSrc: AppIcons.star,
                    title: 'Skills',
                    subtitle: 'Complete',
                    onTap: () {
                      Get.toNamed(JobSeekerRoutes.skills);
                    },
                    isLast: true,
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Column(
      children: [
        /// Profile Image
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.borderColor.withOpacity(0.3),
              width: 1.w,
            ),
          ),
          child: ClipOval(
            child: Obx(
                  () => Image.network(
                  ApiEndPoint.imageUrl+controller.profileImage.value,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      AppIcons.profile,
                      fit: BoxFit.cover,
                    );
                  }
              ),
            ),
          ),
        ),

        16.height,

        /// Name
        Obx(
        ()=> CommonText(
            text: controller.name.value,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),

        4.height,

        /// Designation
        Obx(
              ()=> CommonText(
            text: controller.designation.value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String imageSrc,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: const Color(0xFFEDEDED) /* Cart-BG-8 */,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                /// Icon Container
                Container(
                  padding: EdgeInsets.all(10.w),
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CommonImage(imageSrc: imageSrc, width: 24, height: 24),
                ),

                16.width,

                /// Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: title,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        textAlign: TextAlign.start,
                      ),
                      2.height,
                      CommonText(
                        text: subtitle,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryText,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                /// Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.secondaryText,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),

        /// Divider (except for last item)
        if (!isLast)
          Divider(
            color: AppColors.borderColor.withOpacity(0.3),
            thickness: 0.5.h,
            height: 0,
          ),
      ],
    );
  }
}
