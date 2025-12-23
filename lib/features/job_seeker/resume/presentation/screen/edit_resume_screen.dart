import 'package:embeyi/core/config/route/app_routes.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/features/job_seeker/profile/presentation/screen/profile/edit_personal_info_screen.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/screen/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../../profile/presentation/screen/profile/personal_info_screen.dart';
import 'core_skills_screen.dart';
import 'work_experience_screen.dart';
import 'project_screen.dart';
import 'education_screen.dart';
import 'certification_screen.dart';

class EditResumeScreen extends StatelessWidget {
  final String resumeId;

  EditResumeScreen({super.key, required this.resumeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const CommonText(
          text: 'Edit Resume',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Edit Resume Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 21,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE6E6F2),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFF123499),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.edit_document,
                        color: AppColors.primary,
                        size: 32.sp,
                      ),
                      8.height,
                      const CommonText(
                        text: 'Edit Resume',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                24.height,

                /// Resume Section Title
                const CommonText(
                  text: 'Resume Section',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                16.height,

                /// Section List
                _buildSectionItem(
                  context,
                  icon: Icons.person,
                  iconColor: Colors.orange,
                  iconBgColor: Colors.orange.shade50,
                  title: 'Personal Info',
                  subtitle: 'Complete',
                  onTap: () async {
                    print("Navigating to Personal Info with Resume ID: $resumeId");
                    // Navigate to Personal Info screen and pass resumeId
                    /*final result = await Get.toNamed(
                      JobSeekerRoutes.editPersonalInfo,
                      arguments: resumeId,
                    );

                    // If Personal Info was updated successfully, pass result back
                    if (result == true) {
                      Get.back(result: true);
                    }*/
                    //Get.to(() => PersonalInfoScreen(), arguments: resumeId);
                    Get.to(()=>PersonalInfoScreenResume(resumeId: resumeId),arguments: resumeId);
                  },
                ),
                16.height,

                _buildSectionItem(
                  context,
                  icon: Icons.workspace_premium,
                  iconColor: Colors.blue,
                  iconBgColor: Colors.blue.shade50,
                  title: 'Core Skills & Experience',
                  subtitle: 'Complete',
                  onTap: () {
                    Get.to(()=>CoreSkillsScreen(),arguments: {
                      "resumeId": resumeId.toString(),
                      "personalInformation":{"name":""},
                      "resumeName":"".toString(),
                    });
                  },
                ),
                12.height,

                _buildSectionItem(
                  context,
                  icon: Icons.work,
                  iconColor: Colors.teal,
                  iconBgColor: Colors.teal.shade50,
                  title: 'Project',
                  subtitle: 'Complete',
                  onTap: () {
                    Get.to(() => ProjectScreen(), arguments: {
                      "resumeId": resumeId.toString(),
                    });
                  },
                ),
                16.height,

                _buildSectionItem(
                  context,
                  icon: Icons.school,
                  iconColor: Colors.blue,
                  iconBgColor: Colors.blue.shade50,
                  title: 'Education',
                  subtitle: 'Complete',
                  onTap: () {
                    Get.to(() => EducationScreenResume(), arguments: {
                      "resumeId": resumeId.toString(),
                    });
                  },
                ),
                16.height,

                _buildSectionItem(
                  context,
                  icon: Icons.card_membership,
                  iconColor: Colors.green,
                  iconBgColor: Colors.green.shade50,
                  title: 'Certification',
                  subtitle: 'Complete',
                  onTap: () {
                    Get.to(() => CertificationScreen(), arguments: {
                      "resumeId": resumeId.toString(),
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionItem(
      BuildContext context, {
        required IconData icon,
        required Color iconColor,
        required Color iconBgColor,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            /// Icon
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            16.width,

            /// Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  4.height,
                  CommonText(
                    text: subtitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),

            /// Arrow Icon
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24.sp),
          ],
        ),
      ),
    );
  }
}