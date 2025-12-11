import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/image/common_image.dart';

class ProfileSection extends StatelessWidget {
  final String name;
  final String designation;
  final String imagePath;
  final bool showEditIcon;
  final VoidCallback? onEditTap;

  const ProfileSection({
    super.key,
    required this.name,
    required this.designation,
    required this.imagePath,
    this.showEditIcon = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfileImage(),
        SizedBox(height: 16.h),
        _buildName(),
        SizedBox(height: 4.h),
        _buildDesignation(),
      ],
    );
  }

  Widget _buildProfileImage() {
    Widget profileImage = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 50.r,
        backgroundColor: const Color(0xFF1A2B8F),
        child: ClipOval(
          child: CommonImage(
            imageSrc: imagePath,
            size: 100.r,
            fill: BoxFit.cover,
            borderRadius: 50.r,
          ),
        ),
      ),
    );

    if (showEditIcon) {
      return Stack(
        children: [
          profileImage,
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2.w),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return profileImage;
  }

  Widget _buildName() {
    return CommonText(
      text: name,
      fontWeight: FontWeight.w600,
      fontSize: 20.sp,
      color: AppColors.black,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDesignation() {
    return CommonText(
      text: designation,
      fontWeight: FontWeight.w400,
      fontSize: 14.sp,
      color: AppColors.secondaryText,
      textAlign: TextAlign.center,
    );
  }
}
