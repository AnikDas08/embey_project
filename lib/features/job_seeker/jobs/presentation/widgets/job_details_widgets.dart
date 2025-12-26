import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

// Job Hero Card Widget - Green gradient card at the top
class JobHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? companyLogo;

  const JobHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.companyLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF006B3D), Color(0xFF00A859)],
        ),
      ),
      child: Stack(
        children: [
          // Background decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CommonText(
                            text: 'We are',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                          4.height,
                          CommonText(
                            text: title,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                          8.height,
                          CommonText(
                            text: subtitle,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    if (companyLogo != null) ...[
                      16.width,
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.flag_outlined,
                          color: AppColors.white,
                          size: 40.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Job Title Section Widget
class JobTitleSection extends StatelessWidget {
  final String jobTitle;
  final String location;
  final String salary;

  const JobTitleSection({
    super.key,
    required this.jobTitle,
    required this.location,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText(
          text: jobTitle,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
        8.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImage(imageSrc: AppIcons.location, size: 16.sp),
            4.width,
            CommonText(
              text: location,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryText,
            ),
          ],
        ),
        8.height,
        CommonText(
          text: "Salary: " + salary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
      ],
    );
  }
}

// Job Info Tags Widget
class JobInfoTags extends StatelessWidget {
  final bool isFullTime;
  final String experience;
  final String postedDate;
  final String endDate;

  const JobInfoTags({
    super.key,
    required this.isFullTime,
    required this.experience,
    required this.postedDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildInfoTag(isFullTime ? 'Full Time' : 'Part Time'),
        _buildInfoTag('Onsite'),
        _buildInfoTag(experience),
      ],
    );
  }

  Widget _buildInfoTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.secondaryButton.withOpacity(0.3)),
      ),
      child: CommonText(
        text: label,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryText,
      ),
    );
  }
}

// Job Dates Widget
class JobDatesWidget extends StatelessWidget {
  final String postedDate;
  final String endDate;

  const JobDatesWidget({
    super.key,
    required this.postedDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildDateItem('Posted', postedDate)),
        16.width,
        Expanded(child: _buildDateItem('End Date', endDate)),
      ],
    );
  }

  Widget _buildDateItem(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText(
          text: label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
        ),
        4.height,
        CommonText(
          text: date,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
      ],
    );
  }
}

// Company Info Card Widget
class CompanyInfoCard extends StatelessWidget {
  final String companyName;
  final String? companyLogo;
  final VoidCallback? onTap;

  const CompanyInfoCard({
    super.key,
    required this.companyName,
    this.companyLogo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: ShapeDecoration(
          color: const Color(0xFFEDF9FF),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: const Color(0xFFB0B3D8)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60.w,
              height: 35.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: companyLogo != null
                  ? CommonImage(imageSrc: companyLogo!, fill: BoxFit.contain)
                  : Icon(
                      Icons.business,
                      size: 35.sp,
                      color: AppColors.primaryColor,
                    ),
            ),

            Flexible(
              child: CommonText(
                text: companyName,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section Header Widget
class JobDetailsSectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const JobDetailsSectionHeader({
    super.key,
    required this.title,
    this.color = AppColors.success,
  });

  @override
  Widget build(BuildContext context) {
    return CommonText(
      text: title,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}

// Description Text Widget
class DescriptionText extends StatelessWidget {
  final String text;

  const DescriptionText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CommonText(
      text: text,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryText,
      textAlign: TextAlign.justify,
      maxLines: 100,
    );
  }
}

// Link Widget
class LinkWidget extends StatelessWidget {
  final String title;
  final String url;
  final IconData icon;

  const LinkWidget({
    super.key,
    required this.title,
    required this.url,
    this.icon = Icons.link,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: AppColors.secondaryButton),
            8.width,
            Expanded(
              child: CommonText(
                text: title,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryButton,
                maxLines: 1,
              ),
            ),
            Icon(
              Icons.open_in_new,
              size: 16.sp,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// Requirement Item Widget
class RequirementItem extends StatelessWidget {
  final String text;

  const RequirementItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 6.w,
            height: 6.h,
            decoration: const BoxDecoration(
              color: AppColors.secondaryButton,
              shape: BoxShape.circle,
            ),
          ),
          8.width,
          Expanded(
            child: CommonText(
              text: text,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryText,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
