import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../controller/project_controller.dart';
import '../../data/model/resume_model.dart';
import '../widgets/add_project_dialog.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller - it will automatically fetch data in onInit
    final controller = Get.put(ProjectController());

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
          text: 'Project',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      body: Obx(() {
        // Show loading indicator while fetching data
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        // Show the form once data is loaded
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Project List
                        Obx(() {
                          if (controller.projects.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: const CommonText(
                                  text: 'No projects added yet',
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.projects.length,
                            separatorBuilder: (context, index) => 16.height,
                            itemBuilder: (context, index) {
                              final project = controller.projects[index];
                              return _buildProjectCard(
                                context,
                                project,
                                index,
                                controller,
                              );
                            },
                          );
                        }),

                        24.height,

                        // Add Other Project Button
                        GestureDetector(
                          onTap: () {
                            _showAddProjectDialog(context, controller);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              8.width,
                              const CommonText(
                                text: 'Add Other Project',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),

                        24.height,
                      ],
                    ),
                  ),
                ),
              ),

              /// Update Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : () => controller.saveProjects(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        disabledBackgroundColor:
                        AppColors.primary.withOpacity(0.6),
                      ),
                      child: controller.isSaving.value
                          ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const CommonText(
                        text: 'Update',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProjectCard(
      BuildContext context,
      Project project,
      int index,
      ProjectController controller,
      ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row with Add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'Project Title',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    4.height,
                    CommonText(
                      text: project.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              // Add button (shown as edit/delete for existing items)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showEditProjectDialog(
                          context,
                          controller,
                          project,
                          index,
                        );
                      },
                      child: const CommonText(
                        text: 'Edit',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    8.width,
                    GestureDetector(
                      onTap: () {
                        _showDeleteDialog(context, controller, index);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.height,

          // Description
          const CommonText(
            text: 'Description',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          4.height,
          CommonText(
            text: project.description,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            maxLines: 10,
          ),

          // Link (if available)
          if (project.link != null && project.link!.isNotEmpty) ...[
            16.height,
            const CommonText(
              text: 'Project Link',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            4.height,
            CommonText(
              text: project.link!,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }

  void _showAddProjectDialog(
      BuildContext context,
      ProjectController controller,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddProjectDialog(
        onSave: (project) {
          controller.addProject(project);
        },
      ),
    );
  }

  void _showEditProjectDialog(
      BuildContext context,
      ProjectController controller,
      Project project,
      int index,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddProjectDialog(
        project: project,
        onSave: (updatedProject) {
          controller.updateProject(index, updatedProject);
        },
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      ProjectController controller,
      int index,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CommonText(
            text: 'Delete Project',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          content: const CommonText(
            text: 'Are you sure you want to delete this project?',
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
                controller.removeProject(index);
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