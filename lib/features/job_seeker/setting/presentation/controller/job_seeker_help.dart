import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class HelpSupportController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final reasonController = TextEditingController();
  final descriptionController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final attachedFile = Rx<File?>(null);
  final attachedFileName = ''.obs;
  final attachedFilePath = ''.obs;
  final fileType = ''.obs; // 'image' or 'document'

  @override
  void onClose() {
    reasonController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Show file picker options
  void showFilePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose Image from Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Choose Document'),
              onTap: () {
                Get.back();
                pickDocument();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        attachedFile.value = File(image.path);
        attachedFilePath.value = image.path;
        attachedFileName.value = image.path.split('/').last;
        fileType.value = 'image';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        attachedFile.value = File(image.path);
        attachedFilePath.value = image.path;
        attachedFileName.value = image.path.split('/').last;
        fileType.value = 'image';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Pick document
  Future<void> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        attachedFile.value = File(result.files.single.path!);
        attachedFilePath.value = result.files.single.path!;
        attachedFileName.value = result.files.single.name;
        fileType.value = 'document';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick document: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Remove attached file
  void removeFile() {
    attachedFile.value = null;
    attachedFilePath.value = '';
    attachedFileName.value = '';
    fileType.value = '';
  }

  // Validate form
  bool validateForm() {
    if (reasonController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter reason',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter description',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Submit help support request
  Future<void> submitHelpSupport() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      // Prepare body data
      Map<String, dynamic> body = {
        'reason': reasonController.text.trim(),
        'description': descriptionController.text.trim(),
      };

      dynamic response;

      // If file is attached, use multipart request
      if (attachedFile.value != null) {
        List files = [
          {
            'name': fileType.value == 'image' ? 'image' : 'document',
            fileType.value == 'image' ? 'image' : 'file': attachedFilePath.value,
          }
        ];

        response = await ApiService.multipartImage(
          "support", // Replace with your actual endpoint
          method: 'POST',
          body: body,
          files: files,
        );
      } else {
        // Regular POST request without file
        response = await ApiService.post(
          "support", // Replace with your actual endpoint
          body: body,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar("Successful", "Your message send to the support team successful");
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to submit request',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    reasonController.clear();
    descriptionController.clear();
    removeFile();
  }
}