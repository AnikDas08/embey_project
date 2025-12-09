import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../controller/education_controller.dart';

class AddEducationScreen extends StatelessWidget {
  const AddEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /*// Get existing controller or create new one
    final controller = Get.find<EducationController>();

    // Clear form when opening add screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearEducationForm();
    });*/

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
          text: 'Add Education',
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: AppColors.black,
        ),
      ),
      body: GetBuilder<EducationController>(
        builder: (controller) {
          return SafeArea(
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
                          onTap: () => _selectStartDate(context, controller),
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
                          onTap: () => _selectEndDate(context, controller),
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
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                // Add Button
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: controller.isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                      : CommonButton(
                    titleText: 'Add',
                    buttonHeight: 50.h,
                    titleSize: 16.sp,
                    onTap: () => controller.addItem(),
                  ),
                ),
              ],
            ),
          );
        },
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

  /// Select Start Date
  Future<void> _selectStartDate(BuildContext context, EducationController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Format as "yyyy" for API (just year)
      controller.startDateController.text = picked.year.toString();
      controller.update();
    }
  }

  /// Select End Date
  Future<void> _selectEndDate(BuildContext context, EducationController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Format as "yyyy" for API (just year)
      controller.endDateController.text = picked.year.toString();
      controller.update();
    }
  }
}