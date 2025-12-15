import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../data/model/resume_model.dart';
import '../controller/core_skill_controller.dart';
import '../widgets/add_feature_dialog.dart';
import '../widgets/add_work_experience_dialog.dart';

class CoreSkillsScreen extends StatelessWidget {
  const CoreSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CoreSkillsNewController());

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
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Core Skills Section Title
                        const CommonText(
                          text: 'Core Skills',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        16.height,

                        /// Core Features List
                        Obx(() {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.coreFeatures.length,
                            separatorBuilder: (context, index) => 16.height,
                            itemBuilder: (context, index) {
                              final feature = controller.coreFeatures[index];
                              return _buildCoreFeatureCard(
                                context,
                                feature,
                                index,
                                controller,
                              );
                            },
                          );
                        }),

                        /// Add Button for Core Features
                        if (controller.coreFeatures.isNotEmpty) 16.height,
                        _buildAddButton(
                          'ADD',
                          AppColors.primary,
                              () => _showAddCoreFeatureDialog(context, controller),
                        ),

                        32.height,

                        /// Experience Section Title
                        const CommonText(
                          text: 'Experience',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        16.height,

                        /// Work Experiences List
                        Obx(() {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.workExperiences.length,
                            separatorBuilder: (context, index) => 16.height,
                            itemBuilder: (context, index) {
                              final experience = controller.workExperiences[index];
                              return _buildExperienceCard(
                                context,
                                experience,
                                index,
                                controller,
                              );
                            },
                          );
                        }),

                        /// Add Button for Experience
                        16.height,
                        _buildAddExperienceButton(
                              () => _showAddExperienceDialog(context, controller),
                        ),

                        24.height,
                      ],
                    ),
                  ),
                ),
              ),

              /// Add Button at Bottom
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : () => controller.resumeId==""
                          ? controller.createResume()
                          : controller.updateCoreSkills(),
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
                          : CommonText(
                        text: controller.resumeId==""? 'Create' : 'Update',
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

  Widget _buildCoreFeatureCard(
      BuildContext context,
      CoreFeature feature,
      int index,
      CoreSkillsNewController controller,
      ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title with Edit/Delete
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'Skills Title',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    4.height,
                    CommonText(
                      text: feature.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showEditCoreFeatureDialog(
                      context,
                      controller,
                      feature,
                      index,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 16.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  8.width,
                  GestureDetector(
                    onTap: () => controller.removeCoreFeature(index),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 16.sp,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          16.height,

          /// Description
          const CommonText(
            text: 'Description',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          4.height,
          CommonText(
            text: feature.description,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            maxLines: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(
      BuildContext context,
      WorkExperience experience,
      int index,
      CoreSkillsNewController controller,
      ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Job Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'Job Title',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    4.height,
                    CommonText(
                      text: experience.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showEditExperienceDialog(
                      context,
                      controller,
                      experience,
                      index,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 16.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  8.width,
                  GestureDetector(
                    onTap: () => controller.removeWorkExperience(index),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 16.sp,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          16.height,

          /// Company Name
          const CommonText(
            text: 'Company Name',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          4.height,
          CommonText(
            text: experience.company,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),

          16.height,

          /// Designation
          const CommonText(
            text: 'Designation',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          4.height,
          CommonText(
            text: experience.designation,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),

          16.height,

          /// Dates Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'Start Date',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    4.height,
                    CommonText(
                      text: _formatDate(experience.startDate),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              16.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'End Date',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    4.height,
                    CommonText(
                      text: experience.endDate.isEmpty
                          ? 'Present'
                          : _formatDate(experience.endDate),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),

          16.height,

          /// Description
          const CommonText(
            text: 'Description',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          4.height,
          CommonText(
            text: experience.description,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            maxLines: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Center(
          child: CommonText(
            text: text,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAddExperienceButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primary, size: 20.sp),
            8.width,
            const CommonText(
              text: 'Add Other Experience',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    try {
      final DateTime dateTime = DateTime.parse(date);
      return '${dateTime.day.toString().padLeft(2, '0')} ${_getMonthName(dateTime.month)} ${dateTime.year}';
    } catch (e) {
      return date;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  void _showAddCoreFeatureDialog(
      BuildContext context,
      CoreSkillsNewController controller,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddCoreFeatureDialog(
        onSave: (feature) => controller.addCoreFeature(feature),
      ),
    );
  }

  void _showEditCoreFeatureDialog(
      BuildContext context,
      CoreSkillsNewController controller,
      CoreFeature feature,
      int index,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddCoreFeatureDialog(
        feature: feature,
        onSave: (updatedFeature) =>
            controller.updateCoreFeature(index, updatedFeature),
      ),
    );
  }

  void _showAddExperienceDialog(
      BuildContext context,
      CoreSkillsNewController controller,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddWorkExperienceDialog(
        onSave: (experience) => controller.addWorkExperience(experience),
      ),
    );
  }

  void _showEditExperienceDialog(
      BuildContext context,
      CoreSkillsNewController controller,
      WorkExperience experience,
      int index,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddWorkExperienceDialog(
        experience: experience,
        onSave: (updatedExp) =>
            controller.updateWorkExperience(index, updatedExp),
      ),
    );
  }
}