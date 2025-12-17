import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/services/storage/storage_services.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/enum/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/route/job_seeker_routes.dart';
import '../../config/route/recruiter_routes.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/log/app_log.dart';

class CommonBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const CommonBottomNavBar({required this.currentIndex, super.key});

  @override
  State<CommonBottomNavBar> createState() => _CommonBottomNavBarState();
}

class _CommonBottomNavBarState extends State<CommonBottomNavBar> {
  var bottomNavIndex = 0;
  List<Widget> jobSeekerUnselectedIcons = [
    CommonImage(imageSrc: AppIcons.home, size: 30.sp),
    CommonImage(imageSrc: AppIcons.work, size: 30.sp),
    CommonImage(imageSrc: AppIcons.history, size: 30.sp),
    CommonImage(imageSrc: AppIcons.person, size: 30.sp),
  ];

  List<Widget> jobSeekerSelectedIcons = [
    CommonImage(imageSrc: AppIcons.home2, size: 30.sp),
    CommonImage(imageSrc: AppIcons.work2, size: 30.sp),
    CommonImage(imageSrc: AppIcons.history2, size: 30.sp),
    CommonImage(imageSrc: AppIcons.person2, size: 30.sp),
  ];

  List<Widget> recruiterUnselectedIcons = [
    CommonImage(imageSrc: AppIcons.home, size: 30.sp),
    CommonImage(imageSrc: AppIcons.postInsight, size: 30.sp),
    CommonImage(imageSrc: AppIcons.work, size: 30.sp),
    CommonImage(imageSrc: AppIcons.person, size: 30.sp),
  ];

  List<Widget> recruiterSelectedIcons = [
    CommonImage(imageSrc: AppIcons.home2, size: 30.sp),
    CommonImage(imageSrc: AppIcons.postInsight2, size: 30.sp),
    CommonImage(imageSrc: AppIcons.work2, size: 30.sp),
    CommonImage(imageSrc: AppIcons.person2, size: 30.sp),
  ];
  List<Widget> unselectedIcons = [];
  List<Widget> selectedIcons = [];

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex;
    if (LocalStorage.role=="jobSeeker") {
      unselectedIcons = jobSeekerUnselectedIcons;
      selectedIcons = jobSeekerSelectedIcons;
    } else {
      unselectedIcons = recruiterUnselectedIcons;
      selectedIcons = recruiterSelectedIcons;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(color: AppColors.buttomNavBarColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(unselectedIcons.length, (index) {
            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                margin: EdgeInsetsDirectional.all(12.sp),
                child: Column(
                  children: [
                    index == bottomNavIndex
                        ? selectedIcons[index]
                        : unselectedIcons[index],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void onTap(int index) async {
    appLog(widget.currentIndex, source: "common bottombar");
    appLog(LocalStorage.userRole, source: "user role");
    appLog(index, source: "index");
    appLog(widget.currentIndex, source: "widget current index");
    print("User Role : 😍😍😍😍${LocalStorage.userRole!.name}");

    if (LocalStorage.role=="jobSeeker") {
      // Job Seeker Navigation
      if (index == 0) {
        if (!(widget.currentIndex == 0)) {
          Get.toNamed(JobSeekerRoutes.home);
        }
      } else if (index == 1) {
        if (!(widget.currentIndex == 1)) {
          Get.toNamed(JobSeekerRoutes.jobs);
        }
      } else if (index == 2) {
        if (!(widget.currentIndex == 2)) {
          Get.toNamed(JobSeekerRoutes.history);
        }
      } else if (index == 3) {
        if (!(widget.currentIndex == 3)) {
          Get.toNamed(JobSeekerRoutes.profile);
        }
      }
    } else {
      // Recruiter Navigation
      if (index == 0) {
        if (!(widget.currentIndex == 0)) {
          Get.toNamed(RecruiterRoutes.home);
        }
      } else if (index == 1) {
        if (!(widget.currentIndex == 1)) {
          Get.toNamed(RecruiterRoutes.postInsight);
        }
      } else if (index == 2) {
        if (!(widget.currentIndex == 2)) {
          Get.toNamed(RecruiterRoutes.jobPost);
        }
      } else if (index == 3) {
        if (!(widget.currentIndex == 3)) {
          Get.toNamed(RecruiterRoutes.profile);
        }
      }
    }
  }
}
