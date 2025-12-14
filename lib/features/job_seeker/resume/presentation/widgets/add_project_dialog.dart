import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../data/model/resume_model.dart';

class AddProjectDialog extends StatefulWidget {
  final Project? project; // If provided, it's edit mode
  final Function(Project) onSave;

  const AddProjectDialog({
    super.key,
    this.project,
    required this.onSave,
  });

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController linkController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if in edit mode
    titleController = TextEditingController(
      text: widget.project?.title ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.project?.description ?? '',
    );
    linkController = TextEditingController(
      text: widget.project?.link ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void _saveProject() {
    // Validate required fields
    if (titleController.text.trim().isEmpty) {
      _showError('Please enter project title');
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      _showError('Please enter project description');
      return;
    }

    // Create Project object
    final project = Project(
      id: widget.project?.id ?? '', // Keep existing ID or empty for new
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      link: linkController.text.trim().isEmpty
          ? null
          : linkController.text.trim(),
    );

    widget.onSave(project);
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
        constraints: BoxConstraints(maxHeight: 500.h),
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
                    text: widget.project == null
                        ? 'Add Project'
                        : 'Edit Project',
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
                      _buildLabel('Project Title *'),
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
                        hintText: 'Describe your project...',
                        maxLines: 5,
                      ),
                      16.height,

                      _buildLabel('Project Link (Optional)'),
                      8.height,
                      CommonTextField(
                        controller: linkController,
                        hintText: 'e.g., https://github.com/username/project',
                        keyboardType: TextInputType.url,
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
                  onPressed: _saveProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: CommonText(
                    text: widget.project == null ? 'Add' : 'Update',
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