// lib/features/company/screens/company_overview_screen.dart

import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/company_overview_controller.dart';
import '../widgets/company_overview_widgets.dart';

class CompanyOverviewScreen extends StatefulWidget {
  const CompanyOverviewScreen({super.key});

  @override
  State<CompanyOverviewScreen> createState() => _CompanyOverviewScreenState();
}

class _CompanyOverviewScreenState extends State<CompanyOverviewScreen> {
  int selectedTabIndex = 0;
  final controller = Get.put(CompanyOverviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: CommonAppbar(title: 'Company Overview'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.companyData.value == null) {
          return const Center(
            child: Text('No company data available'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Header with Company Image and Logo
              CompanyHeroHeader(
                companyImage: controller.companyImage.isNotEmpty
                    ? controller.companyImage
                    : AppImages.imageBackground,
                companyLogo: controller.companyLogo.isNotEmpty
                    ? controller.companyLogo
                    : AppImages.companyLogo,
              ),

              // Company Name and Tagline
              CompanyNameSection(
                companyName: controller.companyName,
                tagline: controller.tagline,
              ),

              20.height,

              // Tab Navigation
              CompanyTabNavigation(
                selectedIndex: selectedTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedTabIndex = index;
                  });
                },
              ),

              24.height,

              // Tab Content
              _buildTabContent(),

              24.height,
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0: // Home Tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Section
            const CompanySectionTitle(title: 'Overview'),
            12.height,
            CompanyOverviewContent(
              description: controller.overviewDescription.isNotEmpty
                  ? controller.overviewDescription
                  : 'No overview available',
            ),
            24.height,

            // Gallery Section
            if (controller.galleryImages.isNotEmpty) ...[
              const CompanySectionTitle(title: 'Gallery'),
              12.height,
              CompanyGalleryGrid(
                images: controller.galleryImages,
                crossAxisCount: 4,
              ),
            ] else ...[
              const CompanySectionTitle(title: 'Gallery'),
              12.height,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('No gallery images available'),
              ),
            ],
          ],
        );

      case 1: // About Tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CompanySectionTitle(title: 'About Us'),
            12.height,
            CompanyAboutContent(
              aboutText: controller.aboutDescription.isNotEmpty
                  ? controller.aboutDescription
                  : 'No information available',
            ),
          ],
        );

      case 2: // Jobs Tab
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CompanySectionTitle(title: 'Open Positions'),
            12.height,
            if (controller.companyJobs.isNotEmpty)
              CompanyJobsList(
                jobs: controller.companyJobs,
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('No open positions available'),
              ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}