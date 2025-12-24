// career_spotlight_screen.dart

import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/features/recruiter/profile/presentation/screen/add_career_spotlight_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:get/get.dart';

import '../../data/model/canrrer_spoitlignt_model.dart';
import '../controller/spoitlight_controller.dart';
// Import your controller and model
// import 'package:embeyi/features/recruiter/profile/presentation/controller/career_spotlight_controller.dart';
// import 'package:embeyi/features/recruiter/profile/data/models/career_spotlight_model.dart';

class CareerSpotlightScreen extends StatelessWidget {
  const CareerSpotlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CareerSpotlightController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppbar(
        title: 'Career Spotlight',
        showLeading: true,
        backgroundColor: AppColors.white,
        textColor: AppColors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshSpotlights,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),

                          // Stats Cards Section
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  count: controller.activeCount.value
                                      .toString()
                                      .padLeft(2, '0'),
                                  label: 'Active Ads',
                                  countColor: const Color(0xFF008F37),
                                  backgroundColor: const Color(0xFFE8F5ED),
                                  labelColor: const Color(0xFF008F37),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildStatCard(
                                  count: controller.pendingCount.value
                                      .toString()
                                      .padLeft(2, '0'),
                                  label: 'Pending Approval',
                                  countColor: const Color(0xFFFF8F27),
                                  backgroundColor: const Color(0xFFFFF4E8),
                                  labelColor: const Color(0xFFFF8F27),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24.h),

                          // Recent Add Section
                          CommonText(
                            text: 'Recent Add',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                            textAlign: TextAlign.start,
                          ),

                          SizedBox(height: 16.h),

                          // Job Cards List
                          if (controller.spotlights.isEmpty)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: CommonText(
                                  text: 'No spotlights available',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.secondaryText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else
                            ...controller.spotlights.map((spotlight) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: _buildJobCard(
                                  spotlight: spotlight,
                                  imageUrl: controller.getImageUrl(spotlight.coverImage),
                                ),
                              );
                            }).toList(),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            // Bottom Create Add Button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: CommonButton(
                titleText: 'Create Add',
                titleSize: 18,
                titleWeight: FontWeight.w600,
                buttonHeight: 50.h,
                buttonRadius: 8,
                buttonColor: AppColors.primaryColor,
                isGradient: false,
                onTap: () {
                  Get.to(() => const AddCareerSpotlightScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String count,
    required String label,
    required Color countColor,
    required Color backgroundColor,
    required Color labelColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          CommonText(
            text: count,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: countColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          CommonText(
            text: label,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: labelColor,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required Spotlight spotlight,
    required String imageUrl,
  }) {
    // Determine status display
    final bool isActive = spotlight.isActive;
    final String statusText = isActive ? 'Active' : 'Pending';
    final Color statusColor = isActive
        ? const Color(0xFF008F37)
        : const Color(0xFFFF8F27);
    final Color statusBgColor = isActive
        ? const Color(0xFFE8F5ED)
        : const Color(0xFFFFF4E8);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            // Job Image/Banner
            SizedBox(
              height: 120.h,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),

            // Job Details
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: spotlight.serviceType,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 4.h),
                        CommonText(
                          text: spotlight.organizationName,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryText,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: statusColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: CommonText(
                      text: statusText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}