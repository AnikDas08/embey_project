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
      // 1. Prepare the body
      final body = {
        "name": companyNameController.text,
        "bio": overviewController.text,
      };

      // 2. Prepare the files list
      List<Map<String, String>> files = [];

      if (coverPhotoPath.value.isNotEmpty && !coverPhotoPath.value.startsWith('http')) {
        files.add({
          "name": "cover",
          "image": coverPhotoPath.value,
        });
      }

      if (companyLogoPath.value.isNotEmpty && !companyLogoPath.value.startsWith('http')) {
        files.add({
          "name": "image", // or "logo" depending on your backend
          "image": companyLogoPath.value,
        });
      }

      print("Files to upload: $files");

      // 3. Call the multipart request
      final response = await ApiService.multipartImage(
        "user/profile",
        body: body,
        files: files,
        method: "PATCH",
        header: {
          "Authorization": "Bearer ${LocalStorage.token}",
        },
      );

      // 4. Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close page after success
        //Utils.successSnackBar("Profile updated successfully");
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }

    isLoadingUpdate.value = false;
    update();
  }


  // Pick cover photo
  Future<void> pickCoverPhoto() async {
    try {
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
    }
  }

  // Pick company logo
  Future<void> pickCompanyLogo() async {
    try {
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
    }
  }

  // Add image to gallery
  Future<void> addGalleryImage() async {
    try {
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