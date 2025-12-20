import 'package:embeyi/core/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:embeyi/core/component/bottom_shit/filder_bottom_shit.dart';
import 'package:embeyi/core/component/card/job_card.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/job_seeker/home/data/model/job_post.dart';
import 'package:embeyi/features/job_seeker/home/presentation/screen/category_details.dart';
import 'package:embeyi/features/job_seeker/home/presentation/widgets/auto_apply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../widgets/home_widgets.dart';

class JobSeekerHomeScreen extends StatelessWidget {
  JobSeekerHomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header Section (won't scroll)
            GetBuilder<HomeController>(
                builder: (controller) {
                  return Container(
                    color: AppColors.background,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: HomeHeader(
                      profileImage: controller.image.value,
                      userName: controller.name.value,
                      userRole: controller.designation.value,
                      onNotificationTap: () {
                        JobSeekerRoutes.goToNotifications();
                      },
                      onMessageTap: () {
                        JobSeekerRoutes.goToChat();
                      },
                      onProfileTap: () {
                        JobSeekerRoutes.goToProfile();
                      },
                    ),
                  );
                }
            ),

            // Scrollable Content
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Search Bar Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: HomeSearchBar(
                        onFilterTap: () {
                          Get.bottomSheet(
                            isScrollControlled: true,
                            FilterBottomSheet(
                              onApply: () {
                                // Filter applied, list will update automatically
                              },
                              onClose: () {
                                Get.back();
                              },
                            ),
                          );
                        },
                        onChanged: (value) {
                          // Search as user types (with debounce in production)
                          controller.searchJobs(value);
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: 20.height),

                  // Hero Banner Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: HeroBanner(
                        onTap: () {},
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: 24.height),

                  // Job Category Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SectionHeader(
                        title: 'Job Category',
                        onSeeAllTap: () {
                          JobSeekerRoutes.goToAllJobCategory();
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: 16.height),

                  // Job Category Grid
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Obx(() {
                        final categoriesList = controller.categories;

                        if (categoriesList.isEmpty) {
                          return Container(
                            height: 100.h,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          );
                        }

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 1,
                          children: categoriesList.map((category) {
                            final categoryId = category["id"];
                            return JobCategoryCard(
                              imageSrc: category['image'] ?? "",
                              title: category['name'],
                              onTap: () {
                                print("category id 😂😂$categoryId");
                                Get.toNamed(JobSeekerRoutes.categoryDetails,arguments: {
                                  "categoryId": categoryId,
                                  "categoryName": category['name'],
                                });
                              },
                              isJobCountVisible: false,
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ),

                  SliverToBoxAdapter(child: 24.height),

                  // Recommended Job Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SectionHeader(
                        title: 'Recommended Job',
                        onSeeAllTap: () {
                          JobSeekerRoutes.goToAllRecommendedJob();
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: 16.height),

                  SliverToBoxAdapter(child: AutoApply()),

                  // ✅ WRAP THE RECOMMENDED JOB LIST WITH GetBuilder
                  SliverToBoxAdapter(
                    child: GetBuilder<HomeController>(
                      builder: (controller) {
                        // Add debug prints
                        print("🔍 Building job list");
                        print("🔍 jobPost is null? ${controller.jobPost == null}");
                        print("🔍 jobPost length: ${controller.jobPost?.length ?? 0}");

                        // Check if data is loading
                        if (controller.isLoadingJobs.value) {
                          return Container(
                            height: 200.h,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          );
                        }

                        // Check if data is empty or null
                        if (controller.jobPost == null || controller.jobPost!.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.work_off_outlined,
                                  size: 64.sp,
                                  color: AppColors.secondaryText,
                                ),
                                16.height,
                                Text(
                                  'No jobs available',
                                  style: TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                8.height,
                                Text(
                                  'Check back later for new opportunities',
                                  style: TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Display job list
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.jobPost!.length,
                            itemBuilder: (context, index) {
                              final jobPost = controller.jobPost![index];

                              // --- 1. Pass data safely using null-coalescing (??) ---

                              // Calculate salary range safely (use 0 as fallback for null min/max)
                              final minSalary = jobPost.minSalary ?? 0;
                              final maxSalary = jobPost.maxSalary ?? 0;
                              final salaryRange = '\$$minSalary - \$$maxSalary/month';

                              // Get location safely
                              final location = jobPost.location ?? 'Location not specified';
                              final favourite=jobPost.isFavourite;

                              // Get job and recruiter titles safely
                              final jobTitle = jobPost.title ?? 'No Title Specified';
                              // Assuming recruiter contains the name of the company/recruiter
                              final companyName = jobPost.recruiter ?? 'Company N/A';

                              // Format deadline date
                              String timePosted = '01 Dec 25'; // Default fallback date
                              if (jobPost.deadline != null) {
                                try {
                                  final deadline = jobPost.deadline!;
                                  timePosted = '${deadline.day.toString().padLeft(2, '0')} ${_getMonthName(deadline.month)} ${deadline.year.toString().substring(2)}';
                                } catch (e) {
                                  print("Error formatting date: $e");
                                }
                              }

                              // Determine job properties safely
                              final jobType = jobPost.jobType?.toUpperCase();
                              final isFullTime = jobType == 'FULL_TIME';
                              final isFavoutie = jobPost.isFavourite;
                              final isRemote = jobType == 'REMOTE';

                              final thumbnail = jobPost.thumbnail ?? '';
                              String companyLogo;

                              if (thumbnail.isEmpty) {
                                companyLogo = 'assets/images/noImage.png'; // Fallback for empty
                              } else if (thumbnail.startsWith('http')) {
                                companyLogo = thumbnail; // Use direct URL
                              } else {
                                companyLogo = ApiEndPoint.imageUrl + thumbnail; // Prepend base URL for local paths
                              }


                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: JobCard(
                                  companyName: companyName, // Safely passed
                                  location: location,       // Safely passed
                                  jobTitle: jobTitle,       // Safely passed
                                  salaryRange: salaryRange, // Safely passed
                                  timePosted: timePosted,   // Safely passed
                                  isFullTime: isFullTime,   // Safely passed (bool)
                                  companyLogo: companyLogo, // Safely passed
                                  showFavoriteButton: true,
                                  isSaved: false, // Must be determined by API data, using false as default
                                  isRemote: isRemote,       // Safely passed (bool)
                                  isFavorite: isFavoutie,
                                  onTap: () {
                                    // Check if ID is available before navigating
                                    if (jobPost.id != null && jobPost.id!.isNotEmpty) {
                                      print("Job tapped: ${jobPost.id}");
                                      Get.toNamed(JobSeekerRoutes.jobDetails,arguments: jobPost.id);
                                    }
                                  },
                                  onFavoriteTap: () {
                                    // Check if ID is available before toggling favorite
                                    final jobId = jobPost.id;
                                    if (jobId != null && jobId.isNotEmpty) {
                                      controller.toggleFavorite(jobId);
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  SliverToBoxAdapter(child: 20.height),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: const CommonBottomNavBar(currentIndex: 0),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return month >= 1 && month <= 12 ? months[month] : 'Jan';
  }
}