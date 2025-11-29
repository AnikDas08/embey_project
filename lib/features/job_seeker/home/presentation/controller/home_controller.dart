import 'package:embeyi/features/job_seeker/home/data/model/job_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../data/model/home_model.dart';

class HomeController extends GetxController {
  RxString name = "".obs;
  RxString image = "".obs;
  RxString designation="".obs;
  RxString categoryImage="".obs;
  RxString categoryName="".obs;
  UserData? profileData;
  RxList<String> bannerImages = <String>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  //JobPost jobPost=JobPost();

  @override
  void onInit(){
    super.onInit();
    getProfile();
    getBanner();
    fetchCategories();
  }

  @override
  void onClose(){
    super.onClose();
  }
  Future<void> getProfile() async {
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        final profileModel = ProfileModel.fromJson(response.data);
        profileData = profileModel.data;
        name.value = response.data["data"]["name"]??"";
        image.value = response.data["data"]["image"]??"";
        designation.value = response.data["data"]["designation"]??"";
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    update();
  }

  Future<void> getBanner() async {
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.banner,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        //final profileModel = ProfileModel.fromJson(response.data);
        final List<dynamic>? dataList = response.data["data"];
        if (dataList != null && dataList.isNotEmpty) {
          // Map the list of objects to extract only the 'cover_image' string
          final List<String> images = dataList
              .map<String>((item) => item["cover_image"] ?? "")
              .where((image) => image.isNotEmpty) // Optional: remove empty strings
              .toList();

          bannerImages.value = images;

        } else {
          // Handle case where data list is null or empty
          bannerImages.clear();
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    update();
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

        categories.value = data.map((item) {
          categoryImage.value = item['image']??"assets/images/noImage.png";
          categoryName.value = item['name']??"";
          return {
            "id": item['_id']??"",
            "name": item['name']??"",
            "image": item['image']??"assets/images/noImage.png",
          };
        }).toList();

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
    } finally {
    }
  }

  Future<void> getPost() async {
    update();
    try{
      final response=await ApiService.get(
          ApiEndPoint.job_post,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if(response.statusCode==200){
        final profileModel=JobPostResponse.fromJson(response.data);
        //profileData=profileModel.data;
      }
    }catch(e){

    }
  }
}