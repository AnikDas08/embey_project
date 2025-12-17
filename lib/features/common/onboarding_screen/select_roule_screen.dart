import 'package:embeyi/core/services/storage/storage_keys.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/route/app_routes.dart';
import 'package:embeyi/core/services/storage/storage_services.dart';

import 'package:embeyi/core/utils/enum/enum.dart';
import '../../../core/utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectRouleScreen extends StatefulWidget {
  const SelectRouleScreen({super.key});

  @override
  State<SelectRouleScreen> createState() => _SelectRouleScreenState();
}

class _SelectRouleScreenState extends State<SelectRouleScreen> {
  UserRole? selectedRole;

  @override
  void initState() {
    super.initState();
    _loadCurrentRole();
  }

  Future<void> _loadCurrentRole() async {
    await LocalStorage.getAllPrefData();
    setState(() {
      selectedRole = LocalStorage.userRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonImage(
                  imageSrc: AppImages.logo,
                  width: 216.w,
                  height: 157.h,
                ),
                100.height,
                CommonText(
                  text: "Are You a Job Seeker or a Recruiter?",
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  maxLines: 2,
                  bottom: 8,
                ),
                CommonText(
                  text: "Get started by choosing your role.",
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                44.height,
                selectRoleCard(
                  title: "Job Seeker",
                  subtitle: 'Finding a job here never been easier than before',
                  imageSrc: AppImages.jobseekers,
                  onTap: () async {
                    await LocalStorage.setString(
                      LocalStorageKeys.userRole,
                      UserRole.jobSeeker.name,
                    );
                    await LocalStorage.setRole(LocalStorageKeys.role, "jobSeeker");
                    await LocalStorage.getAllPrefData();
                    setState(() {
                      selectedRole = UserRole.jobSeeker;
                    });
                    print("User Role 😊😊😊😊${LocalStorage.userRole}");
                    print("User Role : 😍😍😍😍 kdfdk ${LocalStorage.role}");
                    Get.toNamed(AppRoutes.signUp);
                  },
                  isSeleted: selectedRole == UserRole.jobSeeker,
                ),
                20.height,
                selectRoleCard(
                  title: "Recruiter",
                  subtitle: "Let's recruit your great candidate faster here",
                  imageSrc: AppImages.recruiter,
                  onTap: () async {
                    await LocalStorage.setString(
                      LocalStorageKeys.userRole,
                      UserRole.employer.name,
                    );
                    await LocalStorage.setRole(LocalStorageKeys.role, "recruiter");
                    await LocalStorage.getAllPrefData();
                    setState(() {
                      selectedRole = UserRole.employer;
                    });
                    print("User Role 😊😊😊😊${LocalStorage.userRole}");
                    print("User Role : 😍😍😍😍 kdfdk ${LocalStorage.role}");
                    Get.toNamed(AppRoutes.signUp);
                  },
                  isSeleted: selectedRole == UserRole.employer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectRoleCard({
    required String title,
    required String subtitle,
    required String imageSrc,
    required VoidCallback onTap,
    required bool isSeleted,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 370.w,
        height: 117.h,
        padding: EdgeInsets.all(20.w),
        decoration: ShapeDecoration(
          color: isSeleted ? const Color(0xFFFEF3E6) : AppColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color: isSeleted
                  ? const Color(0xFFFF8F27)
                  : AppColors.primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CommonImage(imageSrc: imageSrc, width: 76.w, height: 69.h),
            ),
            20.width,
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: title,
                    color: isSeleted
                        ? AppColors.secondaryPrimary
                        : AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  5.height,
                  CommonText(
                    text: subtitle,
                    color: AppColors.primaryText,
                    fontSize: 14,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w400,
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
