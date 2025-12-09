import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/work_experinece_employee_controller.dart';
import 'add_work_experience_screen.dart';
import 'edit_work_experience_screen.dart';

class WorkExperienceScreen extends StatelessWidget {
  const WorkExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkExperienceController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CommonText(
          text: 'Work Experience',
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: AppColors.black,
        ),
      ),
      body: SafeArea(
        child: GetBuilder<WorkExperienceController>(
          builder: (controller) {
            if (controller.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (controller.workExperienceList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.work_outline,
                                size: 80.sp,
                                color: AppColors.grey,
                              ),
                              SizedBox(height: 16.h),
                              CommonText(
                                text: 'No work experience added yet',
                                fontSize: 16.sp,
                                color: AppColors.grey,
                              ),
                              SizedBox(height: 8.h),
                              CommonText(
                                text: 'Add your professional experience',
                                fontSize: 14.sp,
                                color: AppColors.secondaryText,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        itemCount: controller.workExperienceList.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final workExp = controller.workExperienceList[index];
                          return _buildWorkExperienceCard(
                            context: context,
                            controller: controller,
                            title: workExp.title ?? 'N/A',
                            company: workExp.company ?? 'N/A',
                            startDate: workExp.startDate,
                            endDate: workExp.endDate,
                            isCurrentJob: workExp.isCurrentJob ?? false,
                            description: workExp.description ?? '',
                            location: workExp.location ?? '',
                            workExpId: workExp.id ?? '',
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditWorkExperienceScreen(
                                    workExperience: workExp,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
                  ),
                  CommonButton(
                    titleText: 'Add Work Experience',
                    titleSize: 16.sp,
                    titleWeight: FontWeight.w600,
                    buttonHeight: 52.h,
                    buttonRadius: 12.r,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddWorkExperienceScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWorkExperienceCard({
    required BuildContext context,
    required WorkExperienceController controller,
    required String title,
    required String company,
    String? startDate,
    String? endDate,
    required bool isCurrentJob,
    required String description,
    required String location,
    required String workExpId,
    required VoidCallback onEdit,
  }) {
    // Format dates
    String dateRange = '';
    if (startDate != null) {
      try {
        DateTime start = DateTime.parse(startDate);
        String startFormatted = DateFormat('MMM yyyy').format(start);

        if (isCurrentJob) {
          dateRange = '$startFormatted - Present';
        } else if (endDate != null) {
          DateTime end = DateTime.parse(endDate);
          String endFormatted = DateFormat('MMM yyyy').format(end);
          dateRange = '$startFormatted - $endFormatted';
        } else {
          dateRange = startFormatted;
        }
      } catch (e) {
        dateRange = 'Date not available';
      }
    }

    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CommonText(
                    text: title,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColors.black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: CommonImage(
                        imageSrc: AppIcons.edit,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => _showDeleteDialog(context, controller, workExpId),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.h),
            CommonText(
              text: company,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.secondaryText),
                SizedBox(width: 4.w),
                CommonText(
                  text: location,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 14.sp, color: AppColors.secondaryText),
                SizedBox(width: 4.w),
                CommonText(
                  text: dateRange,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: AppColors.secondaryText,
                ),
                if (isCurrentJob) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: CommonText(
                      text: 'Current',
                      fontSize: 10.sp,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            if (description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              CommonText(
                text: description,
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: AppColors.secondaryText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WorkExperienceController controller, String workExpId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Work Experience'),
          content: Text('Are you sure you want to delete this work experience?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.deleteWorkExperience(workExpId);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}