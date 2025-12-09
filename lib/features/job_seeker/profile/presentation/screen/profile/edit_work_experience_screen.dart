import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/text_field/common_text_field.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../home/data/model/home_model.dart';
import '../../controller/work_experinece_employee_controller.dart';

class EditWorkExperienceScreen extends StatelessWidget {
  final WorkExperience? workExperience;

  const EditWorkExperienceScreen({
    super.key,
    this.workExperience,
  });

  @override
  Widget build(BuildContext context) {
    // Get existing controller
    final controller = Get.find<WorkExperienceController>();

    // Set work experience data for editing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setWorkExperienceForEdit(workExperience!);
    });

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
          text: 'Edit Work Experience',
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: AppColors.black,
        ),
      ),
      body: GetBuilder<WorkExperienceController>(
        builder: (controller) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),

                          // Job Title
                          _buildLabel('Job Title'),
                          SizedBox(height: 8.h),
                          CommonTextField(
                            hintText: 'Enter job title',
                            controller: controller.titleController,
                          ),
                          SizedBox(height: 16.h),

                          // Company Name
                          _buildLabel('Company Name'),
                          SizedBox(height: 8.h),
                          CommonTextField(
                            hintText: 'Enter company name',
                            controller: controller.companyController,
                          ),
                          SizedBox(height: 16.h),

                          // Location
                          _buildLabel('Location'),
                          SizedBox(height: 8.h),
                          CommonTextField(
                            hintText: 'Enter location',
                            controller: controller.locationController,
                          ),
                          SizedBox(height: 16.h),

                          // Start and End Date
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Start Date'),
                                    SizedBox(height: 8.h),
                                    CommonTextField(
                                      hintText: 'Select start date',
                                      controller: controller.startDateController,
                                      readOnly: true,
                                      suffixIcon: Icon(
                                        Icons.calendar_today,
                                        size: 20.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                      onTap: () => controller.selectStartDate(context),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('End Date'),
                                    SizedBox(height: 8.h),
                                    Obx(() {
                                      return CommonTextField(
                                        hintText: controller.isCurrentJob.value
                                            ? 'Present'
                                            : 'Select end date',
                                        controller: controller.endDateController,
                                        readOnly: true,
                                        //enabled: !controller.isCurrentJob.value,
                                        suffixIcon: Icon(
                                          Icons.calendar_today,
                                          size: 20.sp,
                                          color: controller.isCurrentJob.value
                                              ? AppColors.grey
                                              : AppColors.primaryColor,
                                        ),
                                        onTap: controller.isCurrentJob.value
                                            ? null
                                            : () => controller.selectEndDate(context),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Description
                          _buildLabel('Description'),
                          SizedBox(height: 8.h),
                          CommonTextField(
                            hintText: 'Enter job description',
                            controller: controller.descriptionController,
                            maxLines: 5,
                          ),
                          SizedBox(height: 8.h),

                          // Current Job Checkbox
                          Obx(() {
                            return Row(
                              children: [
                                Checkbox(
                                  value: controller.isCurrentJob.value,
                                  onChanged: (value) {
                                    controller.isCurrentJob.value = value ?? false;
                                    if (value == true) {
                                      controller.endDateController.clear();
                                      controller.endDateApi = "";
                                    }
                                    controller.update();
                                  },
                                  activeColor: AppColors.primary,
                                ),
                                SizedBox(width: 8.w),
                                CommonText(
                                  text: 'I Currently Work at This Company',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ],
                            );
                          }),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // Update Button
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: controller.isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                        : CommonButton(
                      titleText: 'Update',
                      titleSize: 16.sp,
                      titleWeight: FontWeight.w600,
                      buttonHeight: 52.h,
                      buttonRadius: 12.r,
                      onTap: () async {
          await controller.updateWorkExperience();
          if (!controller.isLoading) {
          controller.clearWorkExperienceForm();
          Navigator.pop(context);
          }
          },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return CommonText(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
      color: AppColors.black,
    );
  }
}