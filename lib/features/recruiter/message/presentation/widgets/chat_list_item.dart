import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/component/image/common_image.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../data/model/chat_list_model.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel item;

  const ChatListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
      decoration: const BoxDecoration(color: AppColors.transparent),
      child: Column(
        children: [
          Row(
            children: [
              /// participant image here
             ClipOval(
                  child: Image.network(
                    ApiEndPoint.imageUrl+item.participant.image,
                    fit: BoxFit.cover,
                    height: 45,
                    width: 45,
                  ),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// participant Name here
                    CommonText(
                      text: item.participant.name,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),

                    /// participant Last Message here
                    CommonText(
                      text: item.lastMessage!.text,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.height,

          /// Divider here
          const Divider(height: 1),
        ],
      ),
    );
  }
}

