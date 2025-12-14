import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../data/model/resume_model.dart';

class AddEducationDialog extends StatefulWidget {
  final Education? education; // If provided, it's edit mode
  final Function(Education) onSave;

  const AddEducationDialog({
    super.key,
    this.education,
    required this.onSave,
  });

  @override
  State<AddEducationDialog> createState() => _AddEducationDialogState();
}

class _AddEducationDialogState extends State<AddEducationDialog> {
  late TextEditingController degreeController;
  late TextEditingController institutionController;
  late TextEditingController gradeController;
  late TextEditingController passingYearController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if in edit mode
    degreeController = TextEditingController(
      text: widget.education?.degree ?? '',
    );
    institutionController = TextEditingController(
      text: widget.education?.institution ?? '',
    );
    gradeController = TextEditingController(
      text: widget.education?.grade ?? '',
    );
    passingYearController = TextEditingController(
      text: widget.education?.passingYear?.toString() ?? '',
    );
    startDateController = TextEditingController(
      text: widget.education?.startDate ?? '',
    );
    endDateController = TextEditingController(
      text: widget.education?.endDate ?? '',
    );
  }

  @override
  void dispose() {
    degreeController.dispose();
    institutionController.dispose();
    gradeController.dispose();
    passingYearController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  void _saveEducation() {
    // Validate required fields
    if (degreeController.text.trim().isEmpty) {
      _showError('Please enter degree name');
      return;
    }
    if (institutionController.text.trim().isEmpty) {
      _showError('Please enter institution name');
      return;
    }

    // Create Education object
    final education = Education(
      id: widget.education?.id ?? '', // Keep existing ID or empty for new
      degree: degreeController.text.trim(),
      institution: institutionController.text.trim(),
      grade: gradeController.text.trim().isEmpty
          ? null
          : gradeController.text.trim(),
      passingYear: passingYearController.text.trim().isEmpty
          ? null
          : int.tryParse(passingYearController.text.trim()),
      startDate: startDateController.text.trim().isEmpty
          ? null
          : startDateController.text.trim(),
      endDate: endDateController.text.trim().isEmpty
          ? null
          : endDateController.text.trim(),
    );

    widget.onSave(education);
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
        constraints: BoxConstraints(maxHeight: 600.h),
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
                    text: widget.education == null
                        ? 'Add Education'
                        : 'Edit Education',
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
                      _buildLabel('Degree Name *'),
                      8.height,
                      CommonTextField(
                        controller: degreeController,
                        hintText: 'e.g., Bachelor of Science',
                      ),
                      16.height,

                      _buildLabel('Institution Name *'),
                      8.height,
                      CommonTextField(
                        controller: institutionController,
                        hintText: 'e.g., USA University',
                      ),
                      16.height,

                      _buildLabel('Grade/CGPA'),
                      8.height,
                      CommonTextField(
                        controller: gradeController,
                        hintText: 'e.g., 3.8 or A',
                      ),
                      16.height,

                      _buildLabel('Passing Year'),
                      8.height,
                      CommonTextField(
                        controller: passingYearController,
                        hintText: 'e.g., 2024',
                        keyboardType: TextInputType.number,
                      ),
                      16.height,

                      _buildLabel('Start Date'),
                      8.height,
                      CommonTextField(
                        controller: startDateController,
                        hintText: 'e.g., Jan 2020',
                      ),
                      16.height,

                      _buildLabel('End Date'),
                      8.height,
                      CommonTextField(
                        controller: endDateController,
                        hintText: 'e.g., Dec 2024',
                      ),
                      8.height,

                      const CommonText(
                        text: '* Required fields',
                        fontSize: 12,
                        color: Colors.grey,
                        //fontStyle: FontStyle.italic,
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
                  onPressed: _saveEducation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: CommonText(
                    text: widget.education == null ? 'Add' : 'Update',
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