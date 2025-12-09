import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:embeyi/core/utils/constants/app_string.dart';

import '../constants/app_colors.dart';

class OtherHelper {
  static RegExp emailRegexp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static RegExp passRegExp = RegExp(r'(?=.*[a-z])(?=.*[0-9])');

  static String? validator(value) {
    if (value.isEmpty) {
      return AppString.thisFieldIsRequired;
    }
    return null;
  }

  static String? emailValidator(value) {
    if (value == null || value.isEmpty) {
      return AppString.thisFieldIsRequired;
    } else if (!emailRegexp.hasMatch(value)) {
      return AppString.enterValidEmail;
    }
    return null;
  }

  static String? passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return AppString.thisFieldIsRequired;
    } else if (value.length < 8) {
      return AppString.passwordMustBeeEightCharacters;
    }
    return null;
  }

  static String? confirmPasswordValidator(
    value,
    TextEditingController passwordController,
  ) {
    if (value == null || value.isEmpty) {
      return AppString.thisFieldIsRequired;
    } else if (value != passwordController.text) {
      return AppString.thePasswordDoesNotMatch;
    }
    return null;
  }

  static Future<String> openDatePickerDialog(
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
        ),
        child: child!,
      ),
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      controller.text = "${picked.year}/${picked.month}/${picked.day}";
      return picked.toIso8601String();
    }
    return "";
  }

  static Future<String?> openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    return image?.path;
  }

  static Future<String?> openGalleryForProfile() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      return croppedFile?.path;
    }
    return null;
  }

  static Future<String?> pickVideoFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    return video?.path;
  }

  static Future<String?> openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    return image?.path;
  }

  static Future<String> openTimePickerDialog(
    TextEditingController? controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final String formattedTime = formatTime(picked);
      controller?.text = formattedTime;
      return formattedTime;
    }
    return '';
  }

  static String formatTime(TimeOfDay time) {
    return "${time.hour > 12 ? (time.hour - 12).toString().padLeft(2, '0') : (time.hour == 0 ? 12 : time.hour).toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? "PM" : "AM"}";
  }
}
