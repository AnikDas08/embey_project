import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';

class JobDetailHeaderCard extends StatelessWidget {
  final String jobTitle;
  final String location;
  final bool isRemote;
  final int candidateCount;
  final String deadline;
  final String thumbnailImage;
  final List<String> userImages; // Added parameter for user avatars
  final VoidCallback onViewPost;
  final VoidCallback onRePost;
  final VoidCallback onDeletePost;
  final VoidCallback onSave;
  final bool isSaved;

  const JobDetailHeaderCard({
    super.key,
    required this.jobTitle,
    required this.location,
    required this.isRemote,
    required this.candidateCount,
    required this.deadline,
    required this.thumbnailImage,
    this.userImages = const [], // Default to empty list
    required this.onViewPost,
    required this.onRePost,
    required this.onDeletePost,
    required this.onSave,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                width: 84.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: Image.network(ApiEndPoint.imageUrl + thumbnailImage).image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              12.width,
              // Job Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Title
                    Text(
                      jobTitle,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.height,
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
                              color: AppColors.secondaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    4.height,
                    // Save and Remote
                    Row(
                      children: [
                        Icon(
                          isSaved ? Icons.star : Icons.star_border,
                          size: 14.sp,
                          color: AppColors.secondaryPrimary,
                        ),
                        4.width,
                        GestureDetector(
                          onTap: onSave,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryPrimary,
                            ),
                          ),
                        ),
                        16.width,
                        if (isRemote)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryButton.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Remote',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondaryButton,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          // Bottom Info
          Row(
            children: [
              // Candidate Count with Avatars
              Row(
                children: [
                  _buildUserAvatars(),
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
              const Spacer(),
              // Deadline
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
          12.height,
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'View Post',
                  icon: AppIcons.eye,
                  color: AppColors.success,
                  onTap: onViewPost,
                ),
              ),
              8.width,
              Expanded(
                child: _buildActionButton(
                  label: 'Re-Post',
                  icon: AppIcons.edit2,
                  color: AppColors.secondaryPrimary,
                  onTap: onRePost,
                ),
              ),
              8.width,
              Expanded(
                child: _buildActionButton(
                  label: 'Delete Post',
                  icon: AppIcons.delete,
                  color: AppColors.error,
                  onTap: onDeletePost,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatars() {
    // Maximum 4 avatars to display
    final displayCount = userImages.length > 4 ? 4 : userImages.length;

    // If no user images, show placeholder avatars
    if (userImages.isEmpty) {
      return SizedBox(
        width: 70.w,
        height: 24.h,
        child: Stack(
          children: List.generate(
            candidateCount > 4 ? 4 : candidateCount,
                (index) => Positioned(
              left: index * 14.w,
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: CommonImage(
                    imageSrc: AppImages.profile,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Show actual user images (max 4)
    return SizedBox(
      width: 70.w,
      height: 24.h,
      child: Stack(
        children: List.generate(
          displayCount,
              (index) => Positioned(
            left: index * 14.w,
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  ApiEndPoint.imageUrl + userImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to placeholder if image fails to load
                    return Container(
                      color: Colors.grey[300],
                      child: CommonImage(
                        imageSrc: AppImages.profile,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: SizedBox(
                          width: 12.w,
                          height: 12.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.secondaryPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImage(imageSrc: icon, size: 18.sp),
            4.width,
            CommonText(
              text: label,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}