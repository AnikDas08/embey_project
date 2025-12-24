import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/config/route/recruiter_routes.dart';
import '../../../../../core/component/other_widgets/common_loader.dart';
import '../../../../../core/component/screen/error_screen.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../controller/chat_controller.dart';
import '../../data/model/chat_list_model.dart';
import '../../../../../core/utils/enum/enum.dart';
import '../../../../../core/utils/constants/app_string.dart';
import '../widgets/chat_list_item.dart';

class RecruiterChatListScreen extends StatelessWidget {
  const RecruiterChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: AppString.inbox,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      body: GetBuilder<RecruiterChatController>(
        builder: (controller) {
          switch (controller.status) {
          /// Loading
            case Status.loading:
              return const CommonLoader();

          /// Error
            case Status.error:
              return ErrorScreen(
                onTap: () => controller.getChatRepo(),
              );

          /// Completed
            case Status.completed:
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    /// Search Bar (Functional)
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: CommonTextField(
                        controller: controller.searchController,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: controller.searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            controller.clearSearch();
                          },
                        )
                            : null,
                        hintText: AppString.search,
                        borderRadius: 10,
                        paddingHorizontal: 16,
                        paddingVertical: 10,
                        onChanged: (value) {
                          // Trigger search on text change
                          controller.searchByName(value);
                        },
                      ),
                    ),

                    /// Empty State
                    if (controller.chats.isEmpty)
                      Expanded(
                        child: Center(
                          child: CommonText(
                            text: controller.searchTerm.isNotEmpty
                                ? "No chats found for '${controller.searchTerm}'"
                                : "No chats found",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )

                    /// Chat List
                    else
                      Expanded(
                        child: ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.chats.length +
                              (controller.isMoreLoading ? 1 : 0),
                          padding: EdgeInsets.only(top: 16.h),
                          itemBuilder: (context, index) {
                            if (index >= controller.chats.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final ChatModel item = controller.chats[index];

                            return GestureDetector(
                              onTap: () => Get.toNamed(
                                RecruiterRoutes.message,
                                parameters: {
                                  "chatId": item.id,
                                  "name": item.participant.name,
                                  "image": ApiEndPoint.imageUrl +
                                      item.participant.image,
                                },
                              ),
                              child: ChatListItem(item: item),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}