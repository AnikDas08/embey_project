import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../data/model/notification_model.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.item});

  final NotificationModel item;

  /// Get notification color based on type
  /*Color _getNotificationColor() {
    final type = item.type.toLowerCase();
    if (type.contains('job') || type.contains('alert')) {
      return const Color(0xFFFF8F27); // Orange for Job Alert
    } else if (type.contains('reject')) {
      return const Color(0xFFD9534F); // Red for Reject
    } else if (type.contains('message')) {
      return const Color(0xFF008F37); // Green for Message
    }
    return AppColors.primaryColor; // Default blue
  }*/

  /// Get notification icon based on type
  /*IconData _getNotificationIcon() {
    final type = item.type.toLowerCase();
    if (type.contains('job') || type.contains('alert')) {
      return Icons.work_outline;
    } else if (type.contains('reject')) {
      return Icons.close;
    } else if (type.contains('message')) {
      return Icons.chat_bubble_outline;
    }
    return Icons.notifications_outlined;
  }*/

  @override
  Widget build(BuildContext context) {
    //final notificationColor = _getNotificationColor();
    //final notificationIcon = _getNotificationIcon();

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon with background
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F0), // Cream/beige background
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.notifications,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Notification Title
                CommonText(
                  text: item.title!,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                  color: AppColors.primaryText,
                  maxLines: 1,
                ),
                4.height,

                /// Notification Message
                CommonText(
                  text: item.message!,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  maxLines: 3,
                  color: const Color(0xFF2F2F2F),
                  textAlign: TextAlign.start,
                ),

                /*/// Show "Apply Now!" link for job alerts
                if (item.type.toLowerCase().contains('job') ||
                    item.type.toLowerCase().contains('alert'))
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: CommonText(
                      text: 'Apply Now!',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      color: const Color(0xFF123499),
                      maxLines: 1,
                    ),
                  ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
