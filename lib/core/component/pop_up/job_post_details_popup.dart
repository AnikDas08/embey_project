import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/features/job_seeker/jobs/presentation/widgets/job_details_widgets.dart' hide DescriptionText, JobTitleSection, JobInfoTags;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../features/recruiter/job_post/presentation/widgets/description_text.dart';
import '../../../features/recruiter/job_post/presentation/widgets/job_info_tags.dart';
import '../../../features/recruiter/job_post/presentation/widgets/job_title_section.dart';

class JobPostDetailsPopup extends StatelessWidget {
  const JobPostDetailsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: CommonText(
                        text: 'Preview',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    10.height,
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CommonImage(
                        imageSrc: AppImages.jobDetails,
                        fill: BoxFit.cover,
                      ),
                    ),
                    20.height,

                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                        children: [
                          // Job Title Section
                          const JobTitleSection(
                            jobTitle: 'Senior UI/UX Designer',
                            location:
                                '2IR Thermings Cir, Syracuse, Connecticut, 38024',
                            salary: '\$40,000 - \$80,000',
                          ),

                          10.height,

                          // Job Info Tags
                          const JobInfoTags(
                            isFullTime: true,
                            experience: '2 Yrs+ Experience',
                            postedDate: '3 Days Ago',
                            endDate: '31 Dec',
                          ),

                          10.height,

                          // Company Info
                          const JobDetailsSectionHeader(
                            title: 'Posted 3 Days Ago,  end Date 31 Dec.',
                            color: AppColors.secondaryText,
                          ),
                          8.height,
                        ],
                      ),
                    ),

                    16.height,
                    CommonText(
                      text: 'Job Description',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      bottom: 10,
                    ).start,

                    const DescriptionText(
                      text:
                          'Over The Past 10 Years, We\'ve Helped 250+ Clients Show Up Through High-Performing Websites, Social Content, And Engaging Campaigns That Reduce Cart Abandonment And Helped Our Clients Sell Millions In Products And Services.',
                    ),

                    16.height,

                    const DescriptionText(
                      text:
                          'Award-Winning Work That\'s Done 100% In An In-House Studio',
                    ),

                    16.height,

                    Align(
                      alignment: Alignment.centerLeft,
                      child: const DescriptionText(
                        text: 'Strategic, Clean, Effective',
                      ),
                    ),

                    16.height,

                    Align(
                      alignment: Alignment.centerLeft,
                      child: const DescriptionText(
                        text: 'Field Service Packages Built For Scale',
                      ),
                    ),

                    20.height,

                    // Requirements Section
                    const DescriptionText(
                      text:
                          'We Don\'t Just Talk About High-Performance Marketing',
                    ),

                    12.height,

                    const DescriptionText(
                      text:
                          'LinkedIn: www.linkedin.com/Company/Seriousmarketing/',
                    ),

                    // LinkedIn Link
                    16.height,

                    // Application Instructions
                    const DescriptionText(
                      text:
                          'To move forward with your application, please connect with me on LinkedIn and share your responses there: linkedin.com/in/lizclaydb.',
                    ),

                    24.height,
                  ],
                ),
              ),
            ),
          ),

          // Bottom Apply Button
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(color: AppColors.surfaceBackground),
            child: SafeArea(
              top: false,
              child: CommonButton(
                titleText: 'Publish Now',
                buttonRadius: 8,
                onTap: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
