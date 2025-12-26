import 'package:embeyi/features/job_seeker/resume/presentation/controller/view_resume_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../data/model/resume_model.dart';
import '../widgets/pdf_show.dart';

class ViewResumeScreen extends StatelessWidget {
  final String resumeId;

  const ViewResumeScreen({super.key, required this.resumeId});

  @override
  Widget build(BuildContext context) {
    // Pass resumeId to controller using Get.put with a unique tag
    final controller = Get.put(
      ViewResumeController(resumeId: resumeId),
      tag: resumeId,
    );

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
          text: 'View Resume',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoadingDetails.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        // Show error if any
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
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
                    color: Colors.red,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                  ),
                  24.height,
                  ElevatedButton(
                    onPressed: () => controller.fetchResumeById(resumeId),
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
            ),
          );
        }

        // Check if resume is loaded
        if (controller.currentResume.value == null) {
          return const Center(
            child: CommonText(text: 'No resume found'),
          );
        }

        final resume = controller.currentResume.value!;

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Header Section - Name and Contact
                        _buildHeaderSection(resume),

                        /// Work Authorization and Preferences
                        _buildWorkAuthSection(resume),
                        8.height,

                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        8.height,

                        /// Summary Section
                        if (resume.personalInfo.summary.isNotEmpty)
                          _buildSummarySection(resume.personalInfo.summary),
                        18.height,

                        /// Core Skills Section
                        if (resume.coreFeatures.isNotEmpty)
                          _buildCoreSkillsSection(resume.coreFeatures),
                        16.height,

                        /// Experience Section
                        if (resume.workExperiences.isNotEmpty)
                          _buildExperienceSection(resume.workExperiences),
                        16.height,

                        /// Selected Projects Section
                        if (resume.projects.isNotEmpty)
                          _buildProjectsSection(resume.projects),
                        16.height,

                        /// Education and Certifications Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Education Section
                            if (resume.educations.isNotEmpty)
                              Expanded(
                                child: _buildEducationSection(resume.educations),
                              ),

                            if (resume.educations.isNotEmpty &&
                                resume.certifications.isNotEmpty)
                              12.width,

                            /// Certifications Section
                            if (resume.certifications.isNotEmpty)
                              Expanded(
                                child: _buildCertificationsSection(resume.certifications),
                              ),
                          ],
                        ),

                        24.height,
                      ],
                    ),
                  ),
                ),
              ),

              /// Download Button
              _buildDownloadButton(resume),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDownloadButton(Resume resume) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Show loading dialog
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
                barrierDismissible: false,
              );

              // Generate and download PDF
              await PdfDownloadHelper.downloadResumePdf(resume);

              // Close loading dialog
              Get.back();

              // Show success message
              Get.snackbar(
                'Success',
                'Resume downloaded successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            } catch (e) {
              // Close loading dialog if open
              if (Get.isDialogOpen ?? false) {
                Get.back();
              }

              // Show error message
              Get.snackbar(
                'Error',
                'Failed to download resume: $e',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: const CommonText(
            text: 'Download',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Resume resume) {
    return Column(
      children: [
        CommonText(
          text: resume.personalInfo.fullName,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        8.height,
        Wrap(
          spacing: 12.w,
          runSpacing: 4.h,
          alignment: WrapAlignment.center,
          children: [
            if (resume.personalInfo.phone.isNotEmpty)
              _buildContactChip(Icons.phone, resume.personalInfo.phone),
            if (resume.personalInfo.email.isNotEmpty)
              _buildContactChip(Icons.email, resume.personalInfo.email),
            if (resume.personalInfo.socialMediaLink.isNotEmpty)
              _buildContactChip(Icons.link, resume.personalInfo.socialMediaLink),
            if (resume.personalInfo.githubLink.isNotEmpty)
              _buildContactChip(Icons.code, 'GitHub'),
          ],
        ),
      ],
    );
  }

  Widget _buildContactChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 7.sp, color: Colors.black87),
          4.width,
          CommonText(
            text: text,
            fontSize: 7.sp,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkAuthSection(Resume resume) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (resume.personalInfo.workAuthorization.isNotEmpty)
            Expanded(
              child: _buildInfoItem(
                'Work Authorization',
                resume.personalInfo.workAuthorization,
              ),
            ),
          if (resume.personalInfo.clearance.isNotEmpty)
            Expanded(
              child: _buildInfoItem(
                'Clearance',
                resume.personalInfo.clearance,
              ),
            ),
          if (resume.personalInfo.openToWork.isNotEmpty)
            Expanded(
              child: _buildInfoItem(
                'Open To Remote',
                resume.personalInfo.openToWork,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        2.width,
        CommonText(
          text: value,
          fontSize: 7.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildSummarySection(String summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('SUMMARY', Icons.person),
        8.height,
        CommonText(
          text: summary,
          fontSize: 11,
          color: Colors.black87,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildCoreSkillsSection(List<CoreFeature> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('CORE SKILLS', Icons.stars),
        8.height,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          separatorBuilder: (context, index) => 12.height,
          itemBuilder: (context, index) {
            final feature = features[index];
            return _buildSkillItem(feature.title, feature.description);
          },
        ),
      ],
    );
  }

  Widget _buildSkillItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: title,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        4.height,
        CommonText(
          text: description,
          fontSize: 10,
          color: Colors.black87,
          maxLines: 10,
        ),
      ],
    );
  }

  Widget _buildExperienceSection(List<WorkExperience> experiences) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('EXPERIENCE', Icons.work),
        8.height,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: experiences.length,
          separatorBuilder: (context, index) => 16.height,
          itemBuilder: (context, index) {
            final exp = experiences[index];
            return _buildExperienceItem(exp);
          },
        ),
      ],
    );
  }

  Widget _buildExperienceItem(WorkExperience exp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: exp.title,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            CommonText(
              text: _formatDateRange(exp.startDate, exp.endDate),
              fontSize: 9,
              color: Colors.grey.shade600,
            ),
          ],
        ),
        4.height,
        CommonText(
          text: exp.company,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          maxLines: 10,
        ),
        if (exp.location != null && exp.location!.isNotEmpty) ...[
          2.height,
          CommonText(
            text: exp.location!,
            fontSize: 9,
            color: Colors.grey.shade600,
          ),
        ],
        8.height,
        CommonText(
          text: exp.description,
          fontSize: 10,
          color: Colors.black87,
          textAlign: TextAlign.justify,
          maxLines: 10,
        ),
      ],
    );
  }

  Widget _buildProjectsSection(List<Project> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('SELECTED PROJECTS', Icons.folder),
        8.height,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.85,
          ),
          itemCount: projects.length > 6 ? 6 : projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(project);
          },
        ),
      ],
    );
  }

  Widget _buildProjectCard(Project project) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: project.title,
            fontSize: 8.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            maxLines: 4,
          ),
          4.height,
          Expanded(
            child: CommonText(
              text: project.description,
              fontSize: 7.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              maxLines: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection(List<Education> educations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('EDUCATION', Icons.school, iconSize: 14),
        8.height,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: educations.length,
          separatorBuilder: (context, index) => 10.height,
          itemBuilder: (context, index) {
            final edu = educations[index];
            return _buildEducationItem(edu);
          },
        ),
      ],
    );
  }

  Widget _buildEducationItem(Education edu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (edu.degree.isNotEmpty)
          CommonText(
            text: edu.degree,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        if (edu.institution.isNotEmpty) ...[
          2.height,
          CommonText(
            text: edu.institution,
            fontSize: 9,
            color: Colors.black87,
          ),
        ],
        if (edu.passingYear != null) ...[
          2.height,
          CommonText(
            text: 'Year: ${edu.passingYear}',
            fontSize: 8,
            color: Colors.grey.shade600,
          ),
        ],
      ],
    );
  }

  Widget _buildCertificationsSection(List<Certification> certifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('CERTIFICATIONS', Icons.verified, iconSize: 14),
        8.height,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: certifications.length,
          separatorBuilder: (context, index) => 10.height,
          itemBuilder: (context, index) {
            final cert = certifications[index];
            return _buildCertificationItem(cert);
          },
        ),
      ],
    );
  }

  Widget _buildCertificationItem(Certification cert) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: '• ${cert.title}',
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        if (cert.description.isNotEmpty) ...[
          2.height,
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: CommonText(
              text: cert.description,
              fontSize: 8,
              color: Colors.black87,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {double? iconSize}) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize ?? 16.sp,
          color: AppColors.primary,
        ),
        8.width,
        CommonText(
          text: title,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ],
    );
  }

  String _formatDateRange(String? startDate, String? endDate) {
    if (startDate == null || endDate == null) return '';

    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];

      return '${months[start.month - 1]} ${start.year} - ${months[end.month - 1]} ${end.year}';
    } catch (e) {
      return '';
    }
  }
}