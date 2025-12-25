import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/features/recruiter/message/presentation/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/component/image/common_image.dart';
import '../../../../../core/component/other_widgets/common_loader.dart';
import '../../../../../core/component/screen/error_screen.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../core/utils/enum/enum.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../controller/message_controller.dart';
import '../widgets/chat_bubble_message.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RecruiterMessageController controller =
      Get.find<RecruiterMessageController>();

      controller.setupController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecruiterMessageController>(
      init: RecruiterMessageController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.white,

          /// --- App Bar ---
          /// Update only the AppBar actions section in your MessageScreen

          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
                size: 20.sp,
              ),
              onPressed: () { Get.find<RecruiterChatController>().getChatRepo();
                Get.back();},
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18.sp,
                  backgroundColor: Colors.white24,
                  child: ClipOval(
                    child: CommonImage(imageSrc: controller.image, size: 36),
                  ),
                ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText(
                        text: controller.name,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.white,
                        maxLines: 1,
                      ),
                      const CommonText(
                        text: "ACTIVE NOW",
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Updated Video Button with Zoom Link Generation
              controller.isGeneratingZoomLink
                  ? Padding(
                padding: EdgeInsets.all(12.w),
                child: SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                ),
              )
                  : IconButton(
                onPressed: () => controller.generateAndOpenZoomLink(),
                icon: CommonImage(
                  imageSrc: AppIcons.video,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ],
          ),

          /// --- Body Section ---
          body: Column(
            children: [
              Expanded(child: _buildBody(controller)),

              /// Show selected files preview
              if (controller.selectedImages.isNotEmpty ||
                  controller.selectedDocuments.isNotEmpty)
                _buildSelectedFilesPreview(controller),
            ],
          ),

          /// --- Bottom Input Field ---
          bottomNavigationBar: _buildInputSection(context, controller),
        );
      },
    );
  }

  /// Helper to build body based on Controller Status
  Widget _buildBody(RecruiterMessageController controller) {
    switch (controller.status) {
      case Status.loading:
        return const CommonLoader();

      case Status.error:
        return ErrorScreen(onTap: () => controller.getMessageRepo());

      case Status.completed:
        if (controller.messages.isEmpty) {
          return Center(
            child: CommonText(
              text: "No messages yet",
              fontSize: 16,
              color: AppColors.grey,
            ),
          );
        }

        return ListView.builder(
          reverse: true,
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount:
          controller.messages.length + (controller.isMoreLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.messages.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return ChatBubbleMessage(
              message: controller.messages[index],
              name: controller.name,
              participantImage: controller.image,
            );
          },
        );

      default:
        return const SizedBox();
    }
  }

  /// Build selected files preview
  Widget _buildSelectedFilesPreview(RecruiterMessageController controller) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Selected Images
          if (controller.selectedImages.isNotEmpty) ...[
            CommonText(
              text: "Selected Images (${controller.selectedImages.length})",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            8.height,
            SizedBox(
              height: 80.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8.w),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            controller.selectedImages[index],
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(4.sp),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            12.height,
          ],

          /// Selected Documents
          if (controller.selectedDocuments.isNotEmpty) ...[
            CommonText(
              text: "Selected Documents (${controller.selectedDocuments.length})",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            8.height,
            ...controller.selectedDocuments.asMap().entries.map((entry) {
              int index = entry.key;
              var doc = entry.value;
              String fileName = doc.path.split('/').last;

              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                    12.width,
                    Expanded(
                      child: CommonText(
                        text: fileName,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.removeDocument(index),
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  /// Helper to build the Bottom Navigation Bar / Input field
  Widget _buildInputSection(
      BuildContext context,
      RecruiterMessageController controller,
      ) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F9),
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              /// Attachment Icon
              IconButton(
                onPressed: () => controller.showAttachmentOptions(context),
                icon: Icon(
                  Icons.attach_file,
                  color: AppColors.grey,
                  size: 24.sp,
                ),
              ),

              /// Text Field
              Expanded(
                child: CommonTextField(
                  hintText: "Write your message",
                  borderColor: Colors.transparent,
                  fillColor: AppColors.white,
                  borderRadius: 24,
                  paddingHorizontal: 16,
                  paddingVertical: 10,
                  controller: controller.messageController,
                  onSubmitted: (_) => controller.addNewMessage(),
                ),
              ),
              12.width,

              /// Send Button
              controller.isSending
                  ? Padding(
                padding: EdgeInsets.all(12.sp),
                child: SizedBox(
                  width: 20.sp,
                  height: 20.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              )
                  : GestureDetector(
                onTap: controller.addNewMessage,
                child: Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}