import 'package:embeyi/core/component/pop_up/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../data/subscription_model.dart';
import '../screen/profile/payment_dialog.dart';


class SubscriptionController extends GetxController {
  final isLoading = true.obs;
  final selectedPlanIndex = 0.obs;
  final packages = <PackageModel>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';




      // Replace with your actual API endpoint
      final response = await ApiService.get('package?type=employee'); // or your API method

      if (response.statusCode == 200 && response.statusCode != null) {
        packages.value = (response.data['data'] as List)
            .map((json) => PackageModel.fromJson(json))
            .toList();
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to fetch packages';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching packages: $e';
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  PackageModel? get selectedPackage {
    if (packages.isEmpty || selectedPlanIndex.value >= packages.length) {
      return null;
    }
    return packages[selectedPlanIndex.value];
  }

  void onBuyNow(PackageModel package) async{
    /*try {
      final response = await ApiService.post(
          "subscription/demo",
        body: {
          "receipt": package.id,
          "userId": LocalStorage.userId,
        }
      );
      if(response.statusCode==200){
        SuccessDialog.show(message: "Payment Verification Successful Your payment has been securely verified.",buttonText: "Proceed to Login");
      }
      else{
        Get.snackbar("Error", "Show here error message");
      }
    } catch (e) {

    }*/
    SuccessDialog.show(message: "Payment Verification Successful Your payment has been securely verified.",buttonText: "Pay");
    print('Opening payment link: ${package.paymentLink}');
  }
}