import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/controller/resume_controller.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/screen/add_resume_screen.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/screen/view_resume_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
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
                          onPressed: () => controller.fetchResumes(),
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
                  onRefresh: () => controller.fetchResumes(),
                  color: AppColors.primary,
                  child: SingleChildScrollView(
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
                        fontSize: 16,
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
    );
  }

  Widget _buildResumeCard(
      BuildContext context,
      ResumeController controller,
      Resume resume,
      ) {
    return GestureDetector(
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewResumeScreen(resumeId: resume.id),
          ),
        );*/
        Get.to(ViewResumeScreen(resumeId: resume.id));
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
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.description, color: Colors.orange, size: 28.sp),
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
                    text: controller.getResumeSubtitle(resume),
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

            /// Edit Icon
            InkWell(
              onTap: () {
                print("resume 😍😍😍😍${resume.id}");
                Get.to(
                  EditResumeScreen(resumeId: resume.id),arguments: resume.id,
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