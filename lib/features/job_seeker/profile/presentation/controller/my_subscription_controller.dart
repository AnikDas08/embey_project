import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/services/api/api_service.dart';

class MySubscriptionController extends GetxController {
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  // Subscription data
  final subscriptionId = ''.obs;
  final packageName = ''.obs;
  final price = 0.0.obs;
  final startDate = ''.obs;
  final endDate = ''.obs;
  final remainingDays = 0.obs;
  final status = ''.obs;
  final txId = ''.obs;

  // User data
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userImage = ''.obs;
  final userAddress = ''.obs;
  final userDesignation = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMySubscription();
  }

  Future<void> fetchMySubscription() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Replace with your actual API endpoint
      final response = await ApiService.get('subscription/subscribe'); // or your API method

      if (response.statusCode == 200 && response.statusCode != null) {
        final data = response.data["data"];

        // Set subscription data
        subscriptionId.value = data['_id'] ?? '';
        packageName.value = data['name'] ?? '';
        price.value = (data['price'] ?? 0).toDouble();
        status.value = data['status'] ?? '';
        txId.value = data['txId'] ?? '';
        remainingDays.value = data['remainingDays'] ?? 0;

        // Format dates
        if (data['startDate'] != null) {
          startDate.value = _formatDate(data['startDate']);
        }
        if (data['endDate'] != null) {
          endDate.value = _formatDate(data['endDate']);
        }

        // Set user data
        if (data['user'] != null) {
          final user = data['user'];
          userName.value = user['name'] ?? '';
          userEmail.value = user['email'] ?? '';
          userImage.value = user['image'] ?? '';
          userAddress.value = user['address'] ?? '';
          userDesignation.value = user['designation'] ?? '';
        }
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to fetch subscription';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching subscription: $e';
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String get formattedPrice => '\$${price.value.toStringAsFixed(2)}';

  String get remainingDaysText => '${remainingDays.value} Days';

  bool get isActive => status.value.toLowerCase() == 'active';

  String get fullImageUrl {
    if (userImage.value.isEmpty) return '';
    // Adjust this based on your API base URL
    if (userImage.value.startsWith('http')) {
      return userImage.value;
    }
    return '${ApiEndPoint.baseUrl}${userImage.value}';
  }

  void onRenewPack() {
    // Navigate to subscription pack screen or show renewal dialog
    Get.toNamed('/subscription-pack'); // Adjust route name as needed

    // Or show a dialog
    // Get.dialog(RenewalDialog());
  }
}