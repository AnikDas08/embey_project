import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/utils/extensions/extension.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Payment List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                physics: const BouncingScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (context, index) => 16.height,
                itemBuilder: (context, index) {
                  return _buildPaymentItem(context);
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

  Widget _buildPaymentItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentDetailScreen()),
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
                  const CommonText(
                    text: 'Premium Plan',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  6.height,
                  CommonText(
                    text: '01 Dec 2025 At 10:30pm',
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
                const CommonText(
                  text: '\$19.99',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                6.height,
                const CommonText(
                  text: 'Successful',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10B981),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


