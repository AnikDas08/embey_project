import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/pop_up/success_dialog.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/text_field/common_text_field.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/core/utils/app_utils.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/constants/app_colors.dart';
import '../../utils/extensions/extension.dart';

class JobApplyPopup extends StatefulWidget {
  final String postId;
  final String jobTitle;
  final String companyName;
  final String companyLogo;
  final String location;
  final String deadline;
  final bool isFullTime;
  final bool isRemote;
  final String? companyDescription;
  final VoidCallback? onApply;
  const JobApplyPopup({
    super.key,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.deadline,
    this.isFullTime = true,
    this.isRemote = false,
    this.companyDescription,
    this.onApply,
    required this.postId,
  });

  @override
  State<JobApplyPopup> createState() => _JobApplyPopupState();
}

class _JobApplyPopupState extends State<JobApplyPopup> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _resumeFileName;
  String? _resumeFilePath;
  String? _coverLetterFileName;
  String? _coverLetterFilePath;

  @override
  void initState() {
    super.initState();
    _jobTitleController.text = widget.jobTitle;
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _resumeFileName = result.files.single.name;
          _resumeFilePath = result.files.single.path;
        });
      }
    } catch (e) {
      print('Error picking resume: $e');
    }
  }

  Future<void> _pickCoverLetter() async {
    // Show bottom sheet to choose between camera, gallery, and PDF
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText(
              text: 'Choose Option',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            20.height,
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: AppColors.primary),
              title: CommonText(
                text: 'Choose PDF',
                fontSize: 16.sp,
                color: AppColors.black,
                textAlign: TextAlign.start,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickCoverLetterPdf();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: CommonText(
                text: 'Take Photo',
                fontSize: 16.sp,
                color: AppColors.black,
                textAlign: TextAlign.start,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: CommonText(
                text: 'Choose from Gallery',
                fontSize: 16.sp,
                color: AppColors.black,
                textAlign: TextAlign.start,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _coverLetterFileName = image.name;
          _coverLetterFilePath = image.path;
        });
      }
    } catch (e) {
      print('Error picking image from camera: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _coverLetterFileName = image.name;
          _coverLetterFilePath = image.path;
        });
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  Future<void> _pickCoverLetterPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _coverLetterFileName = result.files.single.name;
          _coverLetterFilePath = result.files.single.path;
        });
      }
    } catch (e) {
      print('Error picking cover letter: $e');
    }
  }

  void _viewResume() {
    if (_resumeFilePath != null) {
      // TODO: Implement PDF viewer
      // You can use packages like flutter_pdfview or syncfusion_flutter_pdfviewer
      print('View resume: $_resumeFilePath');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening: $_resumeFileName')),
      );
    }
  }

  void _viewCoverLetter() {
    if (_coverLetterFilePath != null) {
      if (_coverLetterFileName!.toLowerCase().endsWith('.pdf')) {
        // TODO: Implement PDF viewer
        print('View PDF: $_coverLetterFilePath');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening: $_coverLetterFileName')),
        );
      } else {
        // Show image in dialog
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: _coverLetterFileName!,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Image.file(
                  File(_coverLetterFilePath!),
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      }
    }
  }

  void _removeResume() {
    setState(() {
      _resumeFileName = null;
      _resumeFilePath = null;
    });
  }

  void _removeCoverLetter() {
    setState(() {
      _coverLetterFileName = null;
      _coverLetterFilePath = null;
    });
  }

  void _submitApplication() async {
    // Validation
    if (_resumeFilePath == null) {
      Utils.errorSnackBar("Error", "Please upload your resume");
      return;
    }

    if (_experienceController.text.isEmpty) {
      Utils.errorSnackBar("Error", "Please enter years of experience");
      return;
    }

    try {
      // Prepare files list
      List<Map<String, String>> files = [
        {
          'name': 'resume',
          'image': _resumeFilePath!,
        },
      ];

      // Add cover letter if exists
      if (_coverLetterFilePath != null) {
        files.add({
          'name': 'doc',
          'image': _coverLetterFilePath!,
        });
      }

      final response = await ApiService.multipartImage(
        "application",
        method: "POST",
        body: {
          "post": widget.postId,
          "title": widget.jobTitle,
          "year_of_experience": _experienceController.text,
        },
        files: files,
      );

      if (response.statusCode == 200) {
        Utils.successSnackBar("Success", "Application submitted successfully");
        Navigator.pop(context);
        widget.onApply?.call();
      } else {
        Utils.errorSnackBar("Error", response.message.toString());
      }
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
    }
  }

  bool _isImageFile(String? fileName) {
    if (fileName == null) return false;
    final lowerCase = fileName.toLowerCase();
    return lowerCase.endsWith('.jpg') ||
        lowerCase.endsWith('.jpeg') ||
        lowerCase.endsWith('.png') ||
        lowerCase.endsWith('.gif');
  }

  bool _isPdfFile(String? fileName) {
    if (fileName == null) return false;
    return fileName.toLowerCase().endsWith('.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    _buildJobCard(),
                    _buildFormSection(),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(right: 12.w, top: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, size: 24.sp, color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 84.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: AppColors.cardBackground,
                ),
                clipBehavior: Clip.antiAlias,
                child: CommonImage(
                  imageSrc: widget.companyLogo,
                  fill: BoxFit.cover,
                ),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: widget.jobTitle,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                    4.height,
                    CommonText(
                      text: widget.companyName,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryButton,
                      textAlign: TextAlign.start,
                    ),
                    6.height,
                    Row(
                      children: [
                        if (widget.isFullTime) _buildJobTypeTag('Full Time'),
                        if (widget.isFullTime && widget.isRemote) 8.width,
                        if (widget.isRemote) _buildJobTypeTag('Remote'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CommonImage(imageSrc: AppIcons.location, size: 14.sp),
                    4.width,
                    Expanded(
                      child: CommonText(
                        text: widget.location,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              8.width,
              Row(
                children: [
                  CommonImage(imageSrc: AppIcons.calender, size: 16.sp),
                  4.width,
                  CommonText(
                    text: widget.deadline,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryPrimary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobTypeTag(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration: const BoxDecoration(
            color: AppColors.secondaryButton,
            shape: BoxShape.circle,
          ),
        ),
        4.width,
        CommonText(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Job Title'),
          8.height,
          CommonTextField(
            controller: _jobTitleController,
            hintText: 'UI/UX Designer',
            borderRadius: 8,
            paddingVertical: 12,
            fillColor: AppColors.white,
            borderColor: AppColors.borderColor,
          ),
          16.height,

          _buildFieldLabel('Years Of Experience'),
          8.height,
          CommonTextField(
            controller: _experienceController,
            hintText: '5 Years',
            borderRadius: 8,
            paddingVertical: 12,
            fillColor: AppColors.white,
            borderColor: AppColors.borderColor,
          ),
          16.height,

          _buildFieldLabel('Resume'),
          8.height,
          _buildFileUploadSection(
            fileName: _resumeFileName,
            filePath: _resumeFilePath,
            onTap: _pickResume,
            onRemove: _removeResume,
            onView: _viewResume,
            showPdfIcon: true,
            showViewIcon: true,
          ),
          16.height,

          _buildFieldLabel('Cover Letter'),
          8.height,
          _buildFileUploadSection(
            fileName: _coverLetterFileName,
            filePath: _coverLetterFilePath,
            onTap: _pickCoverLetter,
            onRemove: _removeCoverLetter,
            onView: _viewCoverLetter,
            showPdfIcon: true,
            showViewIcon: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return CommonText(
      text: label,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.black,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildFileUploadSection({
    String? fileName,
    String? filePath,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    VoidCallback? onView,
    bool showPdfIcon = false,
    bool showViewIcon = false,
  }) {
    final isImage = _isImageFile(fileName);
    final isPdf = _isPdfFile(fileName);

    return GestureDetector(
      onTap: fileName == null ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            if (fileName != null) ...[
              // File Icon or Image Preview
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: isImage
                      ? Colors.grey.shade200
                      : isPdf
                      ? Colors.red.shade50
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                clipBehavior: Clip.antiAlias,
                child: isImage && filePath != null
                    ? Image.file(
                  File(filePath),
                  fit: BoxFit.cover,
                )
                    : CommonImage(imageSrc: AppIcons.pdf, size: 20.sp),
              ),
              12.width,
              Expanded(
                child: CommonText(
                  text: fileName,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                ),
              ),
              if (showViewIcon && onView != null) ...[
                GestureDetector(
                  onTap: onView,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Icon(
                      Icons.visibility_outlined,
                      size: 20.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
              GestureDetector(
                onTap: onRemove,
                child: CommonImage(imageSrc: AppIcons.delete, size: 20.sp),
              ),
            ] else ...[
              Expanded(
                child: CommonText(
                  text: 'Upload File',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                  textAlign: TextAlign.start,
                ),
              ),
              if (showPdfIcon) ...[
                GestureDetector(
                  onTap: onTap,
                  child: CommonImage(imageSrc: AppIcons.pdf, size: 24.sp),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: CommonButton(
        titleText: 'Submit',
        onTap: _submitApplication,
        buttonRadius: 8,
        titleSize: 16,
        buttonHeight: 48.h,
      ),
    );
  }
}