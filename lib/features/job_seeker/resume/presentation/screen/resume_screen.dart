import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/controller/resume_controller.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/screen/add_resume_screen.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/screen/view_resume_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../data/model/resume_model.dart';
import 'edit_resume_screen.dart';

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResumeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CommonText(
          text: 'My Resume',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Update the Expanded widget in your ResumeScreen build method:

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.resumes.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: Colors.red,
                        ),
                        16.height,
                        CommonText(
                          text: controller.errorMessage.value,
                          fontSize: 14,
                          color: Colors.red,
                          textAlign: TextAlign.center,
                        ),
                        16.height,
                        ElevatedButton(
                          onPressed: () => controller.fetchResumes(isRefresh: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const CommonText(
                            text: 'Retry',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.resumes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        16.height,
                        const CommonText(
                          text: 'No resumes found',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        8.height,
                        const CommonText(
                          text: 'Create your first resume',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchResumes(isRefresh: true),
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    controller: controller.scrollController, // Add scroll controller
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Resume List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.resumes.length,
                            separatorBuilder: (context, index) => 12.height,
                            itemBuilder: (context, index) {
                              final resume = controller.resumes[index];
                              return _buildResumeCard(
                                context,
                                controller,
                                resume,
                              );
                            },
                          ),

                          /// Loading More Indicator
                          if (controller.isLoadingMore.value)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),

                          /*/// End of List Indicator
                          if (!controller.hasMoreData.value && controller.resumes.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Center(
                                child: CommonText(
                                  text: 'No more resumes (${controller.resumes.length}/${controller.totalItems.value})',
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),*/
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            /// Add New Resume Button at Bottom
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddResumeScreen(resumeId: ""),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 20.sp),
                            8.width,
                            const CommonText(
                              text: 'Add New Resume',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showUploadResumeDialog(context, controller);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, size: 20.sp),
                            8.width,
                            const CommonText(
                              text: 'Upload Resume',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Upload Resume Dialog
  void _showUploadResumeDialog(BuildContext context, ResumeController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Obx(() {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CommonText(
                        text: 'Upload Resume',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          controller.clearPdfSelection();
                          Navigator.pop(dialogContext);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  20.height,

                  // Resume Name Field
                  const CommonText(
                    text: 'Resume Name',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  8.height,
                  TextField(
                    controller: controller.resumeNameTextController,
                    decoration: InputDecoration(
                      hintText: 'Enter resume name',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  20.height,

                  // Upload PDF Button
                  const CommonText(
                    text: 'Upload PDF',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  8.height,
                  InkWell(
                    onTap: controller.isUpdating.value ? null : controller.pickPDF,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.selectedPdfFile.value != null
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        color: controller.selectedPdfFile.value != null
                            ? AppColors.primary.withOpacity(0.05)
                            : Colors.grey.shade50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.selectedPdfFile.value != null
                                ? Icons.picture_as_pdf
                                : Icons.upload_file,
                            color: controller.selectedPdfFile.value != null
                                ? AppColors.primary
                                : Colors.grey.shade600,
                            size: 24.sp,
                          ),
                          12.width,
                          Expanded(
                            child: CommonText(
                              text: controller.selectedFileName.value.isEmpty
                                  ? 'Choose PDF file'
                                  : controller.selectedFileName.value,
                              fontSize: 14,
                              fontWeight: controller.selectedPdfFile.value != null
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: controller.selectedPdfFile.value != null
                                  ? AppColors.primary
                                  : Colors.grey.shade600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  24.height,

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isUpdating.value
                          ? null
                          : () => controller.postExternalResume(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: controller.isUpdating.value
                          ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const CommonText(
                        text: 'Submit',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // Open PDF in viewer
  Future<void> _openPdfViewer(String pdfUrl) async {
    try {
      final Uri url = Uri.parse(ApiEndPoint.imageUrl+pdfUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );


      } else {
        Get.snackbar(
          'Error',
          'Could not open PDF file',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildResumeCard(
      BuildContext context,
      ResumeController controller,
      Resume resume,
      ) {
    // Check if this is an external resume
    final isExternalResume = resume.is_external_resume ?? false;

    return GestureDetector(
      onTap: () {
        if (isExternalResume) {
          // Open PDF if it's an external resume
          if (resume.pdf != null && resume.pdf!.isNotEmpty) {
            _openPdfViewer(resume.pdf!);
          } else {
            Get.snackbar(
              'Error',
              'Resume file not found',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          // Navigate to view resume screen for internal resume
          Get.to(ViewResumeScreen(resumeId: resume.id));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            /// Document Icon
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isExternalResume
                    ? Colors.blue.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                isExternalResume ? Icons.picture_as_pdf : Icons.description,
                color: isExternalResume ? Colors.blue : Colors.orange,
                size: 28.sp,
              ),
            ),
            16.width,

            /// Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: resume.resumeName,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  4.height,
                  CommonText(
                    text: isExternalResume
                        ? 'External Resume - Tap to view PDF'
                        : controller.getResumeSubtitle(resume),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            8.width,

            /// Edit Icon - Only show if NOT external resume
            if (!isExternalResume) ...[
              InkWell(
                onTap: () {
                  Get.to(
                    EditResumeScreen(resumeId: resume.id),
                    arguments: resume.id,
                  );
                },
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: CommonImage(
                    imageSrc: AppIcons.edit,
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
              4.width,
            ],

            /// Delete Icon
            InkWell(
              onTap: () {
                _showDeleteDialog(context, controller, resume);
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: CommonImage(
                  imageSrc: AppIcons.delete,
                  width: 18,
                  height: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      ResumeController controller,
      Resume resume,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CommonText(
            text: 'Delete Resume',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          content: CommonText(
            text: 'Are you sure you want to delete "${resume.resumeName}"?',
            fontSize: 14,
            maxLines: 2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const CommonText(
                text: 'Cancel',
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.deleteResume(resume.id);
              },
              child: const CommonText(
                text: 'Delete',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}