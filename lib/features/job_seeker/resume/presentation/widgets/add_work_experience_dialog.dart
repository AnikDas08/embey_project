import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../data/model/resume_model.dart';

class AddWorkExperienceDialog extends StatefulWidget {
  final WorkExperience? experience;
  final Function(WorkExperience) onSave;

  const AddWorkExperienceDialog({
    super.key,
    this.experience,
    required this.onSave,
  });

  @override
  State<AddWorkExperienceDialog> createState() =>
      _AddWorkExperienceDialogState();
}

class _AddWorkExperienceDialogState extends State<AddWorkExperienceDialog> {
  late TextEditingController titleController;
  late TextEditingController companyController;
  late TextEditingController designationController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController descriptionController;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: widget.experience?.title ?? '',
    );
    companyController = TextEditingController(
      text: widget.experience?.company ?? '',
    );
    designationController = TextEditingController(
      text: widget.experience?.designation ?? '',
    );
    startDateController = TextEditingController(
      text: _formatDateForDisplay(widget.experience?.startDate),
    );
    endDateController = TextEditingController(
      text: _formatDateForDisplay(widget.experience?.endDate),
    );
    descriptionController = TextEditingController(
      text: widget.experience?.description ?? '',
    );

    // Parse existing dates if available
    if (widget.experience?.startDate != null) {
      try {
        _startDate = DateTime.parse(widget.experience!.startDate);
      } catch (e) {
        print('Error parsing start date: $e');
      }
    }
    if (widget.experience?.endDate != null &&
        widget.experience!.endDate.isNotEmpty) {
      try {
        _endDate = DateTime.parse(widget.experience!.endDate);
      } catch (e) {
        print('Error parsing end date: $e');
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    designationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String _formatDateForDisplay(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: DateTime(1970),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          startDateController.text = DateFormat('dd MMMM yyyy').format(picked);
        } else {
          _endDate = picked;
          endDateController.text = DateFormat('dd MMMM yyyy').format(picked);
        }
      });
    }
  }

  void _saveExperience() {
    if (titleController.text.trim().isEmpty) {
      _showError('Please enter job title');
      return;
    }
    if (companyController.text.trim().isEmpty) {
      _showError('Please enter company name');
      return;
    }
    if (designationController.text.trim().isEmpty) {
      _showError('Please enter designation');
      return;
    }
    if (_startDate == null) {
      _showError('Please select start date');
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      _showError('Please enter description');
      return;
    }

    final experience = WorkExperience(
      id: widget.experience?.id ?? '',
      title: titleController.text.trim(),
      company: companyController.text.trim(),
      designation: designationController.text.trim(),
      startDate: _startDate!.toIso8601String(),
      endDate: _endDate?.toIso8601String() ?? '',
      description: descriptionController.text.trim(),
    );

    widget.onSave(experience);
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
                    text: widget.experience == null
                        ? 'Add Experience'
                        : 'Edit Experience',
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
                      _buildLabel('Job Title *'),
                      8.height,
                      CommonTextField(
                        controller: titleController,
                        hintText: 'e.g., Backend Developer',
                      ),
                      16.height,

                      _buildLabel('Company Name *'),
                      8.height,
                      CommonTextField(
                        controller: companyController,
                        hintText: 'e.g., TechSoft Ltd',
                      ),
                      16.height,

                      _buildLabel('Designation *'),
                      8.height,
                      CommonTextField(
                        controller: designationController,
                        hintText: 'e.g., Administrator',
                      ),
                      16.height,

                      _buildLabel('Start Date *'),
                      8.height,
                      _buildDateField(
                        controller: startDateController,
                        hint: 'Select start date',
                        onTap: () => _selectDate(context, true),
                      ),
                      16.height,

                      _buildLabel('End Date (Optional)'),
                      8.height,
                      _buildDateField(
                        controller: endDateController,
                        hint: 'Select end date or leave blank',
                        onTap: () => _selectDate(context, false),
                      ),
                      16.height,

                      _buildLabel('Description *'),
                      8.height,
                      CommonTextField(
                        controller: descriptionController,
                        hintText: 'Describe your responsibilities...',
                        maxLines: 5,
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
                  onPressed: _saveExperience,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: CommonText(
                    text: widget.experience == null ? 'Add' : 'Update',
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

  Widget _buildDateField({
    required TextEditingController controller,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: CommonTextField(
          controller: controller,
          hintText: hint,
          suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
        ),
      ),
    );
  }
}