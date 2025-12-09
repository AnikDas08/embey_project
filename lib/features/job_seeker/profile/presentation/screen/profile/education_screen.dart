import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../controller/education_controller.dart';
import 'add_education_screen.dart';
import 'edit_education_screen.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EducationController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CommonText(
          text: 'Education',
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: AppColors.black,
        ),
      ),
      body: SafeArea(
        child: GetBuilder<EducationController>(
          builder: (controller) {
            if (controller.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.success,
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Obx(() {
                      if (controller.educationList.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 100.h),
                          child: Center(
                            child: CommonText(
                              text: 'No education added yet',
                              fontSize: 16.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 20.h),
                        itemCount: controller.educationList.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final education = controller.educationList[index];
                          return _buildEducationCard(
                            context: context,
                            degree: education.degree ?? 'N/A',
                            institute: education.institute ?? 'N/A',
                            session: education.session ?? 'N/A',
                            passingYear: education.passingYear?.toString() ?? 'N/A',
                            gpa: education.grade ?? 'N/A',
                            educationId: education.id ?? '',
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditEducationScreen(
                                    education: education,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CommonButton(
            titleText: 'Add New',
            buttonHeight: 50.h,
            titleSize: 16.sp,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEducationScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEducationCard({
    required BuildContext context,
    required String degree,
    required String institute,
    required String session,
    required String passingYear,
    required String gpa,
    required String educationId,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonText(
                  text: degree,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: onEdit,
                child: CommonImage(
                  imageSrc: AppIcons.edit,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CommonText(
            text: institute,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
          SizedBox(height: 4.h),
          _buildLabel('Session', session),
          SizedBox(height: 4.h),
          _buildLabel('Passing Year', passingYear),
          SizedBox(height: 4.h),
          _buildLabel('Grade Point', gpa),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, String secondText) {
    return Row(
      children: [
        CommonText(
          text: '$text: ',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
        ),
        CommonText(
          text: secondText,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
        ),
      ],
    );
  }
}