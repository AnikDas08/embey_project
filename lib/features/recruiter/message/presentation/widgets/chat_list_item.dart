import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/component/image/common_image.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../data/model/chat_list_model.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel item;

  const ChatListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Format the date (e.g., 11:04 AM)
    // Make sure your model handles null createdAt safely
    String formattedTime = item.lastMessage != null
        ? DateFormat('hh:mm a').format(item.lastMessage!.createdAt)
        : "";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: const BoxDecoration(color: AppColors.transparent),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Participant Image
              ClipOval(
                child: Image.network(
                  item.participant.image.startsWith("http")
                      ? item.participant.image
                      : ApiEndPoint.imageUrl + item.participant.image,
                  fit: BoxFit.cover,
                  height: 50.h,
                  width: 50.w,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 50.h,
                    width: 50.w,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
              12.width,

              /// Content Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Participant Name
                        CommonText(
                          text: item.participant.name,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),

                        /// Last Message Time
                        CommonText(
                          text: formattedTime,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: Colors.grey, // Subtle color for the time
                        ),
                      ],
                    ),
                    4.height,

                    /// Last Message Text with http check
                    CommonText(
                      text: item.lastMessage?.text.startsWith("http") ?? false
                          ? "Sent a photo"
                          : (item.lastMessage?.text ?? ""),
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          const Divider(height: 1, thickness: 0.5),
        ],
      ),
    );
  }
}

