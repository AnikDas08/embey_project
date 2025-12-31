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
              onChanged: (value) {
                // Filter categories as user types
                controller.searchCategories(value);
              },
              suffixIcon: Obx(() {
                // Show clear button when there's text
                if (controller.searchQuery.value.isNotEmpty) {
                  return IconButton(
                    icon: Icon(Icons.clear, size: 20.sp),
                    onPressed: () {
                      searchController.clear();
                      controller.clearSearch();
                    },
                  );
                }
                return SizedBox.shrink();
              }),
            ),
          ),
          20.height,

          // Search results count
          Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Found ${controller.categories.length} ${controller.categories.length == 1 ? 'category' : 'categories'}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),

          Expanded(
            child: Obx(() {
              // Show loading indicator while fetching
              if (controller.allCategories.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // Show empty state when search has no results
              if (controller.categories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text(
                        'No categories found',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Try a different search term',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
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
                      Get.toNamed(
                        JobSeekerRoutes.categoryDetails,
                        arguments: {
                          "categoryId": category['id'],
                          "categoryName": category['name'],
                        },
                      );
                    },
                    jobCount: category["jobs"],
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