import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../controller/education_controller.dart';
import '../../data/model/resume_model.dart';
import '../widgets/add_education_dialog.dart';

class EducationScreenResume extends StatelessWidget {
  const EducationScreenResume({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller - it will automatically fetch data in onInit
    final controller = Get.put(EducationController());

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
          text: 'Education',
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
                        // Education List
                        Obx(() {
                          if (controller.educations.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: const CommonText(
                                  text: 'No education added yet',
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.educations.length,
                            separatorBuilder: (context, index) => 16.height,
                            itemBuilder: (context, index) {
                              final education = controller.educations[index];
                              return _buildEducationCard(
                                context,
                                education,
                                index,
                                controller,
                              );
                            },
                          );
                        }),

                        24.height,

                        // Add Other Education Button
                        GestureDetector(
                          onTap: () {
                            _showAddEducationDialog(context, controller);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              8.width,
                              const CommonText(
                                text: 'Add Other Education',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),

                        24.height,
                      ],
                    ),
                  ),
                ),
              ),

              /// Update Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : () => controller.resumeId==""?controller.createResumeWithEducations():controller.saveEducations(),
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
                        text: controller.resumeId==""?'Create':'Update',
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

  Widget _buildEducationCard(
      BuildContext context,
      Education education,
      int index,
      EducationController controller,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'Degree Name',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    4.height,
                    CommonText(
                      text: education.degree,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // Edit Icon
                  GestureDetector(
                    onTap: () {
                      _showEditEducationDialog(
                        context,
                        controller,
                        education,
                        index,
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                  16.width,
                  // Delete Icon
                  GestureDetector(
                    onTap: () {
                      _showDeleteDialog(context, controller, index);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          16.height,
          const CommonText(
            text: 'University Name',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          4.height,
          CommonText(
            text: education.institution,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          if (education.grade != null && education.grade!.isNotEmpty) ...[
            16.height,
            const CommonText(
              text: 'Grade',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            4.height,
            CommonText(
              text: education.grade!,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ],
          if (education.passingYear != null) ...[
            16.height,
            const CommonText(
              text: 'Passing Year',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            4.height,
            CommonText(
              text: education.passingYear.toString(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ],
        ],
      ),
    );
  }

  void _showAddEducationDialog(
      BuildContext context,
      EducationController controller,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddEducationDialog(
        onSave: (education) {
          controller.addEducation(education);
        },
      ),
    );
  }

  void _showEditEducationDialog(
      BuildContext context,
      EducationController controller,
      Education education,
      int index,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddEducationDialog(
        education: education,
        onSave: (updatedEducation) {
          controller.updateEducation(index, updatedEducation);
        },
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      EducationController controller,
      int index,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CommonText(
            text: 'Delete Education',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          content: const CommonText(
            text: 'Are you sure you want to delete this education?',
            fontSize: 14,
            maxLines: 2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const CommonText(
                text: 'Cancel',
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.removeEducation(index);
              },
              child: const CommonText(
                text: 'Delete',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}