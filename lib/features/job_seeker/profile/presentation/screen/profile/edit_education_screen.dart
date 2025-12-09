import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../../../home/data/model/home_model.dart';
import '../../controller/education_controller.dart';

class EditEducationScreen extends StatelessWidget {
  final Education? education;

  const EditEducationScreen({
    super.key,
    this.education,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EducationController>();

    // Set education data when screen loads
    controller.setEducationForEdit(education!);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20.sp),
          onPressed: () {
            controller.clearEducationForm();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: CommonText(
          text: 'Edit Education',
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: AppColors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Degree Field
                    _buildLabel('Degree'),
                    SizedBox(height: 8.h),
                    CommonTextField(
                      controller: controller.degreeController,
                      hintText: 'Enter degree',
                    ),
                    SizedBox(height: 16.h),

                    // Institute Field
                    _buildLabel('Institute'),
                    SizedBox(height: 8.h),
                    CommonTextField(
                      controller: controller.instituteController,
                      hintText: 'Enter institute name',
                    ),
                    SizedBox(height: 16.h),

                    // Start Date Field
                    _buildLabel('Start Date'),
                    SizedBox(height: 8.h),
                    CommonTextField(
                      controller: controller.startDateController,
                      hintText: 'Select start date',
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        size: 20.sp,
                        color: AppColors.primaryColor,
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          controller.startDateController.text =
                          '${date.day.toString().padLeft(2, '0')} ${controller.getMonthName(date.month)} ${date.year}';
                        }
                      },
                    ),
                    SizedBox(height: 16.h),

                    // End Date Field
                    _buildLabel('End Date'),
                    SizedBox(height: 8.h),
                    CommonTextField(
                      controller: controller.endDateController,
                      hintText: 'Select end date',
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        size: 20.sp,
                        color: AppColors.primaryColor,
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          controller.endDateController.text =
                          '${date.day.toString().padLeft(2, '0')} ${controller.getMonthName(date.month)} ${date.year}';
                        }
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Passing Year Field
                    _buildLabel('Passing Year'),
                    SizedBox(height: 8.h),
                    CommonTextField(
                      controller: controller.passingYearController,
                      hintText: 'Enter passing year',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),

                    // GPA Field
                    _buildLabel('Grade Point'),
                    SizedBox(height: 8.h),
                    CommonTextField(
                      controller: controller.gpaController,
                      hintText: 'Enter GPA',
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Update Button
            GetBuilder<EducationController>(
              builder: (controller) {
                return Padding(
                  padding: EdgeInsets.all(20.w),
                  child: CommonButton(
                    titleText: 'Update',
                    buttonHeight: 50.h,
                    titleSize: 16.sp,
                    isLoading: controller.isLoading,
                    onTap: () async {
                      await controller.updateEducation();
                      if (!controller.isLoading) {
                        controller.clearEducationForm();
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return CommonText(
      text: text,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    );
  }
}