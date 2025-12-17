import 'package:embeyi/core/services/storage/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import '../../../core/config/route/app_routes.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants/app_images.dart';
import '../../../core/component/image/common_image.dart';
import '../../../core/services/storage/storage_services.dart';
import '../../../core/utils/enum/enum.dart';
import '../../../core/config/route/job_seeker_routes.dart';
import '../../../core/config/route/recruiter_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _initializeApp();
    super.initState();
  }

  Future<void> _initializeApp() async {
    // Load all stored data
    await LocalStorage.getAllPrefData();

    // Wait for splash screen duration
    await Future.delayed(const Duration(seconds: 3));

    // Navigate based on login status and role
    if (LocalStorage.isLogIn) {
      // User is logged in, navigate to appropriate home screen based on role
      if (LocalStorage.role=="jobSeeker") {
        // Navigate to recruiter home
        print("a 🤣🤣🤣🤣${LocalStorage.userRole!.name}");
        print("User Role : 😍😍😍😍 kdfdk ${LocalStorage.role}");
        Get.offAllNamed(JobSeekerRoutes.home);
      } else {
        // Navigate to job seeker home
        print("b 🤣🤣🤣🤣${LocalStorage.userRole!.name}");
        print("User Role : 😍😍😍😍 kdfdk ${LocalStorage.role}");
        LocalStorage.userRole==UserRole.employer;
        Get.offAllNamed(RecruiterRoutes.home);
      }
    } else {
      // User is not logged in, check if role is already selected
      if (LocalStorage.userRole != UserRole.jobSeeker) {
        // Role is selected, go to sign in
        Get.offAllNamed(AppRoutes.onboarding);
      } else {
        // No role selected, go to onboarding
        Get.offAllNamed(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CommonImage(imageSrc: AppImages.logo).center);
  }
}
