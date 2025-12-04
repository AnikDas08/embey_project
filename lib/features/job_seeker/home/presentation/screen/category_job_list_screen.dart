import 'package:embeyi/core/component/bottom_shit/filder_bottom_shit.dart';
import 'package:embeyi/core/component/card/job_card.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/features/job_seeker/home/presentation/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoryJobListScreen extends StatelessWidget {
  final String category;
  const CategoryJobListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: category,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: HomeSearchBar(
                  onFilterTap: () {
                    Get.bottomSheet(
                      isScrollControlled: true,
                      FilterBottomSheet(
                        onApply: () {
                          // Handle apply tap
                        },
                        onClose: () {
                          // Handle close tap
                          Navigator.pop(context);
                        },
                        //isDateRange: true,
                      ),
                    );
                  },
                  onChanged: (value) {
                    // Handle search
                  },
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: JobCard(
                      companyName: 'UX-Pilot',
                      location: 'California, United State.',
                      jobTitle: 'Sr. UI/UX Designer',
                      salaryRange: '\$7k - \$15k/month',
                      timePosted: '01 Dec 25',
                      isFullTime: true,
                      companyLogo: AppImages.jobPost,
                      onTap: () {
                        JobSeekerRoutes.goToJobDetails();
                      },
                      onFavoriteTap: () {
                        // Handle favorite tap
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
