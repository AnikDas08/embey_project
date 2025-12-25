import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/job_seeker/home/presentation/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../notifications/presentation/screen/job_seeker_notifications_screen.dart';

// Home Header Widget
class HomeHeader extends StatelessWidget {
  final String profileImage;
  final String userName;
  final String userRole;
  final bool hasNotification;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    required this.profileImage,
    required this.userName,
    required this.userRole,
    this.onNotificationTap,
    this.onMessageTap,
    this.onProfileTap,
    required this.hasNotification,
  });

  @override
  Widget build(BuildContext context) {
    HomeController controller=Get.put(HomeController());
    return Row(
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: SizedBox(
            height: 48.h,
            width: 48.w,
            child: ClipOval(
              child: Obx(
                    () {
                  final imagePath = controller.image.value;

                  final imageUrl = imagePath.startsWith('http')
                      ? imagePath
                      : ApiEndPoint.imageUrl + imagePath;

                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                          Icons.person,
                          size: 24.sp,
                          color: AppColors.primaryColor,
                      );
                    },
                  );
                },
              ),

            ),
          ),
            ),
        12.width,
        Expanded(
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
    ()=> CommonText(
                      text: controller.name.value,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                ),
                2.height,
                Obx(
                  ()=> CommonText(
                      text: controller.designation.value??"Not Available",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryText,
                      textAlign: TextAlign.start,
                    ),
                ),
              ],
            ),
          ),

        _buildActionIcon(
          AppIcons.chat,
          hasNotification: false,
          onTap: () {
            RecruiterRoutes.goToChat();
          },
        ),
        8.width,
        _buildActionIcon(
          AppIcons.notification,
          hasNotification: hasNotification,
          onTap: () {
            Get.to(()=>JobSeekerNotificationScreen());
          },
        ),
      ],
    );
  }

  Widget _buildActionIcon(
    String imageSrc, {
    required bool hasNotification,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CommonImage(imageSrc: imageSrc, size: 24.sp),
          if (hasNotification)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 10.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: AppColors.secondaryPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
