import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
// import 'package:embeyi/core/utils/constants/app_images.dart'; // No longer needed
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart'; // Import GetX

// Import your controller


// Hero Banner Widget with Carousel
class HeroBanner extends StatefulWidget {
  // We can remove the bannerImage parameter as it comes from the Controller
  final VoidCallback? onTap;

  const HeroBanner({super.key, this.onTap});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  // 1. Get the instance of the controller
  final HomeController _controller = Get.find<HomeController>();

  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
  CarouselSliderController();

  // 2. The local list is no longer needed, we'll use the controller's list directly
  // final List<String> _bannerImages = [...];


  @override
  Widget build(BuildContext context) {
    // 3. Use an Obx widget to react to changes in the controller's bannerImages list
    return Obx(() {
      final List<String> images = _controller.bannerImages;

      // Handle the case where the list is empty (e.g., waiting for API response)
      if (images.isEmpty) {
        // You can return a loading spinner, a placeholder, or SizedBox.shrink()
        return SizedBox(height: 160.h, child: Center(child: CircularProgressIndicator()));
      }

      return Column(
        children: [
          CarouselSlider.builder(
            carouselController: _carouselController,
            // Use the image list from the controller
            itemCount: images.length,
            itemBuilder: (context, index, realIndex) {
              return GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      ApiEndPoint.imageUrl+images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 160.h,
              viewportFraction: 1,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 1500),
              autoPlayCurve: Curves.fastOutSlowIn,
              initialPage: _currentIndex,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          12.height,
          // Custom Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // Use the image list from the controller to build the dots
            children: images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () async {
                  await _carouselController.animateToPage(entry.key);
                },
                child: Container(
                  width: _currentIndex == entry.key ? 24.w : 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: _currentIndex == entry.key
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withOpacity(0.3),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}