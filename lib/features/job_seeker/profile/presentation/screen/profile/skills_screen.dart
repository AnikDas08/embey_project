import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../controller/skills_controllerr.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller once
    final controller = Get.put(SkillsController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: CommonText(
          text: 'Skills',
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: AppColors.black,
        ),
      ),
      // Use Obx for the entire body - single reactive wrapper
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // Add Skills Title
                CommonText(
                  text: 'Add Skills',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: AppColors.black,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 16.h),

                // Skills Label
                CommonText(
                  text: 'Skills',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: AppColors.black,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 8.h),

                // Skills Input Field
                CommonTextField(
                  controller: controller.skillController,
                  hintText: 'Enter skill (e.g., Figma, UX Design)',
                  fillColor: AppColors.white,
                  borderColor: AppColors.borderColor,
                  borderRadius: 8,
                  paddingHorizontal: 16,
                  paddingVertical: 14,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) => controller.addSkill(),
                ),
                SizedBox(height: 16.h),

                // Add Button
                Center(
                  child: SizedBox(
                    width: 140.w,
                    height: 40.h,
                    child: CommonButton(
                      titleText: 'Add',
                      buttonColor: AppColors.secondaryPrimary,
                      titleColor: AppColors.white,
                      buttonRadius: 8,
                      buttonHeight: 40.h,
                      buttonWidth: 140.w,
                      titleSize: 16,
                      titleWeight: FontWeight.w600,
                      isGradient: false,
                      borderColor: AppColors.secondaryPrimary,
                      onTap: () => controller.addSkill(),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Skills Count
                CommonText(
                  text: 'Your Skills (${controller.skillsList.length})',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: AppColors.black,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 12.h),

                // Skills Chips
                Expanded(
                  child: controller.skillsList.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.stars_outlined,
                          size: 60.sp,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: 16.h),
                        CommonText(
                          text: 'No skills added yet',
                          fontSize: 16.sp,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: 8.h),
                        CommonText(
                          text: 'Add your skills to showcase your expertise',
                          fontSize: 14.sp,
                          color: AppColors.secondaryText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                      : SingleChildScrollView(
                    child: Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: List.generate(
                        controller.skillsList.length,
                            (index) => _buildSkillChip(
                          controller.skillsList[index],
                          index,
                          controller,
                        ),
                      ),
                    ),
                  ),
                ),

                // Update Button
                controller.isUpdating.value
                    ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                )
                    : CommonButton(
                  titleText: 'Update',
                  buttonColor: AppColors.primaryColor,
                  titleColor: AppColors.white,
                  buttonRadius: 8,
                  buttonHeight: 48.h,
                  titleSize: 16,
                  titleWeight: FontWeight.w600,
                  onTap: () => controller.updateSkills(),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSkillChip(String skill, int index, SkillsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Color(0xFFEFE6F5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonText(
            text: skill,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => controller.removeSkill(index),
            child: Icon(Icons.close, size: 16.sp, color: AppColors.black),
          ),
        ],
      ),
    );
  }
}