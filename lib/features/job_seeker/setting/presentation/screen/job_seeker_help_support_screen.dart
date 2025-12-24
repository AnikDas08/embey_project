import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_string.dart';
import '../controller/job_seeker_help.dart';

class JobSeekerHelpSupportScreen extends StatelessWidget {
  const JobSeekerHelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelpSupportController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: AppString.helpAndSupport,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: _bodySection(controller, context),
    );
  }

  /// Body Section starts here
  Widget _bodySection(HelpSupportController controller, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReasonField(controller),
          SizedBox(height: 16.h),
          _buildDescriptionField(controller),
          SizedBox(height: 16.h),
          _buildAttachFileSection(controller, context),
          SizedBox(height: 24.h),
          _buildSubmitButton(controller),
        ],
      ),
    );
  }

  /// Reason field
  Widget _buildReasonField(HelpSupportController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Reason',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
        SizedBox(height: 8.h),
        CommonTextField(
          controller: controller.reasonController,
          borderRadius: 8.r,
          hintText: 'Enter your Reason',
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppString.thisFieldIsRequired;
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Description field
  Widget _buildDescriptionField(HelpSupportController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Description',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
        SizedBox(height: 8.h),
        CommonTextField(
          controller: controller.descriptionController,
          hintText:
          'If you are having trouble to sign in with Account then you can Email us in Account Issues or Choosing Other Issue Regarding',
          textInputAction: TextInputAction.newline,
          maxLines: 6,
          keyboardType: TextInputType.multiline,
          borderRadius: 8.r,
        ),
      ],
    );
  }

  /// Attach file section
  Widget _buildAttachFileSection(
      HelpSupportController controller, BuildContext context) {
    return Obx(() {
      if (controller.attachedFile.value != null) {
        return _buildAttachedFilePreview(controller);
      }
      return _buildAttachFileButton(controller, context);
    });
  }

  /// Attach file button
  Widget _buildAttachFileButton(
      HelpSupportController controller, BuildContext context) {
    return InkWell(
      onTap: () => controller.showFilePickerOptions(context),
      borderRadius: BorderRadius.circular(11.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 109.w, vertical: 17.h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFFD1D5D6)),
            borderRadius: BorderRadius.circular(11),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1E000000),
              blurRadius: 50,
              offset: Offset(20, 20),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImage(imageSrc: AppIcons.attachment, width: 24, height: 24),
            8.width,
            CommonText(
              text: 'Attach File',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryText,
            ),
          ],
        ),
      ),
    );
  }

  /// Attached file preview
  Widget _buildAttachedFilePreview(HelpSupportController controller) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // File icon based on type
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              controller.fileType.value == 'image'
                  ? Icons.image
                  : Icons.insert_drive_file,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // File name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: controller.attachedFileName.value,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                CommonText(
                  text: controller.fileType.value == 'image'
                      ? 'Image File'
                      : 'Document File',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
          ),
          // Remove button
          IconButton(
            onPressed: controller.removeFile,
            icon: Icon(
              Icons.close,
              color: Colors.red,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// Submit button
  Widget _buildSubmitButton(HelpSupportController controller) {
    return Obx(() => CommonButton(
      titleText: controller.isLoading.value ? 'Submitting...' : 'Submit',
      buttonColor: controller.isLoading.value
          ? AppColors.primaryColor.withOpacity(0.6)
          : AppColors.primaryColor,
      onTap: controller.isLoading.value ? () {} : controller.submitHelpSupport,
    ));
  }
}