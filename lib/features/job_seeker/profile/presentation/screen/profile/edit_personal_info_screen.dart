import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../controller/edit_personalinformation_controller.dart';
import '../../widgets/form_field_with_label.dart';

class EditPersonalInfoScreen extends StatelessWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(EditPersonalController());

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
          text: 'Personal Information',
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: AppColors.black,
        ),
      ),
      body: GetBuilder<EditPersonalController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  _buildProfileSection(controller),
                  SizedBox(height: 32.h),
                  _buildFormFields(controller, context),
                  SizedBox(height: 40.h),
                  _buildUpdateButton(controller),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(EditPersonalController controller) {
    return Obx(() {
      // Safe null checking
      final hasSelectedImage = controller.selectedImage.value != null;
      final hasProfileImage = controller.profileImage.value.isNotEmpty;

      return Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 60.r,
            backgroundColor: AppColors.grey.withOpacity(0.3),
            backgroundImage: hasSelectedImage
                ? FileImage(controller.selectedImage.value!) as ImageProvider
                : hasProfileImage
                ? NetworkImage(ApiEndPoint.imageUrl+controller.profileImage.value) as ImageProvider
                : const AssetImage('assets/images/profile.png') as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => controller.pickImage(),
              child: Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFormFields(EditPersonalController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldWithLabel(
          label: 'Full Name',
          controller: controller.fullNameController,
          /*validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },*/
        ),
        SizedBox(height: 20.h),
        FormFieldWithLabel(
          label: 'Designation',
          controller: controller.designationController,
         /* validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your designation';
            }
            return null;
          },*/
        ),
        SizedBox(height: 20.h),
        FormFieldWithLabel(
          label: 'Date Of Birth',
          controller: controller.dateOfBirthController,
          suffixIcon: Icons.calendar_today,
          readOnly: true,
          onTap: () => controller.selectDateOfBirth(context),
          /*validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your date of birth';
            }
            return null;
          },*/
        ),
        SizedBox(height: 20.h),
        FormFieldWithLabel(
          label: 'Gender',
          controller: controller.genderController,
          suffixIcon: Icons.keyboard_arrow_down,
          readOnly: true,
          onTap: () => controller.selectGender(context),
          /*validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your gender';
            }
            return null;
          },*/
        ),
        SizedBox(height: 20.h),
        FormFieldWithLabel(
          label: 'Nationality',
          controller: controller.nationalityController,
          /*validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your nationality';
            }
            return null;
          },*/
        ),
        SizedBox(height: 20.h),
        FormFieldWithLabel(
          label: 'Address',
          controller: controller.addressController,
          /*validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },*/
        ),
        SizedBox(height: 20.h),
        FormFieldWithLabel(
          label: 'Phone',
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          /*validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },*/
        ),
        SizedBox(height: 20.h),
        FormFieldWithLabel(
          label: 'Social Media Link',
          controller: controller.socialMediaController,
          keyboardType: TextInputType.url,
        ),
        SizedBox(height: 20.h),
        FormFieldWithLabel(
          label: 'Summary',
          controller: controller.summaryController,
          maxLines: 4,
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }

  Widget _buildUpdateButton(EditPersonalController controller) {
    return Obx(() {
      return controller.isUpdating.value
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
        buttonRadius: 8.r,
        onTap: () => controller.editPersonalInformation(),
      );
    });
  }
}