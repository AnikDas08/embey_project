// add_career_spotlight_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:intl/intl.dart';

import '../controller/add_career_spotlight_controller.dart';

class AddCareerSpotlightScreen extends StatelessWidget {
  const AddCareerSpotlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddCareerSpotlightController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppbar(
        title: 'Add Career Spotlight',
        showLeading: true,
        backgroundColor: AppColors.white,
        textColor: AppColors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover Image Section
                    _buildSectionTitle('Cover Image *'),
                    SizedBox(height: 12.h),
                    Obx(() => _buildImagePicker(context, controller)),
                    SizedBox(height: 24.h),

                    // Organization Name
                    _buildSectionTitle('Organization Name *'),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: controller.organizationNameController,
                      hint: 'Enter organization name',
                    ),
                    SizedBox(height: 20.h),

                    // Service Type
                    _buildSectionTitle('Service Type *'),
                    SizedBox(height: 12.h),
                    Obx(() => _buildDropdown(
                      value: controller.selectedServiceType.value,
                      items: controller.serviceTypes,
                      hint: 'Select service type',
                      onChanged: (value) =>
                      controller.selectedServiceType.value = value,
                    )),
                    SizedBox(height: 20.h),

                    // Focus Area
                    _buildSectionTitle('Focus Area *'),
                    SizedBox(height: 12.h),
                    Obx(() => _buildDropdown(
                      value: controller.selectedFocusArea.value,
                      items: controller.focusAreas,
                      hint: 'Select focus area',
                      onChanged: (value) =>
                      controller.selectedFocusArea.value = value,
                    )),
                    SizedBox(height: 20.h),

                    // Mode
                    _buildSectionTitle('Mode *'),
                    SizedBox(height: 12.h),
                    Obx(() => _buildDropdown(
                      value: controller.selectedMode.value,
                      items: controller.modes,
                      hint: 'Select mode',
                      onChanged: (value) =>
                      controller.selectedMode.value = value,
                    )),
                    SizedBox(height: 20.h),

                    // Location
                    _buildSectionTitle('Location *'),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: controller.locationController,
                      hint: 'Enter location (e.g., New York, USA)',
                    ),
                    SizedBox(height: 20.h),

                    // Pricing
                    _buildSectionTitle('Pricing *'),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: controller.pricingController,
                      hint: 'Enter pricing (e.g., Free Trial, \$500)',
                    ),
                    SizedBox(height: 20.h),

                    // Date Range
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Start Date *'),
                              SizedBox(height: 12.h),
                              Obx(() => _buildDatePicker(
                                context: context,
                                date: controller.startDate.value,
                                hint: 'Select start date',
                                onTap: () => controller.selectStartDate(context),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('End Date *'),
                              SizedBox(height: 12.h),
                              Obx(() => _buildDatePicker(
                                context: context,
                                date: controller.endDate.value,
                                hint: 'Select end date',
                                onTap: () => controller.selectEndDate(context),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Time Range
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Start Time *'),
                              SizedBox(height: 12.h),
                              _buildTextField(
                                controller: controller.startTimeController,
                                hint: 'HH:MM',
                                readOnly: true,
                                onTap: () => _selectTime(
                                  context,
                                  controller.startTimeController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('End Time *'),
                              SizedBox(height: 12.h),
                              _buildTextField(
                                controller: controller.endTimeController,
                                hint: 'HH:MM',
                                readOnly: true,
                                onTap: () => _selectTime(
                                  context,
                                  controller.endTimeController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Contact Information
                    _buildSectionTitle('Contact Information *'),
                    SizedBox(height: 12.h),
                    Obx(() => _buildDropdown(
                      value: controller.selectedContactType.value,
                      items: controller.contactTypes,
                      hint: 'Select contact type',
                      onChanged: (value) =>
                      controller.selectedContactType.value = value,
                    )),
                    SizedBox(height: 12.h),
                    Obx(() => _buildTextField(
                      controller: controller.contactDetailsController,
                      hint: controller.selectedContactType.value == 'email'
                          ? 'Enter email address'
                          : controller.selectedContactType.value == 'phone'
                          ? 'Enter phone number'
                          : 'Enter website URL',
                      keyboardType:
                      controller.selectedContactType.value == 'phone'
                          ? TextInputType.phone
                          : controller.selectedContactType.value ==
                          'email'
                          ? TextInputType.emailAddress
                          : TextInputType.url,
                    )),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),

            // Submit Button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Obx(() => CommonButton(
                titleText: controller.isLoading.value
                    ? 'Submitting...'
                    : 'Submit Spotlight',
                titleSize: 18,
                titleWeight: FontWeight.w600,
                buttonHeight: 50.h,
                buttonRadius: 8,
                buttonColor: controller.isLoading.value
                    ? AppColors.primaryColor.withOpacity(0.6)
                    : AppColors.primaryColor,
                isGradient: false,
                onTap: controller.isLoading.value
                    ? () {}
                    : controller.submitSpotlight,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return CommonText(
      text: title,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.secondaryText,
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14.sp,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildImagePicker(
      BuildContext context, AddCareerSpotlightController controller) {
    if (controller.coverImage.value != null) {
      return Stack(
        children: [
          Container(
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.file(
                controller.coverImage.value!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: controller.removeImage,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => controller.showImagePickerOptions(context),
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48.sp,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 8.h),
            CommonText(
              text: 'Tap to upload cover image',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
            SizedBox(height: 4.h),
            CommonText(
              text: 'JPG, PNG (Max 5MB)',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryText.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required DateTime? date,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null
                  ? DateFormat('MMM dd, yyyy').format(date)
                  : hint,
              style: TextStyle(
                color: date != null ? AppColors.black : AppColors.secondaryText,
                fontSize: 14.sp,
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 20.sp,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(
      BuildContext context,
      TextEditingController controller,
      ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Format time as HH:MM (24-hour format)
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      controller.text = '$hour:$minute';
    }
  }
}