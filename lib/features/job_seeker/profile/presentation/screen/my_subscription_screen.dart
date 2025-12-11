import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../controller/my_subscription_controller.dart';

class MySubscriptionScreen extends StatelessWidget {
  const MySubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MySubscriptionController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: Colors.red.shade300,
                        ),
                        16.height,
                        CommonText(
                          text: controller.errorMessage.value,
                          fontSize: 14,
                          color: Colors.red,
                          textAlign: TextAlign.center,
                        ),
                        24.height,
                        ElevatedButton(
                          onPressed: controller.fetchMySubscription,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B4DE3),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 12.h,
                            ),
                          ),
                          child: const CommonText(
                            text: 'Retry',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        32.height,

                        // Profile Section
                        _buildProfileSection(controller),

                        40.height,

                        // Subscription Details Table
                        _buildSubscriptionTable(controller),

                        40.height,

                        // Renew Button
                        _buildRenewButton(controller),

                        40.height,
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.sp,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Center(
              child: CommonText(
                text: 'My Subscription',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }

  Widget _buildProfileSection(MySubscriptionController controller) {
    return Obx(() {
      return Column(
        children: [
          // Profile Image
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E3A5F),
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: controller.userImage.value!=null
                ? ClipOval(
              child: Image.network(
                ApiEndPoint.imageUrl+controller.userImage.value,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: 50.sp,
                    color: Colors.white,
                  );
                },
              ),
            )
                : Icon(
              Icons.person,
              size: 50.sp,
              color: Colors.white,
            ),
          ),

          16.height,

          // Name
          CommonText(
            text: controller.userName.value,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),

          6.height,

          // Designation
          CommonText(
            text: controller.userDesignation.value,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),

          12.height,

          // Plan Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: controller.isActive
                  ? const Color(0xFFFFF4E6)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: controller.isActive
                      ? const Color(0xFFFF9800)
                      : Colors.grey.shade600,
                  size: 18.sp,
                ),
                6.width,
                CommonText(
                  text: controller.packageName.value,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: controller.isActive
                      ? const Color(0xFFFF9800)
                      : Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSubscriptionTable(MySubscriptionController controller) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          children: [
            _buildTableRow('Pack Name', controller.packageName.value,
                isFirst: true),
            _buildDivider(),
            _buildTableRow('Price', controller.formattedPrice),
            _buildDivider(),
            _buildTableRow('Start Date', controller.startDate.value),
            _buildDivider(),
            _buildTableRow('End Date', controller.endDate.value),
            _buildDivider(),
            _buildTableRow(
              'Remaining Days',
              controller.remainingDaysText,
              isLast: true,
              valueColor: controller.remainingDays.value < 5
                  ? Colors.red
                  : Colors.black87,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTableRow(
      String label,
      String value, {
        bool isFirst = false,
        bool isLast = false,
        Color? valueColor,
      }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(
            text: label,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          CommonText(
            text: value,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      color: Colors.grey.shade200,
    );
  }

  Widget _buildRenewButton(MySubscriptionController controller) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: controller.onRenewPack,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B4DE3),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          shadowColor: const Color(0xFF3B4DE3).withOpacity(0.3),
        ),
        child: const CommonText(
          text: 'Renew Pack',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}