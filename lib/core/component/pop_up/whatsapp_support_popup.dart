import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/app_utils.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/text_field/common_text_field.dart';

class WhatsappSupportPopup extends StatefulWidget {
  final VoidCallback? onSubmit;

  const WhatsappSupportPopup({super.key, this.onSubmit});

  @override
  State<WhatsappSupportPopup> createState() => _WhatsappSupportPopupState();
}

class _WhatsappSupportPopupState extends State<WhatsappSupportPopup> {
  final TextEditingController _linkController = TextEditingController();

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              CommonText(
                text: 'Add WhatsApp Link',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),

              SizedBox(height: 24.h),

              // Text Field
              CommonTextField(
                controller: _linkController,
                hintText: 'Enter Link',
                fillColor: AppColors.background,
                borderColor: AppColors.background,
                textColor: AppColors.black,
                hintTextColor: AppColors.textFiledColor,
                borderRadius: 12,
                paddingVertical: 16,
              ),

              SizedBox(height: 32.h),

              // Submit Button
              CommonButton(
                titleText: 'Submit',
                buttonHeight: 52,
                buttonRadius: 12,
                onTap: () {
                  if (_linkController.text.trim().isNotEmpty) {
                    Get.back();
                    if (widget.onSubmit != null) {
                      widget.onSubmit!();
                    }
                    Utils.successSnackBar(
                      'Success',
                      'WhatsApp link added successfully!',
                    );
                  } else {
                    Utils.errorSnackBar(
                      'Error',
                      'Please enter a valid WhatsApp link',
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
