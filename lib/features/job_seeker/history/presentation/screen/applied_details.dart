// screens/applied_details_screen.dart

import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/model/application_details_models.dart';
import '../controller/application_details_controller.dart';
import '../widgets/history_widgets.dart';

class AppliedDetails extends StatelessWidget {
  AppliedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Get applicationId from arguments
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String applicationId = args['applicationId'] ?? '';

    if (applicationId.isEmpty) {
      return Scaffold(
        appBar: CommonAppbar(
          title: 'Application Details',
          centerTitle: true,
          showBackButton: true,
        ),
        body: const Center(
          child: Text('Invalid application ID'),
        ),
      );
    }

    // Initialize controller with applicationId
    final controller = Get.put(
      AppliedDetailsController(applicationId: applicationId),
      tag: applicationId,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppbar(
        title: 'Application Details',
        centerTitle: true,
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = controller.applicationDetail.value;

        if (detail == null) {
          return const Center(
            child: Text('No application details found'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchApplicationDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Application Header Card
                  ApplicationDetailsHeaderCard(
                    hiringStatus: detail.hiringStatus,
                    jobTitle: detail.post.title.isNotEmpty
                        ? detail.post.title
                        : detail.title,
                    companyName: detail.user.name,
                    location: detail.post.location,
                    status: controller.currentStatus,
                    companyLogo: controller.getImageUrl(
                        detail.post.thumbnail.isNotEmpty
                            ? detail.post.thumbnail
                            : detail.user.image
                    ),
                  ),

                  24.height,

                  // Application Timeline Section
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DetailsSectionHeader(title: 'Application Timeline'),
                        20.height,
                        _buildTimeline(detail.history),
                      ],
                    ),
                  ),

                  24.height,

                  // Attachment Section
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DetailsSectionHeader(title: 'Attachment'),
                        20.height,
                        _buildAttachments(
                          controller,
                          detail.resume,
                          detail.otherDocuments,
                        ),
                      ],
                    ),
                  ),

                  // Rejection Reason Section (if rejected) - Now under attachments
                  if (controller.isRejected)
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFEEEEE),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFFF5900),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.red,
                                  size: 20.sp,
                                ),
                                8.width,
                                CommonText(
                                  text: 'Rejection Reason',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.red,
                                ),
                              ],
                            ),
                            12.height,
                            CommonText(
                              text: detail.rejectionReason??"No Reject Reason",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                              maxLines: 100,
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),

                  24.height,
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTimeline(List<History> history) {
    if (history.isEmpty) {
      return const TimelineItem(
        title: 'Applied',
        subtitle: 'Pending',
        isCompleted: false,
        isLast: true,
      );
    }

    return Column(
      children: history.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == history.length - 1;

        return TimelineItem(
          title: item.title,
          subtitle: DateFormat('dd MMM yyyy').format(item.date),
          isCompleted: true,
          isLast: isLast,
        );
      }).toList(),
    );
  }

  // Updated method to handle PDF opening
  Future<void> _openDocument(String fileUrl, String fileName) async {
    try {
      final Uri url = Uri.parse(fileUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not open $fileName',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open document: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Widget _buildAttachments(
      AppliedDetailsController controller,
      String resume,
      List<String> otherDocuments,
      ) {
    List<Widget> attachments = [];

    // Add resume
    if (resume.isNotEmpty) {
      attachments.add(
        AttachmentCard(
          fileName: controller.getFileName(resume),
          fileType: 'PDF Document',
          fileSize: '---',
          fileUrl: controller.getDocumentUrl(resume),
          onTap: () {
            _openDocument(
              controller.getDocumentUrl(resume),
              controller.getFileName(resume),
            );
          },
        ),
      );
    }

    // Add other documents
    for (var doc in otherDocuments) {
      if (doc.isNotEmpty) {
        attachments.add(
          AttachmentCard(
            fileName: controller.getFileName(doc),
            fileType: 'PDF Document',
            fileSize: '---',
            fileUrl: controller.getDocumentUrl(doc),
            onTap: () {
              _openDocument(
                controller.getDocumentUrl(doc),
                controller.getFileName(doc),
              );
            },
          ),
        );
      }
    }

    if (attachments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No attachments available'),
        ),
      );
    }

    return Column(children: attachments);
  }
}