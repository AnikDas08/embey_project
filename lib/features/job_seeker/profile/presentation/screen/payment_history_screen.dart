import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/utils/extensions/extension.dart';
import '../controller/profile_controller.dart';

class JobSeekerPaymentHistory extends StatefulWidget {
  final List<dynamic> transactions;

  const JobSeekerPaymentHistory({
    super.key,
    required this.transactions,
  });

  @override
  State<JobSeekerPaymentHistory> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<JobSeekerPaymentHistory> {
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfileController>();
    print("🔍 initState - Controller found");
    print("🔍 Controller hashCode: ${controller.hashCode}");
    print("🔍 Passed transactions length: ${widget.transactions.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Payment List - Use passed transactions directly
            widget.transactions.isEmpty
                ? Expanded(
              child: Center(
                child: CommonText(
                  text: 'No payment history found',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            )
                : Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                physics: const BouncingScrollPhysics(),
                itemCount: widget.transactions.length,
                separatorBuilder: (context, index) => 16.height,
                itemBuilder: (context, index) {
                  final transaction = widget.transactions[index];
                  return _buildPaymentItem(context, transaction, controller);
                },
              ),
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
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.sp,
              color: Colors.black87,
            ),
          ),
          Expanded(
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

  Widget _buildPaymentItem(BuildContext context, dynamic transaction, ProfileController controller) {
    final String name = transaction['name'] ?? 'N/A';
    final double price = (transaction['price'] ?? 0).toDouble();
    final String status = transaction['status'] ?? 'N/A';
    final String createdAt = transaction['createdAt'] ?? '';
    final String transactionId = transaction['_id'] ?? '';

    return GestureDetector(
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentDetailScreen(
              transaction: transaction,
            ),
          ),
        );*/
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAFF),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.workspace_premium,
                color: const Color(0xFF4A5FFF),
                size: 24.sp,
              ),
            ),

            16.width,

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: name,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  6.height,
                  CommonText(
                    text: controller.formatDateTime(createdAt),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),

            // Price and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CommonText(
                  text: '\$${price.toStringAsFixed(2)}',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                6.height,
                CommonText(
                  text: status.capitalize ?? status,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: status.toLowerCase() == 'active'
                      ? const Color(0xFF10B981)
                      : Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
class PaymentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const PaymentDetailScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfileController>();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transaction.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const Expanded(
                child: Center(
                  child: CommonText(
                    text: 'Transaction not found',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final String name = widget.transaction['name'] ?? 'N/A';
    final double price = (widget.transaction['price'] ?? 0).toDouble();
    final String status = widget.transaction['status'] ?? 'N/A';
    final String startDate = widget.transaction['startDate'] ?? '';
    final String endDate = widget.transaction['endDate'] ?? '';
    final String createdAt = widget.transaction['createdAt'] ?? '';
    final String txId = widget.transaction['txId'] ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
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
                              text: '\$${price.toStringAsFixed(2)}',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFF9800),
                            ),
                            // Service Information
                            _buildSectionHeader(
                              'Service Information',
                              status.capitalize ?? status,
                            ),

                            8.height,

                            CommonText(
                              text: name,
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

                            _buildInfoRow('Name', controller.name.value),
                            const Divider(),
                            12.height,
                            _buildInfoRow(
                              'Location',
                              controller.address.value.isNotEmpty
                                  ? controller.address.value
                                  : 'N/A',
                            ),
                            const Divider(),
                            12.height,
                            _buildInfoRow('E-Mail', controller.email.value),
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
                              '\$${price.toStringAsFixed(2)}',
                            ),
                            const Divider(),
                            12.height,
                            _buildPaymentDetailRow('Transaction ID', txId),
                            const Divider(),
                            12.height,
                            _buildPaymentDetailRow(
                              'Date & Time',
                              controller.formatDateTime(createdAt),
                            ),
                            const Divider(),
                            12.height,
                            _buildPaymentDetailRow(
                              'Start Date',
                              controller.formatDateTime(startDate),
                            ),
                            const Divider(),
                            12.height,
                            _buildPaymentDetailRow(
                              'End Date',
                              controller.formatDateTime(endDate),
                            ),
                            const Divider(),
                            12.height,
                            _buildPaymentDetailRow('Tax', '\$0.00'),
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
                              text: 'Total: ',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            CommonText(
                              text: '\$${price.toStringAsFixed(2)}',
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
              ),
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
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.sp,
              color: Colors.black87,
            ),
          ),
          Expanded(
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
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: CommonText(
              text: badge,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badge.toLowerCase() == 'active'
                  ? AppColors.success
                  : Colors.orange,
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
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        onPressed: () {
          // Handle download action
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: const CommonText(
          text: 'Download Payment History',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}*/
