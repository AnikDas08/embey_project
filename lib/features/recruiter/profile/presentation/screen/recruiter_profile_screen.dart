import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/services/storage/storage_services.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/recruiter/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/services/storage/storage_keys.dart';
import '../../../../../core/component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../../core/component/image/common_image.dart';
import '../../../../../core/component/other_widgets/item.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/utils/constants/app_images.dart';
import '../../../../../core/utils/constants/app_string.dart';
import '../../../../job_seeker/profile/presentation/controller/profile_controller.dart';

class RecruiterProfileScreen extends StatelessWidget {
  const RecruiterProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section Starts here
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: AppString.profile,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        leading: const SizedBox(),
      ),

      /// Body Section Starts here
      body: GetBuilder<RecruiterProfileController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  children: [
                    /// User Profile Image here
                    Center(
                      child: ClipOval(
                        child: Obx(
                          ()=>Image.network(
                            ApiEndPoint.imageUrl+controller.profileImages.value,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )

                        ),
                      ),
                    ),

                    /// User Name here
                    Obx(
                      ()=>CommonText(
                        text: controller.name.value,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        top: 16,
                        bottom: 4,
                      ),
                    ),
                    /*Obx(
                      ()=> CommonText(
                        text: "UI/UX Designer",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryText,
                      ),
                    ),*/
                    Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        CommonImage(
                          imageSrc: AppIcons.premium,
                          width: 20.w,
                          height: 20.h,
                        ),
                        8.width,
                        Obx(
                           ()=> CommonText(
                            text: controller.subscription.value,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryPrimary,
                          ),
                        ),
                      ],
                    ),
                    16.height,

                    /// Edit Profile item here
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileItems.length,
                      itemBuilder: (context, index) {
                        final item = profileItems[index];
                        return Item(
                          imageSrc: item.imageSrc,
                          title: item.title,
                          onTap: item.onTap,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      /// Bottom Navigation Bar Section Starts here
      bottomNavigationBar: SafeArea(
        child: const CommonBottomNavBar(currentIndex: 3),
      ),
    );
  }
}

// Profile Item Data
final List<ProfileItemData> profileItems = [
  ProfileItemData(
    imageSrc: AppIcons.profile,
    title: 'Company Profile',
    onTap: () {
      RecruiterRoutes.goToCompanyProfile();
    },
  ),
  ProfileItemData(
    imageSrc: AppIcons.subscriptionPack,
    title: 'Subscription Pack',
    onTap: () {
      RecruiterRoutes.goToSubscriptionPack();
    },
  ),

  ProfileItemData(
    imageSrc: AppIcons.mySubscription,
    title: 'My Subscription',
    onTap: () {
      RecruiterRoutes.goToMySubscription();
    },
  ),
  ProfileItemData(
    imageSrc: AppIcons.love,
    title: 'Career Spotlight',
    onTap: () {
      RecruiterRoutes.goToCareerSpotlight();
    },
  ),
  ProfileItemData(
    imageSrc: AppIcons.subscriptionPack,
    title: 'Job history',
    onTap: () {
      RecruiterRoutes.goToJobHistory();
    },
  ),
  ProfileItemData(
    imageSrc: AppIcons.history3,
    title: 'Payment History',
    onTap: () {
      //ProfileController().showPaymentHistoryPopUp();
      ProfileController().showPaymentHistoryPopUp();
    },
  ),
  ProfileItemData(
    imageSrc: AppIcons.review,
    title: 'Platform Review',
    onTap: () {
      RecruiterRoutes.goToPlatformReview();
    },
  ),
  ProfileItemData(
    imageSrc: AppIcons.setting,
    title: 'Settings',
    onTap: () {
      RecruiterRoutes.goToSettings();
    },
  ),
  ProfileItemData(
    imageSrc: AppIcons.logout,
    title: 'Log Out',
    onTap: () {
      _showLogoutDialog();
    },
  ),
];

// Logout Dialog
void _showLogoutDialog() {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: const CommonText(
        text: 'Log Out',
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      content: CommonText(
        text: 'Are you sure you want to log out?',
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryText,
        maxLines: 2,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: CommonButton(
                titleText: 'No',
                buttonColor: AppColors.borderColor,
                titleColor: AppColors.black,
                borderColor: AppColors.borderColor,
                isGradient: false,
                onTap: () => Get.back(),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CommonButton(
                titleText: 'Yes',
                buttonColor: AppColors.red,
                borderColor: AppColors.red,
                titleColor: AppColors.white,
                isGradient: false,
                onTap: () {
                  LocalStorage.removeAllPrefData();
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Profile Item Model
class ProfileItemData {
  final String imageSrc;
  final String title;
  final VoidCallback onTap;

  ProfileItemData({
    required this.imageSrc,
    required this.title,
    required this.onTap,
  });
}
