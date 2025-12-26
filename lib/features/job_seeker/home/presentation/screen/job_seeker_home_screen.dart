import 'package:embeyi/core/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:embeyi/core/component/bottom_shit/filder_bottom_shit.dart';
import 'package:embeyi/core/component/card/job_card.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/job_seeker/notifications/presentation/screen/job_seeker_notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../widgets/home_widgets.dart';
import '../widgets/auto_apply.dart';

class JobSeekerHomeScreen extends StatelessWidget {
  JobSeekerHomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Setup infinite scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // Load more when user is 200px from bottom
        controller.loadMoreJobs();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header Section (Static)
            Obx(() {
              return Container(
                color: AppColors.background,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: HomeHeader(
                  profileImage: controller.image.value,
                  userName: controller.name.value,
                  userRole: controller.designation.value,
                  hasNotification: controller.isNotification.value,
                  onMessageTap: () => RecruiterRoutes.goToChat(),
                  onNotificationTap: () => Get.to(() => JobSeekerNotificationScreen()),
                  onProfileTap: () => JobSeekerRoutes.goToProfile(),
                ),
              );
            }),

            // Scrollable Content wrapped with RefreshIndicator
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await Future.wait([
                    controller.refreshJobs(),
                    controller.getProfile(),
                    controller.getBanner(),
                    controller.fetchCategories(),
                  ]);
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Search Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: HomeSearchBar(
                          onFilterTap: () {
                            Get.bottomSheet(
                              isScrollControlled: true,
                              FilterBottomSheet(
                                onApply: () {},
                                onClose: () => Get.back(),
                              ),
                            );
                          },
                          onChanged: (value) => controller.searchJobs(value),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: 20.height),

                    // Hero Banner
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: HeroBanner(onTap: () {}),
                      ),
                    ),

                    SliverToBoxAdapter(child: 24.height),

                    // Job Category Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: SectionHeader(
                          title: 'Job Category',
                          onSeeAllTap: () => JobSeekerRoutes.goToAllJobCategory(),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: 16.height),

                    // Job Category Horizontal ListView
                    SliverToBoxAdapter(
                      child: Obx(() {
                        final categoriesList = controller.categories;

                        if (categoriesList.isEmpty && controller.isLoadingJobs.value) {
                          return SizedBox(
                            height: 120.h,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (categoriesList.isEmpty) {
                          return SizedBox(
                            height: 100.h,
                            child: Center(
                              child: Text(
                                'No categories available',
                                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 120.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            itemCount: categoriesList.length,
                            itemBuilder: (context, index) {
                              final category = categoriesList[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: SizedBox(
                                  width: 85.w,
                                  child: JobCategoryCard(
                                    imageSrc: category['image'] ?? "",
                                    title: category['name'],
                                    onTap: () {
                                      Get.toNamed(JobSeekerRoutes.categoryDetails, arguments: {
                                        "categoryId": category["id"],
                                        "categoryName": category['name'],
                                      });
                                    },
                                    isJobCountVisible: false,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),

                    SliverToBoxAdapter(child: 24.height),

                    // Recommended Job Header with Pagination Info
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: SectionHeader(
                          title: 'Recommended Job',
                          onSeeAllTap: () => JobSeekerRoutes.goToAllRecommendedJob(),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: 16.height),

                    // Auto Apply Toggle
                    SliverToBoxAdapter(
                      child: Obx(() => AutoApply(
                        isEnabled: controller.autoApplHere.value,
                        onToggle: (value) => controller.toggleAutoApply(value),
                      )),
                    ),

                    // Recommended Job List
                    SliverToBoxAdapter(
                      child: Obx(() {
                        // Check loading state and empty list
                        if (controller.isLoadingJobs.value && controller.jobPost.isEmpty) {
                          return SizedBox(
                            height: 200.h,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        }

                        // Check if list is empty after loading
                        if (controller.jobPost.isEmpty) {
                          return _buildEmptyState();
                        }

                        // Display job list
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.jobPost.length,
                            itemBuilder: (context, index) {
                              final jobPost = controller.jobPost[index];

                              // Formatting logic
                              final salaryRange = '\$${jobPost.minSalary ?? 0} - \$${jobPost.maxSalary ?? 0}/month';
                              final jobType = jobPost.jobType?.toUpperCase();

                              String companyLogo = jobPost.thumbnail?.isEmpty ?? true
                                  ? 'assets/images/noImage.png'
                                  : (jobPost.thumbnail!.startsWith('http')
                                  ? jobPost.thumbnail!
                                  : ApiEndPoint.imageUrl + jobPost.thumbnail!);

                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: JobCard(
                                  companyName: jobPost.recruiter ?? 'Company N/A',
                                  location: jobPost.location ?? 'Remote',
                                  jobTitle: jobPost.title ?? 'No Title',
                                  salaryRange: salaryRange,
                                  timePosted: jobPost.deadline != null
                                      ? '${jobPost.deadline!.day} ${_getMonthName(jobPost.deadline!.month)}'
                                      : 'N/A',
                                  isFullTime: jobType == 'FULL_TIME',
                                  companyLogo: companyLogo,
                                  isFavorite: jobPost.isFavourite ?? false,
                                  isRemote: jobType == 'REMOTE',
                                  onTap: () {
                                    if (jobPost.id != null) {
                                      Get.toNamed(JobSeekerRoutes.jobDetails, arguments: jobPost.id);
                                    }
                                  },
                                  onFavoriteTap: () {
                                    if (jobPost.id != null) controller.toggleFavorite(jobPost.id!);
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),

                    // Load More Indicator
                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (controller.isLoadingMore.value) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        // Show "No more jobs" message if at the end
                        if (!controller.hasMorePages.value && controller.jobPost.isNotEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Center(
                              child: Text(
                                'No more jobs to load',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }

                        return SizedBox(height: 20.h);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(child: CommonBottomNavBar(currentIndex: 0)),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Column(
        children: [
          Icon(Icons.work_off_outlined, size: 64.sp, color: Colors.grey),
          16.height,
          Text(
            'No jobs available',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          8.height,
          Text(
            'Pull down to refresh',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return month >= 1 && month <= 12 ? months[month] : 'Jan';
  }
}