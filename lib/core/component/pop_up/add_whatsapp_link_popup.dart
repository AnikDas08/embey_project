import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/app_utils.dart';

class AddWhatsappLinkPopup extends StatefulWidget {
  final String? currentLink;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddWhatsappLinkPopup({
    super.key,
    this.currentLink,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<AddWhatsappLinkPopup> createState() => _AddWhatsappLinkPopupState();
}

class _AddWhatsappLinkPopupState extends State<AddWhatsappLinkPopup> {
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
              // Header with title and action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: 'Your WhatsApp Link',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  Row(
                    children: [
                      // Edit Icon
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          if (widget.onEdit != null) {
                            widget.onEdit!();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.edit,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Delete Icon
                      GestureDetector(
                        onTap: () {
                          _showDeleteConfirmation();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.delete_outline,
                            color: AppColors.red,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // WhatsApp Link Display Container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.textFiledColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: CommonText(
                  text: widget.currentLink ?? 'https://wa.me/1234567890',
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w400,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(height: 24.h),

              // Add/Change Button
              CommonButton(
                titleText: 'Add/Change',
                buttonHeight: 52,
                buttonRadius: 12,
                onTap: () {
                  Get.back();
                  if (widget.onEdit != null) {
                    widget.onEdit!();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: CommonText(
          text: 'Delete WhatsApp Link',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        content: CommonText(
          text: 'Are you sure you want to delete this WhatsApp link?',
          fontSize: 14,
          color: AppColors.blueLight,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(
              text: 'Cancel',
              fontSize: 14,
              color: AppColors.blueLight,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close confirmation dialog
              Get.back(); // Close main popup
              if (widget.onDelete != null) {
                widget.onDelete!();
              }
              Utils.successSnackBar(
                'Success',
                'WhatsApp link deleted successfully!',
              );
            },
            child: CommonText(
              text: 'Delete',
              fontSize: 14,
              color: AppColors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
