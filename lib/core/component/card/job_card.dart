import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobCard extends StatelessWidget {
  final String companyName;
  final String location;
  final String jobTitle;
  final String salaryRange;
  final String? timePosted;
  final bool isFullTime;
  final String companyLogo;
  final String? totalapply;
  final bool isApplied;
  final bool isSaved;
  final bool showFavoriteButton;
  final bool isRemote;
  final bool? isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  const JobCard({
    super.key,
    required this.companyName,
    required this.location,
    required this.jobTitle,
    required this.salaryRange,
    this.timePosted,
    required this.isFullTime,
    required this.companyLogo,
    this.totalapply,
    this.isApplied = false,
    this.isSaved = false,
    this.showFavoriteButton = true,
    this.isRemote = false,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: _buildCardDecoration(),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCompanyLogo(),
                12.width,
                Expanded(child: _buildJobDetails()),
              ],
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  ShapeDecoration _buildCardDecoration() {
    return ShapeDecoration(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Colors.white,
      shadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: 100.w,
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: AppColors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: CommonImage(imageSrc: companyLogo, fill: BoxFit.cover),
    );
  }

  Widget _buildJobDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildJobTitleRow(),
        6.height,
        _buildCompanyName(),
        8.height,
        _buildJobTypeTags(),
        10.height,
      ],
    );
  }

  Widget _buildJobTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildJobTitle()),
        if (showFavoriteButton) ...[8.width, _buildFavoriteButton()],
      ],
    );
  }

  Widget _buildJobTitle() {
    return Text(
      jobTitle,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: onFavoriteTap,
      child: Icon(
        isFavorite == true ? Icons.favorite : Icons.favorite_border,
        size: 24,
      )
    );
  }

  Widget _buildCompanyName() {
    return Text(
      companyName,
      style: TextStyle(
        color: AppColors.secondaryButton,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildJobTypeTags() {
    return Row(
      children: [
        _buildJobTypeTag(label: isFullTime ? 'Full Time' : 'Part Time'),
        8.width,
        _buildJobTypeTag(label: 'Hybrid'),
        if (isRemote) ...[8.width, _buildJobTypeTag(label: 'Remote')],
      ],
    );
  }

  Widget _buildJobTypeTag({required String label}) {
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
        CommonText(
          text: label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildLocationInfo()),
        8.width,
        _buildDateInfo(),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.black),
        4.width,
        Expanded(
          child: Text(
            location,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo() {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 12.sp,
          color: AppColors.secondaryPrimary,
        ),
        4.width,
        Text(
          timePosted ?? '01 Dec 25',
          style: TextStyle(
            color: AppColors.secondaryPrimary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
