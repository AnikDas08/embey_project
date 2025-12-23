import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../controller/certificate_controller.dart';
import '../../data/model/resume_model.dart';
import '../widgets/add_certificate_dialog.dart';

class CertificationScreen extends StatelessWidget {
  const CertificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller - it will automatically fetch data in onInit
    final controller = Get.put(CertificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const CommonText(
          text: 'Certification',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      body: Obx(() {
        // Show loading indicator while fetching data
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        // Show the form once data is loaded
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add Skills Title (as per design)
                        const CommonText(
                          text: 'Add Skills',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        16.height,

                        // Certification List
                        Obx(() {
                          if (controller.certifications.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: const CommonText(
                                  text: 'No certifications added yet',
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.certifications.length,
                            separatorBuilder: (context, index) => 16.height,
                            itemBuilder: (context, index) {
                              final certification =
                              controller.certifications[index];
                              return _buildCertificationCard(
                                context,
                                certification,
                                index,
                                controller,
                              );
                            },
                          );
                        }),

                        24.height,

                        // Add Other Certification Button
                        GestureDetector(
                          onTap: () {
                            _showAddCertificationDialog(context, controller);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              8.width,
                              const CommonText(
                                text: 'Add Other Certification',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),

                        24.height,
                      ],
                    ),
                  ),
                ),
              ),

              /// Update Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : () => controller.resumeId==""?controller.createResumeWithCertifications():controller.saveCertifications(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        disabledBackgroundColor:
                        AppColors.primary.withOpacity(0.6),
                      ),
                      child: controller.isSaving.value
                          ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : CommonText(
                        text: controller.resumeId==""?'Create':'Update',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCertificationCard(
      BuildContext context,
      Certification certification,
      int index,
      CertificationController controller,
      ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row with Edit/Delete buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonText(
                  text: certification.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              8.width,
              // Edit and Delete buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showEditCertificationDialog(
                        context,
                        controller,
                        certification,
                        index,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  8.width,
                  GestureDetector(
                    onTap: () {
                      _showDeleteDialog(context, controller, index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Description (if available)
          if (certification.description != null &&
              certification.description!.isNotEmpty) ...[
            12.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4.w,
                  height: 4.h,
                  margin: EdgeInsets.only(top: 6.h, right: 8.w),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: certification.description!,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                    maxLines: 20,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showAddCertificationDialog(
      BuildContext context,
      CertificationController controller,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddCertificationDialog(
        onSave: (certification) {
          controller.addCertification(certification);
        },
      ),
    );
  }

  void _showEditCertificationDialog(
      BuildContext context,
      CertificationController controller,
      Certification certification,
      int index,
      ) {
    showDialog(
      context: context,
      builder: (context) => AddCertificationDialog(
        certification: certification,
        onSave: (updatedCertification) {
          controller.updateCertification(index, updatedCertification);
        },
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      CertificationController controller,
      int index,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CommonText(
            text: 'Delete Certification',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          content: const CommonText(
            text: 'Are you sure you want to delete this certification?',
            fontSize: 14,
            maxLines: 2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const CommonText(
                text: 'Cancel',
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.removeCertification(index);
              },
              child: const CommonText(
                text: 'Delete',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}