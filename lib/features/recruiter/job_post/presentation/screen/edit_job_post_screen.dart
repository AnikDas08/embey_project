import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/text_field/common_text_field.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import '../controller/edit_job_post_controller.dart';

class RecruiterEditJobPostScreen extends StatelessWidget {
  const RecruiterEditJobPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecruiterEditJobPostController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppbar(title: 'EDIT POST', centerTitle: true),
      body: Obx(() {
        // Show loader if the initial data isn't ready yet
        if (controller.isLoading.value && controller.jobDetails.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- IMAGE PICKER SECTION ---
                    _buildImagePicker(controller),

                    SizedBox(height: 24.h),

                    _buildLabel('Job Title'),
                    CommonTextField(
                        controller: controller.jobTitleController,
                        hintText: 'Enter title'
                    ),

                    SizedBox(height: 16.h),
                    _buildLabel('Job Category'),
                    _buildDropdown(
                      value: controller.selectedCategoryName.value,
                      items: controller.categories.map((e) => e['name'].toString()).toList(),
                      onChanged: (v) => controller.setCategory(v),
                      hint: "Select Category",
                    ),

                    SizedBox(height: 16.h),
                    _buildLabel('Job Type'),
                    _buildDropdown(
                      value: controller.selectedJobType.value,
                      items: controller.jobTypes,
                      onChanged: (v) => controller.selectedJobType.value = v,
                    ),

                    SizedBox(height: 16.h),
                    _buildLabel('Experience Level'),
                    _buildDropdown(
                      value: controller.selectedExperienceLevel.value,
                      items: controller.experienceLevels,
                      onChanged: (v) => controller.selectedExperienceLevel.value = v,
                    ),

                    SizedBox(height: 16.h),
                    _buildLabel('Job Level'),
                    _buildDropdown(
                      value: controller.selectedJobLevel.value,
                      items: controller.jobLevels,
                      onChanged: (v) => controller.selectedJobLevel.value = v,
                    ),

                    SizedBox(height: 16.h),
                    // --- SALARY ROW ---
                    Row(
                      children: [
                        Expanded(
                          child: _buildLabeledField('Min Salary', controller.minSalaryController),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildLabeledField('Max Salary', controller.maxSalaryController),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
                    _buildLabel('Job Location'),
                    CommonTextField(
                        controller: controller.jobLocationController,
                        hintText: 'Location'
                    ),

                    SizedBox(height: 16.h),
                    _buildLabel('Job Description'),
                    CommonTextField(
                        controller: controller.companyDescriptionController,
                        hintText: 'Description',
                        maxLines: 4
                    ),

                    SizedBox(height: 16.h),
                    _buildLabel('Deadline'),
                    CommonTextField(
                      controller: controller.applicationDeadlineController,
                      readOnly: true,
                      suffixIcon: const Icon(Icons.calendar_today, size: 18),
                      onTap: controller.selectDeadlineDate,
                    ),

                    SizedBox(height: 16.h),
                    _buildLabel('Skills'),
                    Wrap(
                      spacing: 8.w,
                      children: [
                        ...controller.skills.map((s) => Chip(
                          label: Text(s),
                          onDeleted: () => controller.removeSkill(s),
                          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                        )),
                        ActionChip(
                            label: const Text("+ Add Skill"),
                            onPressed: controller.showAddSkillDialog
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),

            // --- SUBMIT BUTTON ---
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CommonButton(
                titleText: controller.isLoading.value ? 'Updating...' : 'Submit',
                onTap: controller.isLoading.value ? null : controller.submitJobPost,
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- Image Picker Widget with Logic for File vs Network ---
  Widget _buildImagePicker(RecruiterEditJobPostController controller) {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: controller.pickProfileImage,
            child: Container(
              height: 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderColor),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Obx(() {
                  // PRIORITY 1: Show the local file if the user just picked one
                  if (controller.profileImagePath.value != null) {
                    return Image.file(
                      File(controller.profileImagePath.value!),
                      fit: BoxFit.cover,
                      key: ValueKey(controller.profileImagePath.value), // Forces refresh
                    );
                  }
                  // PRIORITY 2: Show the existing image from the server
                  else if (controller.existingImageUrl.value.isNotEmpty) {
                    return CommonImage(
                        imageSrc: controller.existingImageUrl.value,
                    );
                  }
                  // PRIORITY 3: Placeholder icon
                  else {
                    return const Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey);
                  }
                }),
              ),
            ),
          ),
          // Edit Icon Overlay
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: controller.pickProfileImage,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        CommonTextField(controller: ctrl, keyboardType: TextInputType.number),
      ],
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: CommonText(text: text, fontSize: 14.sp, fontWeight: FontWeight.w600),
  );

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String) onChanged,
    String hint = "Select",
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(8.r)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          hint: Text(hint),
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}