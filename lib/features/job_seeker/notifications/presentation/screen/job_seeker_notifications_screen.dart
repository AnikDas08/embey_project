import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/other_widgets/common_loader.dart';
import '../../../../../core/component/other_widgets/no_data.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../recruiter/notifications/data/model/notification_model.dart';
import '../controller/notifications_controller.dart';
import '../../data/model/notification_model.dart';
import '../widgets/notification_item.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class JobSeekerNotificationScreen extends StatelessWidget {
  const JobSeekerNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      /// App Bar Section starts here
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: CommonText(
          text: 'Notification',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: AppColors.black,
        ),
      ),

      /// Body Section starts here
      body: GetBuilder<NotificationsController>(
        builder: (controller) {
          return controller.isLoading
          /// Loading bar here
              ? const CommonLoader()
              : controller.notifications.isEmpty
          ///  data is Empty then show default Data
              ? const NoData()
          /// show all Notifications here
              : ListView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            itemCount: controller.isLoadingMore
                ? controller.notifications.length + 1
                : controller.notifications.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              ///  Notification More Data Loading Bar
              if (index >= controller.notifications.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CommonLoader(size: 40, strokeWidth: 2),
                );
              }
              NotificationModel item = controller.notifications[index];

              ///  Notification card item
              return NotificationItem(item: item);
            },
          );
        },
      ),
    );
  }
}
