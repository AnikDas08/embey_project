import 'dart:io';
import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/text_field/common_text_field.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/edit_company_profile_controller.dart';

class EditCompanyProfileScreen extends StatelessWidget {
  const EditCompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditCompanyProfileController());

    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: CommonAppbar(
            title: 'Edit Profile',
            textColor: AppColors.black,
            backgroundColor: AppColors.white,
            showBackButton: true,
            leading: const BackButton(color: AppColors.black),
          ),
          body: Obx(() {
            // Show loading indicator while fetching profile data
            if (controller.isLoadingProfile.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }
        
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cover Photo Section with Logo
                        _buildCoverPhotoSection(controller),
        
                        50.height,
        
                        // Form Fields
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Company Name Field
                              CommonText(
                                text: 'Company Name',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                                textAlign: TextAlign.start,
                              ),
                              8.height,
                              CommonTextField(
                                controller: controller.companyNameController,
                                hintText: 'Enter company name',
                                borderRadius: 8,
                                fillColor: AppColors.white,
                                borderColor: AppColors.borderColor,
                              ),
        
                              16.height,
        
                              // Overview Field
                              CommonText(
                                text: 'Overview',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                                textAlign: TextAlign.start,
                              ),
                              8.height,
                              CommonTextField(
                                controller: controller.overviewController,
                                hintText: 'Enter company overview',
                                maxLines: 4,
                                borderRadius: 8,
                                fillColor: AppColors.white,
                                borderColor: AppColors.borderColor,
                              ),
        
                              20.height,
        
                              // Gallery Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonText(
                                    text: 'Gallery',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                    textAlign: TextAlign.start,
                                  ),
                                  // Delete selected images button
                                  Obx(() {
                                    if (controller.selectedImageIndices.isEmpty) {
                                      return const SizedBox.shrink();
                                    }
                                    return GestureDetector(
                                      onTap: controller.deleteSelectedImages,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(6.r),
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              size: 16.sp,
                                              color: Colors.red,
                                            ),
                                            4.width,
                                            CommonText(
                                              text: 'Delete (${controller.selectedImageIndices.length})',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              12.height,
        
                              // Loading indicator for gallery
                              Obx(() {
                                if (controller.isLoadingImage.value) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20.h),
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  );
                                }
                                return _buildGallerySection(controller);
                              }),
        
                              20.height,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        
                // Update Button
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Obx(() => CommonButton(
                    titleText: controller.isLoadingUpdate.value
                        ? 'Updating...'
                        : 'Update',
                    onTap: controller.isLoadingUpdate.value
                        ? null
                        : controller.updateProfile,
                    buttonHeight: 48.h,
                    titleSize: 16,
                    titleWeight: FontWeight.w600,
                  )),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCoverPhotoSection(EditCompanyProfileController controller) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover Photo
        Obx(() {
          final coverPath = controller.coverPhotoPath.value;
          final isUrl = coverPath.startsWith('http');

          return GestureDetector(
            onTap: controller.pickCoverPhoto,
            child: Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(color: AppColors.filledColor),
              child: coverPath.isEmpty
                  ? CommonImage(
                imageSrc: AppImages.imageBackground,
                fill: BoxFit.cover,
                height: 180.h,
                width: double.infinity,
              )
                  : isUrl
                  ? CommonImage(
                imageSrc: coverPath,
                fill: BoxFit.cover,
                height: 180.h,
                width: double.infinity,
              )
                  : Image.file(
                File(coverPath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180.h,
              ),
            ),
          );
        }),

        // Edit Cover Photo Button
        Positioned(
          bottom: 12.h,
          right: 12.w,
          child: GestureDetector(
            onTap: controller.pickCoverPhoto,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit,
                    size: 14.sp,
                    color: AppColors.primaryColor,
                  ),
                  4.width,
                  CommonText(
                    text: 'Edit Cover Photo',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Company Logo
        Positioned(
          left: 0,
          right: 0,
          bottom: -40.h,
          child: Center(
            child: Obx(() {
              final logoPath = controller.companyLogoPath.value;
              final isUrl = logoPath.startsWith('http');

              return Stack(
                children: [
                  GestureDetector(
                    onTap: controller.pickCompanyLogo,
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.white,
                          width: 3.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: logoPath.isEmpty
                            ? CommonImage(
                          imageSrc: AppImages.companyLogo,
                          fill: BoxFit.cover,
                          width: 80.w,
                          height: 80.w,
                        )
                            : isUrl
                            ? CommonImage(
                          imageSrc: logoPath,
                          fill: BoxFit.cover,
                          width: 80.w,
                          height: 80.w,
                        )
                            : Image.file(
                          File(logoPath),
                          fit: BoxFit.cover,
                          width: 80.w,
                          height: 80.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.pickCompanyLogo,
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1.5.w,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildGallerySection(EditCompanyProfileController controller) {
    return Obx(
          () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1,
        ),
        itemCount: controller.galleryImages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddImageButton(controller);
          }
          return _buildGalleryImageItem(controller, index - 1);
        },
      ),
    );
  }

  Widget _buildAddImageButton(EditCompanyProfileController controller) {
    return GestureDetector(
      onTap: controller.addGalleryImage,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderColor, width: 1.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 24.sp, color: AppColors.borderColor),
            4.height,
            CommonText(
              text: 'Add',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryImageItem(
      EditCompanyProfileController controller,
      int index,
      ) {
    return Obx(() {
      final imagePath = controller.galleryImages[index];
      final isUrl = imagePath.startsWith('http');
      final isSelected = controller.isImageSelected(index);

      return GestureDetector(
        onTap: () => controller.toggleImageSelection(index),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.borderColor,
                  width: 2.w,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: isUrl
                    ? CommonImage(
                  imageSrc: imagePath,
                  fill: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
                    : Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            // Selection overlay
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                ),
              ),

            // Selection Badge
            if (isSelected)
              Positioned(
                top: 4.h,
                right: 4.w,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white,
                      width: 2.w,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 12.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}