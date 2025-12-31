import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../data/model/home_model.dart';

class AllJobCategoryController extends GetxController {
  RxString categoryImage = "".obs;
  RxString categoryName = "".obs;
  UserData? profileData;
  RxList<String> bannerImages = <String>[].obs;

  // Original list of all categories
  final RxList<Map<String, dynamic>> allCategories = <Map<String, dynamic>>[].obs;

  // Filtered list (displayed in UI)
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  // Search query
  RxString searchQuery = ''.obs;

  String categoryId = "";
  num? jobs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiService.get(
        ApiEndPoint.Categorys,
        header: {
          "Authorization": "Bearer ${LocalStorage.token}",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        final categoryList = data.map((item) {
          return {
            "id": item['_id'] ?? "",
            "name": item['name'] ?? "",
            "image": item['image'] ?? "assets/images/noImage.png",
            "jobs": item['jobs'] ?? 0,
          };
        }).toList();

        // Store in both lists
        allCategories.value = categoryList;
        categories.value = categoryList;

        update();
      } else {
        Get.snackbar(
          "Error",
          response.message ?? "Failed to load categories",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Search categories by name
  void searchCategories(String query) {
    searchQuery.value = query.trim();

    if (searchQuery.value.isEmpty) {
      // Show all categories if search is empty
      categories.value = allCategories;
    } else {
      // Filter categories by name (case-insensitive)
      categories.value = allCategories.where((category) {
        final categoryName = category['name']?.toString().toLowerCase() ?? '';
        final searchLower = searchQuery.value.toLowerCase();
        return categoryName.contains(searchLower);
      }).toList();
    }

    update();
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    categories.value = allCategories;
    update();
  }
}