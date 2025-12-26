import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';

class InterviewSchedulePopup extends StatefulWidget {
  final String? initialDate;
  final String? initialTime;
  final String? initialInterviewType;
  final String? initialNote;
  final Function(String date, String time, String interviewType, String note)?
  onSubmit;

  const InterviewSchedulePopup({
    super.key,
    this.initialDate,
    this.initialTime,
    this.initialInterviewType,
    this.initialNote,
    this.onSubmit,
  });

  @override
  State<InterviewSchedulePopup> createState() => _InterviewSchedulePopupState();
}

class _InterviewSchedulePopupState extends State<InterviewSchedulePopup> {
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _noteController;
  String _selectedInterviewType = 'Onsite';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: widget.initialDate ?? '01 Oct 2025',
    );
    _timeController = TextEditingController(
      text: widget.initialTime ?? '09:00 Am',
    );
    _noteController = TextEditingController(text: widget.initialNote ?? '');
    _selectedInterviewType = widget.initialInterviewType ?? 'Onsite';
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CommonText(
                        text: 'Interview Schedule',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.close,
                          color: AppColors.black,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
            
                SizedBox(height: 24.h),
            
                // Date Input Field
                _buildLabel('Date'),
                SizedBox(height: 8.h),
                _buildDateField(),
            
                SizedBox(height: 20.h),
            
                // Time Input Field
                _buildLabel('Time'),
                SizedBox(height: 8.h),
                _buildTimeField(),
            
                SizedBox(height: 20.h),
            
                // Interview Type Selection
                _buildLabel('Interview Type'),
                SizedBox(height: 12.h),
                _buildInterviewTypeSelection(),
            
                SizedBox(height: 20.h),
            
                // Note Text Area
                _buildLabel('Note'),
                SizedBox(height: 8.h),
                _buildNoteField(),
            
                SizedBox(height: 24.h),
            
                // Submit Button
                CommonButton(
                  titleText: 'Submit',
                  buttonHeight: 52,
                  buttonRadius: 12,
                  onTap: _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return CommonText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor, width: 1),
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _dateController,
                enabled: false,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: AppColors.textFiledColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return GestureDetector(
      onTap: _selectTime,
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor, width: 1),
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _timeController,
                enabled: false,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Icon(
              Icons.access_time,
              color: AppColors.textFiledColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterviewTypeSelection() {
    return Row(
      children: [
        Expanded(
          child: _buildInterviewTypeOption(
            'Onsite',
            _selectedInterviewType == 'Onsite',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildInterviewTypeOption(
            'Remote',
            _selectedInterviewType == 'Remote',
          ),
        ),
      ],
    );
  }

  Widget _buildInterviewTypeOption(String type, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedInterviewType = type;
        });
      },
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.borderColor,
                  width: 2,
                ),
                color: isSelected ? AppColors.primaryColor : AppColors.white,
              ),
              child: isSelected
                  ? Icon(Icons.circle, color: AppColors.white, size: 8.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            CommonText(
              text: type,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return Container(
      width: double.infinity,
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.white,
      ),
      child: TextField(
        controller: _noteController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.black,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Type Here',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textFiledColor,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _formatTime(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'Am' : 'Pm';
    return '$hour:$minute $period';
  }

  void _onSubmit() {
    if (widget.onSubmit != null) {
      widget.onSubmit!(
        _dateController.text,
        _timeController.text,
        _selectedInterviewType,
        _noteController.text,
      );
    }
    Get.back();
  }
}
