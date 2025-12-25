import 'package:embeyi/features/job_seeker/home/presentation/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:get/get.dart';

class AutoApply extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const AutoApply({
    super.key,
    required this.isEnabled,
    required this.onToggle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: 'Auto Apply',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              CommonText(
                text: 'Let the AI apply for you',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryText,
              ),
            ],
          ),
          // Using Transform.scale to make the switch look cleaner
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isEnabled,
              activeColor: AppColors.white,
              activeTrackColor: AppColors.primaryColor,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: Colors.grey.shade300,
              onChanged: onToggle,
            ),
          ),
        ],
      ),
    );
  }
}
