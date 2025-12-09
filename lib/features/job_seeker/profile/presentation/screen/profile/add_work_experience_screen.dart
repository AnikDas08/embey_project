import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/text_field/common_text_field.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../controller/work_experinece_employee_controller.dart';

class AddWorkExperienceScreen extends StatelessWidget {
  const AddWorkExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get existing controller
    final controller = Get.find<WorkExperienceController>();

    // Clear form when opening add screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearWorkExperienceForm();
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
          text: 'Add Work Experience',
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
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
                          CommonText(
                            text: 'Job Title',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                          SizedBox(height: 8.h),
                          CommonTextField(
                            hintText: 'Enter job title',
                            controller: controller.titleController,
                          ),
                          SizedBox(height: 16.h),

                          // Company Name
                          CommonText(
                            text: 'Company Name',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                          SizedBox(height: 8.h),
                          CommonTextField(
                            hintText: 'Enter company name',
                            controller: controller.companyController,
                          ),
                          SizedBox(height: 16.h),

                          // Location
                          CommonText(
                            text: 'Location',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                          SizedBox(height: 8.h),
                          CommonTextField(
                            hintText: 'Enter location',
                            controller: controller.locationController,
                          ),
                          SizedBox(height: 16.h),

                          // Start and End Date Row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: 'Start Date',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: AppColors.black,
                                    ),
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
                                    CommonText(
                                      text: 'End Date',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: AppColors.black,
                                    ),
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
                          CommonText(
                            text: 'Description',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
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
                                Expanded(
                                  child: CommonText(
                                    text: 'I Currently Work at This Company',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            );
                          }),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // Add Button
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: controller.isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                        : CommonButton(
                      titleText: 'Add',
                      titleSize: 16.sp,
                      titleWeight: FontWeight.w600,
                      buttonHeight: 52.h,
                      buttonRadius: 12.r,
                      onTap: () => controller.addWorkExperience(),
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
}