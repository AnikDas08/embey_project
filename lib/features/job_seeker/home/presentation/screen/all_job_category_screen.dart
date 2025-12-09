import 'package:embeyi/core/component/text_field/common_text_field.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/job_seeker/home/presentation/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/all_jobcategory_controller.dart';

class AllJobCategoryScreen extends StatelessWidget {
  const AllJobCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllJobCategoryController());
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('All Category')),
      body: Column(
        children: [
          20.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CommonTextField(
              controller: searchController,
              hintText: 'Search by category',
              //prefixIcon: CommonImage(imageSrc: AppIcons.edit, size: 16.sp),
            ),
          ),
          20.height,
          Expanded(
            child: Obx(() {
              // Show loading indicator while fetching
              if (controller.categories.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];

                  return JobCategoryCard(
                    imageSrc: category['image'] ?? AppIcons.education,
                    title: category['name'] ?? 'Unknown',
                    onTap: () {
                      JobSeekerRoutes.goToCategoryJobList(
                        category['name'] ?? 'Unknown',
                      );
                    },
                    jobCount: category["jobs"], // You can update this with real job count from API
                    isJobCountVisible: true,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}