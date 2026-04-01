import 'package:embeyi/core/component/card/job_card.dart';
import 'package:embeyi/core/config/route/job_seeker_routes.dart';
import 'package:embeyi/features/job_seeker/home/presentation/controller/category_detailcontroller.dart';
import 'package:embeyi/features/job_seeker/home/presentation/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class CategoryDetails extends StatelessWidget {
  CategoryDetails({super.key});
  final controller = Get.put(CategoryDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.categoryName.value)),
      ),
      body: Column(
        children: [
          // Search Bar - Fixed at top
          Padding(
            padding: EdgeInsets.all(20.w),
            child: HomeSearchBar(
              onFilterTap: () {
                Get.bottomSheet(
                  isScrollControlled: true,
                  CategoryFilterBottomSheet(
                    controller: controller,
                    onApply: () {
                      // Filters are applied inside the bottom sheet
                    },
                    onClose: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              onChanged: (value) {
                controller.searchJobs(value);
              },
            ),
          ),

          // Pagination Info
          /*Obx(() {
            if (controller.totalJobs.value > 0) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.jobPost.length} of ${controller.totalJobs.value} jobs',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (controller.currentPage.value > 1)
                      Text(
                        'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),*/

          // Job List - Scrollable with pagination
          Expanded(
            child: Obx(() {
              // Show loading indicator for initial load
              if (controller.isLoadingJobs.value && controller.jobPost.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              // Show empty state
              if (controller.jobPost.isEmpty && !controller.isLoadingJobs.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work_off, size: 64.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text(
                        'No jobs available',
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Try adjusting your filters',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              // Show job list with pagination
              return RefreshIndicator(
                onRefresh: controller.refreshJobs,
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.jobPost.length + (controller.hasMoreData.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the bottom
                    if (index == controller.jobPost.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Center(
                          child: controller.isLoadingMore.value
                              ? CircularProgressIndicator()
                              : SizedBox.shrink(),
                        ),
                      );
                    }

                    final jobPost = controller.jobPost[index];

                    // Calculate salary range safely
                    final minSalary = jobPost.minSalary ?? 0;
                    final maxSalary = jobPost.maxSalary ?? 0;
                    final salaryRange = '\$$minSalary - \$$maxSalary/month';

                    // Get location safely
                    final location = jobPost.location ?? 'Location not specified';

                    // Get job and recruiter titles safely
                    final jobTitle = jobPost.title ?? 'No Title Specified';
                    final companyName = jobPost.recruiter ?? 'Company N/A';

                    // Format deadline date
                    String timePosted = '01 Dec 25';
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
                    final jobBoard = jobPost.jobsBoard;
                    final isFullTime = jobType == 'FULL_TIME';
                    final isRemote = jobType == 'REMOTE';

                    // Get company logo with base URL
                    final thumbnail = jobPost.thumbnail ?? '';
                    String companyLogo;

                    if (thumbnail.isEmpty) {
                      companyLogo = 'assets/images/noImage.png';
                    } else if (thumbnail.startsWith('http')) {
                      companyLogo = thumbnail;
                    } else {
                      companyLogo = ApiEndPoint.imageUrl + thumbnail;
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: JobCard(
                        companyName: companyName,
                        location: location,
                        jobTitle: jobTitle,
                        salaryRange: salaryRange,
                        job_board: jobBoard??"N/A",
                        timePosted: timePosted,
                        isFullTime: isFullTime,
                        companyLogo: companyLogo,
                        showFavoriteButton: true,
                        isSaved: false,
                        isRemote: isRemote,
                        isFavorite: jobPost.isFavourite,
                        isApplied: jobPost.isApplied ?? false,
                        onTap: () {
                          if (jobPost.id != null && jobPost.id!.isNotEmpty) {
                            print("Job tapped: ${jobPost.id}");
                            Get.toNamed(JobSeekerRoutes.jobDetails, arguments: jobPost.id);
                          }
                        },
                        onFavoriteTap: () {
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
            }),
          ),
        ],
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

// CategoryFilterBottomSheet remains the same...
class CategoryFilterBottomSheet extends StatefulWidget {
  final CategoryDetailController controller;
  final VoidCallback? onApply;
  final VoidCallback? onClose;

  const CategoryFilterBottomSheet({
    super.key,
    required this.controller,
    this.onApply,
    this.onClose,
  });

  @override
  State<CategoryFilterBottomSheet> createState() => _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState extends State<CategoryFilterBottomSheet> {
  late TextEditingController minSalaryController;
  late TextEditingController maxSalaryController;
  List<String> selectedEmployeeTypes = [];
  List<String> selectedJobLevels = [];
  String? selectedExperienceLevel;

  @override
  void initState() {
    super.initState();
    minSalaryController = TextEditingController(
        text: widget.controller.minSalary.value > 0
            ? widget.controller.minSalary.value.toString()
            : ''
    );
    maxSalaryController = TextEditingController(
        text: widget.controller.maxSalary.value < 100000
            ? widget.controller.maxSalary.value.toString()
            : ''
    );
    selectedEmployeeTypes = List.from(widget.controller.selectedJobTypes);
    selectedJobLevels = List.from(widget.controller.selectedJobLevels);
    selectedExperienceLevel = widget.controller.selectedExperienceLevel.value.isEmpty
        ? null
        : widget.controller.selectedExperienceLevel.value;
  }

  @override
  void dispose() {
    minSalaryController.dispose();
    maxSalaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _buildCategoryInfo(),
                  SizedBox(height: 20.h),
                  _buildJobTypeSection(),
                  SizedBox(height: 20.h),
                  _buildJobLevelSection(),
                  SizedBox(height: 20.h),
                  _buildExperienceLevelSection(),
                  SizedBox(height: 20.h),
                  _buildSalaryRangeSection(),
                  SizedBox(height: 24.h),
                  _buildButtonsRow(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 24.w),
          Text('Filter Jobs', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.close, size: 24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryInfo() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.category, color: Colors.blue.shade700, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Filtering in: ${widget.controller.categoryName.value}',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Job Type', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildChip('Full Time', 'FULL_TIME', selectedEmployeeTypes),
            _buildChip('Part Time', 'PART_TIME', selectedEmployeeTypes),
            _buildChip('Contract', 'CONTRACT', selectedEmployeeTypes),
            _buildChip('Remote', 'REMOTE', selectedEmployeeTypes),
          ],
        ),
      ],
    );
  }

  Widget _buildJobLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Job Level', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildChip('Entry Level', 'ENTRY_LEVEL', selectedJobLevels),
            _buildChip('Mid Level', 'MID_LEVEL', selectedJobLevels),
            _buildChip('Senior Level', 'SENIOR_LEVEL', selectedJobLevels),
          ],
        ),
      ],
    );
  }

  Widget _buildExperienceLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Experience Level', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildSingleChip('0-1yrs', '0-1yrs'),
            _buildSingleChip('1-3yrs', '1-3yrs'),
            _buildSingleChip('3-5yrs', '3-5yrs'),
            _buildSingleChip('5+yrs', '5+yrs'),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, String value, List<String> selectedList) {
    final isSelected = selectedList.contains(value);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedList.remove(value);
          } else {
            selectedList.add(value);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: isSelected ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSingleChip(String label, String value) {
    final isSelected = selectedExperienceLevel == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedExperienceLevel = isSelected ? null : value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: isSelected ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSalaryRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Salary Range', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minSalaryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Min \$',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TextField(
                controller: maxSalaryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Max \$',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            titleText: 'Clear All',
            buttonHeight: 48.h,
            buttonRadius: 4,
            titleSize: 16,
            titleWeight: FontWeight.w600,
            buttonColor: AppColors.white,
            titleColor: Colors.white,
            borderColor: AppColors.primaryColor,
            onTap: () {
              widget.controller.clearFilters();
              Get.back();
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CommonButton(
            titleText: 'Apply Filter',
            buttonHeight: 48.h,
            buttonRadius: 4,
            titleSize: 16,
            titleWeight: FontWeight.w600,
            isGradient: true,
            onTap: () {
              int minPrice = int.tryParse(minSalaryController.text) ?? 0;
              int maxPrice = int.tryParse(maxSalaryController.text) ?? 100000;

              widget.controller.applyFilters(
                minPrice: minPrice,
                maxPrice: maxPrice,
                jobTypes: selectedEmployeeTypes,
                jobLevels: selectedJobLevels,
                experienceLevel: selectedExperienceLevel,
              );

              Get.back();
              widget.onApply?.call();
            },
          ),
        ),
      ],
    );
  }
}