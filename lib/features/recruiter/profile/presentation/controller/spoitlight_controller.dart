// career_spotlight_controller.dart

import 'package:embeyi/core/services/api/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../data/model/canrrer_spoitlignt_model.dart';
// Import your model file
// import 'package:embeyi/features/recruiter/profile/data/models/career_spotlight_model.dart';

class CareerSpotlightController extends GetxController {
  final Dio _dio = Dio();

  // Observable variables
  final isLoading = false.obs;
  final spotlights = <Spotlight>[].obs;
  final activeCount = 0.obs;
  final pendingCount = 0.obs;
  RxString image="".obs;

  @override
  void onInit() {
    super.onInit();
    fetchSpotlights();
  }

  Future<void> fetchSpotlights() async {
    try {
      isLoading.value = true;
      final response=await ApiService.get(
        "spotlight",
        header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        final spotlightResponse = CareerSpotlightResponse.fromJson(response.data);
        final data=response.data["data"];

        spotlights.value = spotlightResponse.data.spotlights;
        activeCount.value = spotlightResponse.data.stats.activeSpotlights;
        pendingCount.value = spotlightResponse.data.stats.pendingSpotlights;
        pendingCount.value = spotlightResponse.data.stats.pendingSpotlights;
        //image.value = response.data["data"]["spotlights"][0]["cover_image"];
        print("image data ${image.value} 🤣🤣🤣🤣");
      }
    } catch (e) {
      // Handle error
      Get.snackbar(
        'Error',
        'Failed to fetch spotlights: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Filter approved spotlights
  List<Spotlight> get approvedSpotlights {
    return spotlights.where((spot) => spot.isActive).toList();
  }

  // Filter pending spotlights
  List<Spotlight> get pendingSpotlights {
    return spotlights.where((spot) => spot.isPending).toList();
  }

  // Get image URL (you may need to prepend base URL)
  String getImageUrl(String path) {
    // Replace with your actual image base URL
    return ApiEndPoint.imageUrl+path;
  }

  // Refresh data
  Future<void> refreshSpotlights() async {
    await fetchSpotlights();
  }
}