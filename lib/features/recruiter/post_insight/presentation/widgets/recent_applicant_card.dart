import 'package:embeyi/core/component/image/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';

class RecentApplicantCard extends StatelessWidget {
  final String name;
  final String jobTitle;
  final int matchPercentage;
  final String profileImage;
  final VoidCallback onTap;

  const RecentApplicantCard({
    super.key,
    required this.name,
    required this.jobTitle,
    required this.matchPercentage,
    required this.profileImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: [
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
            // Profile Image
            CommonImage(
                imageSrc: profileImage,
                width: 48.w,
                height: 48.h,

            ),
            12.width,
            // Candidate Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.height,
                  Text(
                    jobTitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            // Match Percentage
            Text(
              '$matchPercentage% Match',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: _getMatchColor(matchPercentage),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 85) {
      return const Color(0xFF008F37);
    } else if (percentage >= 70) {
      return const Color(0xFF7CB342);
    } else if (percentage >= 50) {
      return AppColors.secondaryPrimary;
    } else {
      return const Color(0xFFD32F2F);
    }
  }
}
