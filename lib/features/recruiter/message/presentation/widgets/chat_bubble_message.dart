import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../core/component/image/common_image.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../../data/model/message_model.dart';
import '../controller/message_controller.dart';

class ChatBubbleMessage extends StatelessWidget {
  final MessageModel message;
  final String name;
  final String participantImage;

  const ChatBubbleMessage({
    super.key,
    required this.message,
    required this.name,
    required this.participantImage,
  });

  bool get isMe => message.sender == LocalStorage.userId;

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('hh:mm a').format(message.createdAt);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          /// Show profile image for received messages
          if (!isMe) ...[
            CircleAvatar(
              radius: 18.sp,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: CommonImage(
                  imageSrc: message.senderImage ?? participantImage,
                  size: 36,
                ),
              ),
            ),
            8.width,
          ],

          /// Message bubble
          Flexible(
            child: Column(
              crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                /// Show name for received messages
                if (!isMe)
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                    child: CommonText(
                      text: message.senderName ?? name,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      textAlign: TextAlign.left,
                    ),
                  ),

                /// Message content based on type
                _buildMessageContent(context),

                /// Time stamp
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.w, right: 4.w),
                  child: CommonText(
                    text: timeString,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.type) {
      case 'text':
        return _buildTextMessage();
      case 'image':
        return _buildImageMessage();
      case 'document':
        return _buildDocumentMessage();
      case 'zoom-link':
        return _buildZoomLinkMessage();
      default:
        return _buildTextMessage();
    }
  }

  Widget _buildTextMessage() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: Get.size.width * 0.5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryColor : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 16.r : 4.r),
            topRight: Radius.circular(isMe ? 4.r : 16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: _buildClickableText(message.text),
      ),
    );
  }

  /// Build clickable text with URL detection
  Widget _buildClickableText(String text) {
    final controller = Get.find<RecruiterMessageController>();

    // Regular expression to detect URLs
    final RegExp urlRegExp = RegExp(
      r'((https?|ftp):\/\/[^\s/$.?#].[^\s]*)|((www\.)[^\s/$.?#].[^\s]*)',
      caseSensitive: false,
    );

    final matches = urlRegExp.allMatches(text);

    if (matches.isEmpty) {
      // No URLs found, return plain text
      return CommonText(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isMe ? AppColors.white : AppColors.black,
        textAlign: TextAlign.left,
        maxLines: 100,
      );
    }

    // Build TextSpan with clickable URLs
    List<TextSpan> spans = [];
    int currentPosition = 0;

    for (final match in matches) {
      // Add text before URL
      if (match.start > currentPosition) {
        spans.add(TextSpan(
          text: text.substring(currentPosition, match.start),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isMe ? AppColors.white : AppColors.black,
          ),
        ));
      }

      // Add clickable URL
      String url = text.substring(match.start, match.end);
      spans.add(TextSpan(
        text: url,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isMe ? Colors.blue.shade100 : Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            controller.openUrl(url);
          },
      ));

      currentPosition = match.end;
    }

    // Add remaining text after last URL
    if (currentPosition < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPosition),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: isMe ? AppColors.white : AppColors.black,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildImageMessage() {
    final controller = Get.find<RecruiterMessageController>();

    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (message.image.isNotEmpty)
          ...message.image.map((imageUrl) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: GestureDetector(
              onTap: () {
                // Open image in full screen
                controller.openImageFullScreen(ApiEndPoint.imageUrl + imageUrl);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CommonImage(
                  imageSrc: ApiEndPoint.imageUrl + imageUrl,
                  width: Get.size.width * 0.6,
                  height: 200.h,
                ),
              ),
            ),
          )),
        if (message.text.isNotEmpty) 4.height,
        if (message.text.isNotEmpty) _buildTextMessage(),
      ],
    );
  }

  Widget _buildDocumentMessage() {
    final controller = Get.find<RecruiterMessageController>();

    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (message.docs.isNotEmpty)
          ...message.docs.map((docUrl) {
            String fileName = _getFileName(docUrl);
            String fileExtension = _getFileExtension(fileName);
            IconData fileIcon = _getFileIcon(fileExtension);
            Color iconColor = _getFileColor(fileExtension);

            return GestureDetector(
              onTap: () {
                // Open document URL in browser for viewing/downloading
                String fullUrl = ApiEndPoint.imageUrl + docUrl;
                controller.downloadDocument(fullUrl, fileName);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                constraints: BoxConstraints(
                  maxWidth: Get.size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primaryColor : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isMe
                        ? AppColors.primaryColor.withOpacity(0.3)
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // File icon with background
                    Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                        color: isMe
                            ? Colors.white.withOpacity(0.2)
                            : iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        fileIcon,
                        color: isMe ? AppColors.white : iconColor,
                        size: 24.sp,
                      ),
                    ),
                    12.width,
                    // File info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonText(
                            text: fileName,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isMe ? AppColors.white : AppColors.black,
                            maxLines: 2,
                          ),
                          4.height,
                          CommonText(
                            text: fileExtension.toUpperCase(),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: isMe
                                ? AppColors.white.withOpacity(0.7)
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    8.width,
                    // Download/Open icon
                    Container(
                      padding: EdgeInsets.all(6.sp),
                      decoration: BoxDecoration(
                        color: isMe
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.download_rounded,
                        color: isMe ? AppColors.white : AppColors.primaryColor,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        if (message.text.isNotEmpty) 8.height,
        if (message.text.isNotEmpty) _buildTextMessage(),
      ],
    );
  }

  String _getFileExtension(String fileName) {
    try {
      return fileName.split('.').last.toLowerCase();
    } catch (e) {
      return 'file';
    }
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'txt':
        return Icons.text_snippet;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String extension) {
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'txt':
        return Colors.grey;
      case 'zip':
      case 'rar':
        return Colors.orange;
      default:
        return AppColors.primaryColor;
    }
  }

  Widget _buildZoomLinkMessage() {
    final controller = Get.find<RecruiterMessageController>();

    return GestureDetector(
      onTap: () => controller.openUrl(message.text),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryColor : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.video_call,
              color: isMe ? AppColors.white : AppColors.primaryColor,
              size: 24.sp,
            ),
            8.width,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: "Zoom Meeting",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isMe ? AppColors.white : AppColors.black,
                  ),
                  4.height,
                  CommonText(
                    text: "Tap to join",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isMe
                        ? AppColors.white.withOpacity(0.8)
                        : AppColors.primaryColor,
                  ),
                ],
              ),
            ),
            8.width,
            Icon(
              Icons.open_in_new,
              color: isMe ? AppColors.white : AppColors.primaryColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  String _getFileName(String url) {
    try {
      return url.split('/').last;
    } catch (e) {
      return 'Document';
    }
  }
}