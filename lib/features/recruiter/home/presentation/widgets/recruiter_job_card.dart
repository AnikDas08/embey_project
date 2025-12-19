import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';

class RecruiterJobCard extends StatelessWidget {
  final String jobTitle;
  final String location;
  final bool isFullTime;
  final bool isRemote;
  final List<String> userImages;
  final int candidateCount;
  final String deadline;
  final String thumbnailImage;
  final VoidCallback onTap;

  const RecruiterJobCard({
    super.key,
    required this.jobTitle,
    required this.location,
    required this.isFullTime,
    required this.isRemote,
    required this.candidateCount,
    required this.deadline,
    required this.userImages,
    required this.thumbnailImage,
    required this.onTap,
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
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Thumbnail
                Container(
                  width: 85.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: _buildThumbnailImage(),
                  ),
                ),
                12.width,
                // Job Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Title
                      Text(
                        jobTitle,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      6.height,
                      // Location
                      Row(
                        children: [
                          CommonImage(imageSrc: AppIcons.location, size: 14.sp),
                          4.width,
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      6.height,
                      // Job Type Tags
                      Row(
                        children: [
                          _buildJobTypeTag(
                            isFullTime ? 'Full Time' : 'Part Time',
                          ),
                          8.width,
                          _buildJobTypeTag('Remote'),
                        ],
                      ),
                      8.height,

                      // Bottom Info
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Candidate Count
                Row(
                  children: [
                    // Overlapping avatars
                    SizedBox(
                      width: 70.w,
                      height: 24.h,
                      child: Stack(
                        children: List.generate(
                          // Show up to 4 images
                          userImages.length > 4 ? 4 : userImages.length,
                              (index) => Positioned(
                            left: index * 14.w,
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                color: Colors.grey[200],
                              ),
                              child: ClipOval(
                                child: CommonImage(
                                  // Using your build image logic or a simple NetworkImage
                                  imageSrc: userImages[index].startsWith('http')
                                      ? userImages[index]
                                      : "https://shariful5001.binarybards.online${userImages[index]}",
                                  defaultImage: AppImages.profile,
                                  width: 24.w,
                                  height: 24.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    4.width,
                    Text(
                      '$candidateCount Candidate Applied',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
                // Deadline
                Row(
                  children: [
                    CommonImage(imageSrc: AppIcons.calender, size: 16.sp),
                    4.width,
                    CommonText(
                      text: deadline,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailImage() {
    // Check if it's a network image (starts with http)
    if (thumbnailImage.startsWith('http')) {
      return Image.network(
        thumbnailImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppImages.jobPost,
            fit: BoxFit.cover,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          );
        },
      );
    }

    // Check if it's a relative path from API (starts with /)
    if (thumbnailImage.startsWith('/')) {
      // You need to add your base URL here
      const String baseUrl = ApiEndPoint.imageUrl; // e.g., 'https://api.example.com'
      return Image.network(
        '$baseUrl$thumbnailImage',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppImages.jobPost,
            fit: BoxFit.cover,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          );
        },
      );
    }

    // Fallback to asset image
    return Image.asset(
      thumbnailImage.isEmpty ? AppImages.jobPost : thumbnailImage,
      fit: BoxFit.cover,
    );
  }

  Widget _buildJobTypeTag(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.h,
          decoration: const BoxDecoration(
            color: AppColors.secondaryButton,
            shape: BoxShape.circle,
          ),
        ),
        4.width,
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
