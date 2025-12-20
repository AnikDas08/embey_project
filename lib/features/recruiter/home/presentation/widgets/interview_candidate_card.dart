import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';

class InterviewCandidateCard extends StatelessWidget {
  final String name;
  final String jobTitle;
  final String experience;
  final String scheduleTime;
  final String profileImage;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final bool isCompleted;

  const InterviewCandidateCard({
    super.key,
    required this.name,
    required this.jobTitle,
    required this.experience,
    required this.scheduleTime,
    required this.profileImage,
    required this.onTap,
    required this.onEdit,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                ApiEndPoint.imageUrl+profileImage,
                width: 87.w,
                height: 87.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/user.png');
                },
              ),
            ),
            12.width,
            // Candidate Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.height,
                  // Job Title
                  Text(
                    jobTitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  2.height,
                  // Experience
                  Text(
                    experience,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  8.height,
                  // Schedule Button
                  if (!isCompleted) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        scheduleTime,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                  if (isCompleted) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: CommonText(
                        text: 'Status: On Hold',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            8.width,
            // Edit Button
            if (!isCompleted) ...[
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  child: Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryColor,
                    size: 24.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
