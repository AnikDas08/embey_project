import 'package:embeyi/features/job_seeker/home/presentation/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:get/get.dart';

class AutoApply extends StatelessWidget {
  const AutoApply({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: 'Auto Apply',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                CommonText(
                  text: 'Let the ai apply for You',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
            Switch(
              value: false,
              activeColor: AppColors.white,
              inactiveTrackColor: AppColors.grey,
              inactiveThumbColor: AppColors.black,
              activeTrackColor: AppColors.primaryColor,
              onChanged: (value) {
                // Handle switch change
              },
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
