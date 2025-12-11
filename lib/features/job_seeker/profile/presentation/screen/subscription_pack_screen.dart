import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../../data/subscription_model.dart';
import '../controller/subscription_package_all_controllerer.dart';

class SubscriptionPackScreen extends StatelessWidget {
  const SubscriptionPackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());

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
                        CommonText(
                          text: controller.errorMessage.value,
                          fontSize: 14,
                          color: Colors.red,
                        ),
                        16.height,
                        CommonButton(
                          titleText: 'Retry',
                          onTap: controller.fetchPackages,
                          buttonColor: AppColors.primary,
                        ),
                      ],
                    ),
                  );
                }

                if (controller.packages.isEmpty) {
                  return Center(
                    child: CommonText(
                      text: 'No packages available',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        24.height,

                        // Package Tabs
                        _buildPackageTabs(controller),

                        60.height,

                        // Plan Card
                        _buildPlanCard(controller),

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
                text: 'Package',
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

  Widget _buildPackageTabs(SubscriptionController controller) {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            controller.packages.length,
                (index) => Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: _buildTabButton(
                controller.packages[index].name,
                index,
                controller,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabButton(
      String label,
      int index,
      SubscriptionController controller,
      ) {
    return Obx(() {
      final isSelected = controller.selectedPlanIndex.value == index;

      return GestureDetector(
        onTap: () => controller.selectPlan(index),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: ShapeDecoration(
            gradient: isSelected
                ? LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [const Color(0xFF123499), const Color(0xFF2956DD)],
            )
                : null,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: CommonText(
            text: label,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
      );
    });
  }

  Widget _buildPlanCard(SubscriptionController controller) {
    return Obx(() {
      final package = controller.selectedPackage;
      if (package == null) return const SizedBox.shrink();

      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: const Color(0xFF123499)),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price and Title
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(30.w),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: const Color(0xFF123499)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    gradient: LinearGradient(
                      colors: [AppColors.gradientColor, AppColors.gradientColor2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonText(
                        text: package.priceText,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      CommonText(
                        text: '/',
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      8.width,
                      CommonText(
                        text: package.subtitle,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                        top: 20,
                      ),
                    ],
                  ),
                ),

                28.height,

                // Features List
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: List.generate(
                      package.features.length,
                          (index) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonImage(
                              imageSrc: AppIcons.check2,
                              width: 20.w,
                              height: 20.h,
                            ),
                            10.width,
                            Expanded(
                              child: CommonText(
                                text: package.features[index],
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _buildEnableButton(package, controller),
              ],
            ),
          ),
          Positioned(
            top: -30.w,
            right: 160.w,
            child: Container(
              width: 59,
              height: 59,
              padding: const EdgeInsets.symmetric(
                horizontal: 11.80,
                vertical: 10.62,
              ),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.18, color: const Color(0xFFF48201)),
                  borderRadius: BorderRadius.circular(29.50),
                ),
              ),
              child: CommonImage(
                imageSrc: package.isFree ? AppIcons.free : AppIcons.premium,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEnableButton(
      PackageModel package,
      SubscriptionController controller,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF6FB),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: CommonButton(
        titleText: package.isFree ? "Enable" : "Buy Now",
        onTap: () => controller.onBuyNow(package),
        isGradient: package.isFree,
        buttonColor: package.isFree
            ? AppColors.transparent
            : AppColors.primary,
        titleColor: package.isFree ? AppColors.primary : AppColors.white,
      ),
    );
  }
}