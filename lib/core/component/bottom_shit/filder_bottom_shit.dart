import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../features/job_seeker/home/presentation/controller/home_controller.dart';

class FilterBottomSheet extends StatefulWidget {
  final VoidCallback? onApply;
  final VoidCallback? onClose;

  const FilterBottomSheet({
    super.key,
    this.onApply,
    this.onClose,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final HomeController controller = Get.find<HomeController>();

  // Controllers
  final TextEditingController minSalaryController = TextEditingController();
  final TextEditingController maxSalaryController = TextEditingController();

  // State variables
  String? selectedCategory;
  List<String> selectedEmployeeTypes = [];
  List<String> selectedJobTypes = [];
  String? selectedExperienceLevel;

  @override
  void initState() {
    super.initState();
    // Initialize with current filter values
    minSalaryController.text = controller.minSalary.value > 0
        ? controller.minSalary.value.toString()
        : '';
    maxSalaryController.text = controller.maxSalary.value < 100000
        ? controller.maxSalary.value.toString()
        : '';
    selectedCategory = controller.selectedCategory.value.isEmpty
        ? null
        : controller.selectedCategory.value;
    selectedEmployeeTypes = List.from(controller.selectedJobTypes);
    selectedJobTypes = List.from(controller.selectedJobLevels);
    selectedExperienceLevel = controller.selectedExperienceLevel.value.isEmpty
        ? null
        : controller.selectedExperienceLevel.value;
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
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(context),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Category Section
                  _buildCategorySection(),

                  SizedBox(height: 20.h),

                  // Job Type Section (FULL_TIME, PART_TIME)
                  _buildEmployeeTypeSection(),

                  SizedBox(height: 20.h),

                  // Job Level Section (ENTRY_LEVEL, MID_LEVEL, SENIOR_LEVEL)
                  _buildJobLevelSection(),

                  SizedBox(height: 20.h),

                  // Experience Level Section
                  _buildExperienceLevelSection(),

                  SizedBox(height: 20.h),

                  // Salary Range Section
                  _buildSalaryRangeSection(),

                  SizedBox(height: 24.h),

                  // Buttons Row
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

  // Header with title and close button
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 24.w),
          CommonText(
            text: 'Filter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.close, size: 24.sp, color: AppColors.black),
          ),
        ],
      ),
    );
  }

  // Category Dropdown Section
  Widget _buildCategorySection() {
    return Obx(() {
      final categories = controller.categories;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: 'Category',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.borderColor, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                hint: Text('Select Category'),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.black,
                  size: 24.sp,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryText,
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Categories'),
                  ),
                  ...categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['id'],
                      child: Text(category['name'] ?? ''),
                    );
                  }).toList(),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  // Job Type Chips Section (FULL_TIME, PART_TIME)
  Widget _buildEmployeeTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Job Type',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildMultiSelectChip(
              label: 'Full Time',
              value: 'FULL_TIME',
              selectedList: selectedEmployeeTypes,
            ),
            _buildMultiSelectChip(
              label: 'Part Time',
              value: 'PART_TIME',
              selectedList: selectedEmployeeTypes,
            ),
            _buildMultiSelectChip(
              label: 'Contract',
              value: 'CONTRACT',
              selectedList: selectedEmployeeTypes,
            ),
          ],
        ),
      ],
    );
  }

  // Job Level Section (ENTRY_LEVEL, MID_LEVEL, SENIOR_LEVEL)
  Widget _buildJobLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Job Level',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildMultiSelectChip(
              label: 'Entry Level',
              value: 'ENTRY_LEVEL',
              selectedList: selectedJobTypes,
            ),
            _buildMultiSelectChip(
              label: 'Mid Level',
              value: 'MID_LEVEL',
              selectedList: selectedJobTypes,
            ),
            _buildMultiSelectChip(
              label: 'Senior Level',
              value: 'SENIOR_LEVEL',
              selectedList: selectedJobTypes,
            ),
          ],
        ),
      ],
    );
  }

  // Experience Level Section
  Widget _buildExperienceLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Experience Level',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildSingleSelectChip(label: '0-1yrs', value: '0-1yrs'),
            _buildSingleSelectChip(label: '1-3yrs', value: '1-3yrs'),
            _buildSingleSelectChip(label: '3-5yrs', value: '3-5yrs'),
            _buildSingleSelectChip(label: '5+yrs', value: '5+yrs'),
          ],
        ),
      ],
    );
  }

  // Multi-select Chip Widget
  Widget _buildMultiSelectChip({
    required String label,
    required String value,
    required List<String> selectedList,
  }) {
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
          color: isSelected ? AppColors.primaryColor : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.borderColor,
            width: 1,
          ),
        ),
        child: CommonText(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? AppColors.white : AppColors.primaryText,
        ),
      ),
    );
  }

  // Single-select Chip Widget
  Widget _buildSingleSelectChip({
    required String label,
    required String value,
  }) {
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
          color: isSelected ? AppColors.secondaryPrimary : AppColors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isSelected ? AppColors.secondaryPrimary : AppColors.borderColor,
            width: 1,
          ),
        ),
        child: CommonText(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? AppColors.white : AppColors.primaryText,
        ),
      ),
    );
  }

  // Salary Range Section
  Widget _buildSalaryRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Salary Range',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: 'Min Salary',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 6.h),
                  CommonTextField(
                    controller: minSalaryController,
                    hintText: '\$0',
                    keyboardType: TextInputType.number,
                    paddingVertical: 12,
                    paddingHorizontal: 12,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: 'Max Salary',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 6.h),
                  CommonTextField(
                    controller: maxSalaryController,
                    hintText: '\$100000',
                    keyboardType: TextInputType.number,
                    paddingVertical: 12,
                    paddingHorizontal: 12,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Buttons Row (Clear & Apply)
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
              controller.clearFilters();
              Get.back();
              widget.onApply?.call();
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
              // Parse salary values
              int minPrice = int.tryParse(minSalaryController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
              int maxPrice = int.tryParse(maxSalaryController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 100000;

              // Apply filters
              controller.applyFilters(
                category: selectedCategory,
                minPrice: minPrice,
                maxPrice: maxPrice,
                jobTypes: selectedEmployeeTypes,
                jobLevels: selectedJobTypes,
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