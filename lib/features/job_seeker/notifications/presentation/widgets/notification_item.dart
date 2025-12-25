import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../recruiter/notifications/data/model/notification_model.dart';
import '../../data/model/notification_model.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.item});

  final NotificationModel item;

  /// Format the notification time
  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';

    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 7) {
        return DateFormat('MMM dd, yyyy').format(dateTime);
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              color: const Color(0xFFF5F5F0),
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
                /// Title and Time Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Notification Title
                    Expanded(
                      child: CommonText(
                        text: item.title ?? '',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                        color: AppColors.primaryText,
                        maxLines: 2,
                      ),
                    ),
                    4.width,
                    /// Time
                    CommonText(
                      text: _formatTime(item.createdAt.toString()),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF999999),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
                4.height,

                /// Notification Message
                CommonText(
                  text: item.message ?? '',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
                  color: const Color(0xFF2F2F2F),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}