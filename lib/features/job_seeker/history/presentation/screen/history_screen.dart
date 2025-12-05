// screens/history_screen.dart

import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/history_controller.dart';
import '../widgets/history_widgets.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final HistoryController controller = Get.put(HistoryController());

  // Helper method to construct full image URL
  String _getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath;
    return ApiEndPoint.imageUrl + imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppbar(
        title: 'Jobs History',
        centerTitle: true,
        showBackButton: true,
      ),
      body: Column(
        children: [
          16.height,
          _buildTabBar(),
          16.height,
          Obx(() {
            if (controller.currentTabIndex.value == 2) {
              return Column(
                children: [
                  InterviewFilterButtons(
                    selectedIndex: controller.interviewFilterIndex.value,
                    onFilterChanged: (index) {
                      controller.setInterviewFilter(index);
                    },
                  ),
                  16.height,
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          Expanded(child: _buildTabBarView()),
        ],
      ),
      bottomNavigationBar: const SafeArea(
        child: CommonBottomNavBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(
            () => TabBar(
          controller: controller.tabController,
          isScrollable: true,
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(
              child: CustomTabButton(
                title: 'All Jobs',
                isSelected: controller.currentTabIndex.value == 0,
              ),
            ),
            Tab(
              child: CustomTabButton(
                title: 'Rejected Jobs',
                isSelected: controller.currentTabIndex.value == 1,
              ),
            ),
            Tab(
              child: CustomTabButton(
                title: 'Interview',
                isSelected: controller.currentTabIndex.value == 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: controller.tabController,
      children: [
        _buildApplicationListView(isInterview: false),
        _buildApplicationListView(isInterview: false),
        _buildApplicationListView(isInterview: true),
      ],
    );
  }

  Widget _buildApplicationListView({required bool isInterview}) {
    return Obx(() {
      if (controller.isLoading.value && controller.currentPage.value == 1) {
        return const Center(child: CircularProgressIndicator());
      }

      final applications = controller.getCurrentList();

      if (applications.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.refreshCurrentTab,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: Get.height * 0.6,
              child: const EmptyHistoryState(),
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshCurrentTab,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              controller.loadMoreForCurrentTab();
            }
            return false;
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            itemCount: applications.length + (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == applications.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final application = applications[index];

              if (isInterview) {
                return InterviewJobCard(
                  jobTitle: application.post?.title ?? application.title,
                  companyName: application.user?.name ?? 'Unknown Company',
                  location: application.post?.location ?? 'Unknown Location',
                  companyLogo: _getImageUrl(
                      application.post?.thumbnail ?? application.user?.image ?? ''
                  ),
                  interviewDate: application.interviewDateLabel,
                  onTap: () {
                    Get.toNamed(
                      JobSeekerRoutes.appliedDetails,
                      arguments: {
                        'applicationId': application.id,
                        'isRejected': application.status == 'REJECTED',
                        'status': application.displayStatus,
                      },
                    );
                  },
                );
              }

              return ApplicationHistoryCard(
                jobTitle: application.post?.title ?? application.title,
                companyName: application.user?.name ?? 'Unknown Company',
                location: application.post?.location ?? 'Unknown Location',
                companyLogo: _getImageUrl(
                    application.post?.thumbnail ?? application.user?.image ?? ''
                ),
                status: application.history.isNotEmpty
                    ? application.history.last.title
                    : application.displayStatus,
                onTap: () {
                  Get.toNamed(
                    JobSeekerRoutes.appliedDetails,
                    arguments: {
                      'applicationId': application.id,
                      'isRejected': application.status == 'REJECTED',
                      'status': application.history.isNotEmpty
                          ? application.history.last.title
                          : application.displayStatus,
                    },
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }
}