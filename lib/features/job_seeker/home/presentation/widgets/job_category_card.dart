import 'package:cached_network_image/cached_network_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Job Category Card Widget
class JobCategoryCard extends StatelessWidget {
  final String imageSrc;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final int jobCount;
  final bool isJobCountVisible;

  const JobCategoryCard({
    super.key,
    required this.imageSrc,
    required this.title,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.jobCount = 0,
    this.isJobCountVisible = true,
  });

  Widget _buildIcon() {
    if (imageSrc.isEmpty) {
      return Icon(
        Icons.work_outline,
        size: 32.sp,
        color: iconColor ?? AppColors.primaryColor,
      );
    }

    if (imageSrc.startsWith('assets/')) {
      return Image.asset(
        imageSrc,
        width: 40.w,
        height: 40.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.work_outline,
          size: 32.sp,
          color: iconColor ?? AppColors.primaryColor,
        ),
      );
    }

    final fullUrl = imageSrc.startsWith('http://') || imageSrc.startsWith('https://')
        ? imageSrc
        : (imageSrc.startsWith('/') ? '${ApiEndPoint.imageUrl}$imageSrc' : '${ApiEndPoint.imageUrl}/$imageSrc');

    return CachedNetworkImage(
      imageUrl: fullUrl,
      width: 40.w,
      height: 40.h,
      fit: BoxFit.contain,
      placeholder: (context, url) => SizedBox(
        width: 40.w,
        height: 40.h,
        child: Center(
          child: SizedBox(
            width: 16.w,
            height: 16.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryColor.withOpacity(0.5),
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.work_outline,
        size: 32.sp,
        color: iconColor ?? AppColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            10.height,
            CommonText(
              text: title,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryText,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            if (isJobCountVisible)
              CommonText(
                text: '$jobCount Jobs',
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
