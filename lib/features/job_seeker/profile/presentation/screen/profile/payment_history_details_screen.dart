import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import '../../controller/payment_history_controller.dart';

class PaymentDetailScreen extends StatelessWidget {
  const PaymentDetailScreen({super.key});

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yy, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentDetailController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60.sp,
                          color: Colors.red,
                        ),
                        16.height,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: CommonText(
                            text: controller.error.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                        16.height,
                        ElevatedButton(
                          onPressed: () {
                              controller.fetchSubscriptionDetails();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const CommonText(
                            text: 'Retry',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (controller.subscriptionData.value == null) {
                  return const Center(
                    child: CommonText(
                      text: 'No data available',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  );
                }

                final data = controller.subscriptionData.value!;
                final user = data['user'] ?? {};
                final package = data['package'] ?? {};

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        24.height,

                        // Price
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: '\$${data['price'] ?? '0.00'}',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFF9800),
                              ),
                              // Service Information
                              _buildSectionHeader(
                                'Service Information',
                                data['status']?.toString().toUpperCase() ?? 'N/A',
                              ),

                              8.height,

                              CommonText(
                                text: package['name'] ?? 'N/A',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),

                        24.height,

                        // User Information
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildSectionHeader('User Information', null),

                              16.height,

                              _buildInfoRow('Name', user['name'] ?? 'N/A'),
                              const Divider(),
                              12.height,
                              _buildInfoRow(
                                'Location',
                                user['address'] ?? 'N/A',
                              ),
                              const Divider(),
                              12.height,
                              _buildInfoRow('E-Mail', user['email'] ?? 'N/A'),
                            ],
                          ),
                        ),

                        24.height,

                        // Payment Details
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildSectionHeader('Payment Details', null),
                              16.height,
                              _buildPaymentDetailRow(
                                'Service Fee',
                                '\$${data['price'] ?? '0.00'}',
                              ),
                              const Divider(),
                              12.height,
                              _buildPaymentDetailRow(
                                'Transaction ID',
                                data['txId'] ?? 'N/A',
                              ),
                              const Divider(),
                              12.height,
                              _buildPaymentDetailRow(
                                'Start Date',
                                _formatDate(data['startDate']),
                              ),
                              const Divider(),
                              12.height,
                              _buildPaymentDetailRow(
                                'End Date',
                                _formatDate(data['endDate']),
                              ),
                              const Divider(),
                              12.height,
                              _buildPaymentDetailRow('Tax', '0.0¢'),
                            ],
                          ),
                        ),

                        16.height,

                        // Total
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const CommonText(
                                text: 'Total:  ',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              CommonText(
                                text: '\$${data['price'] ?? '0.00'}',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),

                        32.height,

                        // Download Button
                        _buildDownloadButton(),

                        40.height,
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.sp,
              color: Colors.black87,
            ),
          ),
          const Expanded(
            child: Center(
              child: CommonText(
                text: 'Payment History',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        if (badge != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: badge.toLowerCase() == 'active'
                  ? AppColors.success.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: CommonText(
              text: badge,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badge.toLowerCase() == 'active'
                  ? AppColors.success
                  : Colors.grey,
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 80.w,
          child: CommonText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: CommonText(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade600,
        ),
        Flexible(
          child: CommonText(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton() {
    final controller = Get.find<PaymentDetailController>();
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        onPressed: controller.isDownloading.value
            ? null
            : () {
          controller.downloadPaymentHistory();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: controller.isDownloading.value
            ? SizedBox(
          height: 20.h,
          width: 20.w,
          child: const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        )
            : const CommonText(
          text: 'Download Payment History',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    ));
  }
}