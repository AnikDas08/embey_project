/*
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../../../resume/presentation/controller/edit_resume_controller.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller - it will automatically fetch data in onInit
    final controller = Get.put(PersonalInfoController());

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
          text: 'Personal Information',
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
                        _buildLabel('Resume Name'),
                        8.height,
                        CommonTextField(
                          controller: controller.resumeNameController,
                          hintText: 'Enter your resume name',
                          keyboardType: TextInputType.name,
                        ),
                        16.height,

                        _buildLabel('Full Name'),
                        8.height,
                        CommonTextField(
                          controller: controller.fullNameController,
                          hintText: 'Enter your full name',
                          keyboardType: TextInputType.name,
                        ),
                        16.height,

                        _buildLabel('Email'),
                        8.height,
                        CommonTextField(
                          controller: controller.emailController,
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        16.height,

                        _buildLabel('Mobile Number'),
                        8.height,
                        CommonTextField(
                          controller: controller.phoneController,
                          hintText: 'Enter your phone number',
                          keyboardType: TextInputType.phone,
                        ),
                        16.height,

                        _buildLabel('Address'),
                        8.height,
                        CommonTextField(
                          controller: controller.addressController,
                          hintText: 'Enter your address',
                          maxLines: 3,
                        ),
                        16.height,

                        _buildLabel('Social Media Link'),
                        8.height,
                        CommonTextField(
                          controller: controller.socialMediaController,
                          hintText: 'Enter your social media link',
                          keyboardType: TextInputType.url,
                        ),
                        16.height,

                        _buildLabel('Github Link'),
                        8.height,
                        CommonTextField(
                          controller: controller.githubController,
                          hintText: 'Enter your Github URL',
                          keyboardType: TextInputType.url,
                        ),
                        16.height,

                        _buildLabel('Work Authorization'),
                        8.height,
                        CommonTextField(
                          controller: controller.workAuthorizationController,
                          hintText: 'Enter your work authorization',
                        ),
                        16.height,

                        _buildLabel('Clearances'),
                        8.height,
                        CommonTextField(
                          controller: controller.clearancesController,
                          hintText: 'Enter your clearances',
                        ),
                        16.height,

                        _buildLabel('Open to Work'),
                        8.height,
                        CommonTextField(
                          controller: controller.openToWorkStatusController,
                          hintText: 'Select open to work',
                          readOnly: true,
                          suffixIcon: Icon(
                            Icons.arrow_drop_down,
                            size: 24.sp,
                            color: AppColors.primary,
                          ),
                          onTap: () {
                            _showOpenToWorkBottomSheet(context, controller);
                          },
                        ),
                        16.height,

                        _buildLabel('Summary'),
                        8.height,
                        CommonTextField(
                          controller: controller.summaryController,
                          hintText: 'Enter your summary',
                          maxLines: 4,
                        ),
                        16.height,
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
                      onPressed: controller.isUpdating.value
                          ? null
                          : () => controller.updatePersonalInfo(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                      ),
                      child: controller.isUpdating.value
                          ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const CommonText(
                        text: 'Update',
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

  Widget _buildLabel(String text) {
    return CommonText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
  }

  void _showOpenToWorkBottomSheet(
      BuildContext context,
      PersonalInfoController controller,
      ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              const CommonText(
                text: 'Select Work Preference',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              16.height,
              ListTile(
                leading: const Icon(Icons.home_work, color: AppColors.primary),
                title: const CommonText(text: 'Remote', fontSize: 16),
                onTap: () {
                  controller.setOpenToWorkStatus('Remote');
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.business, color: AppColors.primary),
                title: const CommonText(text: 'Onsite', fontSize: 16),
                onTap: () {
                  controller.setOpenToWorkStatus('Onsite');
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.compare_arrows, color: AppColors.primary),
                title: const CommonText(text: 'Hybrid', fontSize: 16),
                onTap: () {
                  controller.setOpenToWorkStatus('Hybrid');
                  Navigator.pop(context);
                },
              ),
              16.height,
            ],
          ),
        );
      },
    );
  }
}*/
