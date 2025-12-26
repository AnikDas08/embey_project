import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';

class EditCompanyProfileController extends GetxController {
  // Text editing controllers
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController overviewController = TextEditingController();

  // Loading states
  RxBool isLoadingProfile = false.obs;
  RxBool isLoadingImage = false.obs;
  RxBool isLoadingUpdate = false.obs;
  RxBool isPickingImage = false.obs; // Prevent multiple rapid taps

  final Rx<RecruiterProfileData?> profileData = Rx<RecruiterProfileData?>(null);

  // Image picker
  final ImagePicker _picker = ImagePicker();

  // Observable states
  final RxString coverPhotoPath = ''.obs;
  final RxString companyLogoPath = ''.obs;
  final RxList<String> galleryImages = <String>[].obs;
  final RxList<int> selectedImageIndices = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCompanyProfile();
    getGalleryImages();
  }

  @override
  void onClose() {
    companyNameController.dispose();
    overviewController.dispose();
    super.onClose();
  }

  Future<void> getCompanyProfile() async {
    isLoadingProfile.value = true;
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        // Basic info
        companyNameController.text = data['name'] ?? '';
        overviewController.text = data['bio'] ?? '';

        // Load existing cover photo
        if (data['cover'] != null && data['cover'].toString().isNotEmpty) {
          String coverUrl = data['cover'].toString();
          if (!coverUrl.startsWith('http')) {
            coverUrl = ApiEndPoint.imageUrl + coverUrl;
          }
          coverPhotoPath.value = coverUrl;
        }

        // Load existing company logo/profile image
        // Try multiple possible field names for profile image
        String? logoUrl;
        if (data['image'] != null && data['image'].toString().isNotEmpty) {
          logoUrl = data['image'].toString();
        } else if (data['logo'] != null && data['logo'].toString().isNotEmpty) {
          logoUrl = data['logo'].toString();
        } else if (data['profile_image'] != null && data['profile_image'].toString().isNotEmpty) {
          logoUrl = data['profile_image'].toString();
        } else if (data['avatar'] != null && data['avatar'].toString().isNotEmpty) {
          logoUrl = data['avatar'].toString();
        }

        if (logoUrl != null) {
          if (!logoUrl.startsWith('http')) {
            logoUrl = ApiEndPoint.imageUrl + logoUrl;
          }
          companyLogoPath.value = logoUrl;
        }

        final profileModel = RecruiterProfileModel.fromJson(response.data);
        profileData.value = profileModel.data;
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    isLoadingProfile.value = false;
    update();
  }

  Future<void> getGalleryImages() async {
    isLoadingImage.value = true;
    update();
    try {
      final response = await ApiService.get(
          "user/gallery",
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as List;

        // Clear existing images
        galleryImages.clear();

        // Extract image URLs from the list
        for (var item in data) {
          if (item['image'] != null) {
            String imageUrl = item['image'];
            // If the image path doesn't start with http, add the base URL
            if (!imageUrl.startsWith('http')) {
              imageUrl = ApiEndPoint.imageUrl + imageUrl;
            }
            galleryImages.add(imageUrl);
          }
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    isLoadingImage.value = false;
    update();
  }

  Future<void> updateProfile() async {
    isLoadingUpdate.value = true;
    update();

    try {
      // 1. Check if Profile Data or Profile Images changed
      bool hasProfileChanges =
          companyNameController.text != profileData.value?.name ||
              overviewController.text != profileData.value?.bio ||
              (coverPhotoPath.value.isNotEmpty && !coverPhotoPath.value.startsWith('http')) ||
              (companyLogoPath.value.isNotEmpty && !companyLogoPath.value.startsWith('http'));

      // 2. Check if there are new Gallery Images
      List<String> newGalleryImages = galleryImages
          .where((path) => !path.startsWith('http'))
          .toList();

      bool hasGalleryChanges = newGalleryImages.isNotEmpty;

      // --- CASE 1: ONLY GALLERY CHANGES ---
      if (hasGalleryChanges && !hasProfileChanges) {
        await _updateGalleryOnly(newGalleryImages);
      }
      // --- CASE 2: ONLY PROFILE CHANGES ---
      else if (!hasGalleryChanges && hasProfileChanges) {
        await _updateProfileOnly();
      }
      // --- CASE 3: BOTH CHANGED ---
      else if (hasGalleryChanges && hasProfileChanges) {
        await _updateProfileAndGallery(newGalleryImages);
      }
      // --- CASE 4: NOTHING CHANGED ---
      else {
        Utils.successSnackBar("No changes detected", "You haven't modified anything.");
      }

    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }

    isLoadingUpdate.value = false;
    update();
  }

  // Separate function for Gallery API
  Future<void> _updateGalleryOnly(List<String> images) async {
    // Convert the List<String> of paths into a List of Maps that the API service expects
    List<Map<String, String>> galleryFiles = images.map((path) => {
      "name": "image", // This is the key name your backend expects
      "image": path,   // This is the local file path (String)
    }).toList();

    final response = await ApiService.multipartImage(
      "user/gallery",
      body: {},
      files: galleryFiles, // Pass the mapped list here
      method: "POST",
      header: {"Authorization": "Bearer ${LocalStorage.token}"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      _handleSuccess();
    } else {
      Utils.errorSnackBar(response.statusCode, "Gallery update failed");
    }
  }

  // Separate function for Profile API
  Future<void> _updateProfileOnly() async {
    final body = {"name": companyNameController.text, "bio": overviewController.text};
    List<Map<String, String>> files = [];

    if (coverPhotoPath.value.isNotEmpty && !coverPhotoPath.value.startsWith('http')) {
      files.add({"name": "cover", "image": coverPhotoPath.value});
    }
    if (companyLogoPath.value.isNotEmpty && !companyLogoPath.value.startsWith('http')) {
      files.add({"name": "image", "image": companyLogoPath.value});
    }

    final response = await ApiService.multipartImage(
      "user/profile",
      body: body,
      files: files,
      method: "PATCH",
      header: {"Authorization": "Bearer ${LocalStorage.token}"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      _handleSuccess();
    }
  }

  // Function to handle both
  Future<void> _updateProfileAndGallery(List<String> images) async {
    // Logic remains the same: hit Profile first, then Gallery
    // (You can call the two functions above sequentially)
    await _updateProfileOnly();
    await _updateGalleryOnly(images);
  }

  void _handleSuccess() {
    Get.back();
    Utils.successSnackBar("Success", "Updated successfully");
  }

  // Pick cover photo with debouncing
  Future<void> pickCoverPhoto() async {
    if (isPickingImage.value) return; // Prevent multiple calls

    try {
      isPickingImage.value = true;

      // Add a small delay to ensure UI state is settled
      await Future.delayed(const Duration(milliseconds: 150));

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        coverPhotoPath.value = image.path;
        print("✅ Cover photo picked: ${image.path}");
        print("✅ Cover photo path updated to: ${coverPhotoPath.value}");
      } else {
        print("❌ No cover photo selected");
      }
    } catch (e) {
      print("❌ Error picking cover photo: $e");
      Utils.errorSnackBar(0, "Failed to pick image: $e");
    } finally {
      // Reset the flag after a short delay to prevent immediate re-triggering
      await Future.delayed(const Duration(milliseconds: 300));
      isPickingImage.value = false;
    }
  }

  // Pick company logo with debouncing
  Future<void> pickCompanyLogo() async {
    if (isPickingImage.value) return; // Prevent multiple calls

    try {
      isPickingImage.value = true;

      // Add a small delay to ensure UI state is settled
      await Future.delayed(const Duration(milliseconds: 150));

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        companyLogoPath.value = image.path;
        print("✅ Company logo picked: ${image.path}");
        print("✅ Company logo path updated to: ${companyLogoPath.value}");
      } else {
        print("❌ No company logo selected");
      }
    } catch (e) {
      print("❌ Error picking company logo: $e");
      Utils.errorSnackBar(0, "Failed to pick image: $e");
    } finally {
      // Reset the flag after a short delay to prevent immediate re-triggering
      await Future.delayed(const Duration(milliseconds: 300));
      isPickingImage.value = false;
    }
  }

  // Add image to gallery with debouncing
  Future<void> addGalleryImage() async {
    if (isPickingImage.value) return; // Prevent multiple calls

    try {
      isPickingImage.value = true;

      // Add a small delay to ensure UI state is settled
      await Future.delayed(const Duration(milliseconds: 150));

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        galleryImages.add(image.path);
        print("✅ Gallery image added: ${image.path}");
      } else {
        print("❌ No gallery image selected");
      }
    } catch (e) {
      print("❌ Error adding gallery image: $e");
      Utils.errorSnackBar(0, "Failed to pick image: $e");
    } finally {
      // Reset the flag after a short delay
      await Future.delayed(const Duration(milliseconds: 300));
      isPickingImage.value = false;
    }
  }

  // Toggle image selection
  void toggleImageSelection(int index) {
    if (selectedImageIndices.contains(index)) {
      selectedImageIndices.remove(index);
    } else {
      selectedImageIndices.add(index);
    }
  }

  // Check if image is selected
  bool isImageSelected(int index) {
    return selectedImageIndices.contains(index);
  }

  // Delete selected images
  void deleteSelectedImages() {
    if (selectedImageIndices.isEmpty) return;

    // Sort indices in descending order to avoid index shifting issues
    final sortedIndices = selectedImageIndices.toList()..sort((a, b) => b.compareTo(a));

    // Remove images from the list
    for (var index in sortedIndices) {
      if (index < galleryImages.length) {
        galleryImages.removeAt(index);
      }
    }

    // Clear selection
    selectedImageIndices.clear();

    // Utils.successSnackBar("${sortedIndices.length} image(s) removed");
  }
}