import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../data/model/resume_model.dart';

class AddCoreFeatureDialog extends StatefulWidget {
  final CoreFeature? feature;
  final Function(CoreFeature) onSave;

  const AddCoreFeatureDialog({
    super.key,
    this.feature,
    required this.onSave,
  });

  @override
  State<AddCoreFeatureDialog> createState() => _AddCoreFeatureDialogState();
}

class _AddCoreFeatureDialogState extends State<AddCoreFeatureDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: widget.feature?.title ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.feature?.description ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveFeature() {
    if (titleController.text.trim().isEmpty) {
      _showError('Please enter skills title');
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      _showError('Please enter description');
      return;
    }

    final feature = CoreFeature(
      id: widget.feature?.id ?? '',
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
    );

    widget.onSave(feature);
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 450.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: widget.feature == null
                        ? 'Add Core Skill'
                        : 'Edit Core Skill',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Skills Title *'),
                      8.height,
                      CommonTextField(
                        controller: titleController,
                        hintText: 'e.g., Database Administrator',
                      ),
                      16.height,

                      _buildLabel('Description *'),
                      8.height,
                      CommonTextField(
                        controller: descriptionController,
                        hintText: 'Describe the skill...',
                        maxLines: 6,
                      ),
                      8.height,

                      const CommonText(
                        text: '* Required fields',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Save Button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveFeature,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: CommonText(
                    text: widget.feature == null ? 'Add' : 'Update',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return CommonText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }
}