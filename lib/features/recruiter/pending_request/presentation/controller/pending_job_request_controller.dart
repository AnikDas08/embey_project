import 'package:embeyi/core/config/route/app_routes.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';

import '../../../home/data/model/application_model.dart';

class PendingJobRequestController extends GetxController {
  // Observable properties
  final RxString selectedCategory = 'All Categories'.obs;
  final RxString selectedCategoryId = ''.obs;

  final RxList<ApplicationData> applications = <ApplicationData>[].obs;
  final RxList<ApplicationData> filteredApplications = <ApplicationData>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isLoadingApplications = true.obs;

  // Category options for dropdown
  final RxList<String> categoryNames = <String>['All Categories'].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await allCategories(); // Load categories first
    await pendingList();   // Then load applications
  }
  Future<void> pendingList() async {
    try {
      isLoading.value = true;
      isLoadingApplications.value = true;

      final response = await ApiService.get("application?status=PENDING");

      if (response.statusCode == 200) {
        final applicationModelList = ApplicationListModel.fromJson(response.data);

        if (applicationModelList.success) {
          applications.value = applicationModelList.data;
          filteredApplications.value = applicationModelList.data;

          print("✅ Applications loaded: ${applications.length}");

          // Debug: Print first application to see structure
          if (applications.isNotEmpty) {
            print("📋 Sample application title: ${applications[0].title}");
          }
        }
      }
    } catch (e) {
      print("❌ Error loading applications: $e");
    } finally {
      isLoading.value = false;
      isLoadingApplications.value = false;
    }
  }

  /// Fetch all job categories from API
  Future<void> allCategories() async {
    try {
      final response = await ApiService.get("job-category");

      if (response.statusCode == 200) {
        var data = response.data['data'] as List;

        categories.assignAll(
            data.map((e) => {
              "id": e['_id'],
              "name": e['name'],
              "jobs": e['jobs'],
            }).toList()
        );

        // Build dropdown list
        categoryNames.value = ['All Categories'];
        categoryNames.addAll(
            categories.map((e) => e['name'] as String).toList()
        );

        print("✅ Categories loaded: ${categories.length}");
        print("📋 Available categories: ${categoryNames}");
      }
    } catch (e) {
      print("❌ Error loading categories: $e");
    }
  }

  /// Select category from dropdown
  void selectCategory(String categoryName) {
    selectedCategory.value = categoryName;

    if (categoryName != 'All Categories') {
      final category = categories.firstWhere(
            (cat) => cat['name'] == categoryName,
        orElse: () => {"id": "", "name": ""},
      );
      selectedCategoryId.value = category['id'] as String;
      print("🔍 Selected: $categoryName (ID: ${selectedCategoryId.value})");
    } else {
      selectedCategoryId.value = '';
      print("🔍 Selected: All Categories");
    }

    _applyFilter();
  }

  /// Apply filter based on selected category
  ///
  /// FILTERING LOGIC:
  /// Since the application response doesn't have a direct category field,
  /// we need to match based on the job title or fetch full post details.
  ///
  /// Current approach: Filter by matching job title keywords with category name
  ///
  /// Example:
  /// - Category: "UX/UI Designer"
  /// - Application title: "Hiring UX Developer"
  /// - Match: Contains "UX" keyword
  void _applyFilter() {
    if (selectedCategory.value == 'All Categories') {
      // Show all applications
      filteredApplications.value = applications;
      print("📊 Showing all: ${filteredApplications.length} applications");
    } else {
      // Filter by matching job title with category name
      // This is a fuzzy match approach since we don't have direct category field

      final categoryKeywords = selectedCategory.value
          .toLowerCase()
          .split(' ')
          .where((word) => word.length > 2) // Only meaningful words
          .toList();

      filteredApplications.value = applications.where((application) {
        final jobTitle = application.title.toLowerCase();

        // Check if job title contains any category keyword
        return categoryKeywords.any((keyword) => jobTitle.contains(keyword));
      }).toList();

      print("🔍 Filter: '${selectedCategory.value}'");
      print("📊 Found: ${filteredApplications.length} applications");

      // Debug: Show which titles matched
      if (filteredApplications.isNotEmpty) {
        print("✅ Matched titles:");
        for (var app in filteredApplications.take(3)) {
          print("   - ${app.title}");
        }
      }
    }
  }

  int get totalRequestCount => filteredApplications.length;

  void viewCandidateProfile(String postId) {
    Get.toNamed(
      RecruiterRoutes.resume,
      arguments: {
        'applicationId': postId,
        'isShortlist': true,
        'isInterview': true,
        'isReject': true
      },
    );
  }
}