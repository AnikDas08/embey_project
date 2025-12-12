import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../controller/core_skill_controller.dart';

class CoreSkillsScreen extends StatelessWidget {
  const CoreSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller - it will automatically fetch data in onInit
    final controller = Get.put(CoreSkillsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const CommonText(
          text: 'Core Skills',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      body: Obx(() {
        // Show loading indicator while fetching data
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        // Show the form once data is loaded
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Add Skill'),
                        8.height,
                        Row(
                          children: [
                            Expanded(
                              child: CommonTextField(
                                controller: controller.skillController,
                                hintText: 'Enter skill name',
                                onSubmitted: (_) => controller.addSkill(),
                              ),
                            ),
                            12.width,
                            ElevatedButton(
                              onPressed: () => controller.addSkill(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 14.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              child: const CommonText(
                                text: 'Add',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        24.height,

                        Obx(() {
                          if (controller.skills.isEmpty) {
                            return Column(
                              children: [
                                const CommonText(
                                  text: 'No skills added yet',
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                16.height,
                              ],
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Your Skills'),
                              12.height,
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                children: List.generate(
                                  controller.skills.length,
                                      (index) => _buildSkillChip(
                                    controller.skills[index],
                                    index,
                                    controller,
                                  ),
                                ),
                              ),
                              24.height,
                            ],
                          );
                        }),

                        _buildLabel('Suggested Skills'),
                        12.height,
                        Obx(() {
                          return Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: controller.suggestedSkills
                                .map((skill) => _buildSuggestedSkillChip(
                              skill,
                              controller,
                            ))
                                .toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              /// Save Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : () => controller.saveSkills(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        disabledBackgroundColor:
                        AppColors.primary.withOpacity(0.6),
                      ),
                      child: controller.isSaving.value
                          ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const CommonText(
                        text: 'Save',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLabel(String text) {
    return CommonText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  Widget _buildSkillChip(
      String skill,
      int index,
      CoreSkillsController controller,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonText(
            text: skill,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
          8.width,
          GestureDetector(
            onTap: () => controller.removeSkill(index),
            child: Icon(Icons.close, size: 16.sp, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedSkillChip(
      String skill,
      CoreSkillsController controller,
      ) {
    final isAdded = controller.isSkillAdded(skill);

    return GestureDetector(
      onTap: () {
        if (!isAdded) {
          controller.addSuggestedSkill(skill);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isAdded
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isAdded ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText(
              text: skill,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isAdded ? AppColors.primary : Colors.grey.shade700,
            ),
            if (!isAdded) ...[
              6.width,
              Icon(Icons.add, size: 16.sp, color: Colors.grey.shade700),
            ],
          ],
        ),
      ),
    );
  }
}