import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/services/api/api_service.dart';
import 'profile_controller.dart';
import '../screen/subscription_pack_screen.dart';

class RecruiterMySubscriptionController extends GetxController {
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final hasSubscription = false.obs;

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
    _loadProfileFallback();
    fetchMySubscription();
  }

  void _loadProfileFallback() {
    if (Get.isRegistered<RecruiterProfileController>()) {
      final profile = Get.find<RecruiterProfileController>();
      if (userName.value.isEmpty && profile.name.value.isNotEmpty) {
        userName.value = profile.name.value;
      }
      if (userImage.value.isEmpty && profile.profileImages.value.isNotEmpty) {
        userImage.value = profile.profileImages.value;
      }
      if (userEmail.value.isEmpty && profile.email.value.isNotEmpty) {
        userEmail.value = profile.email.value;
      }
      if (userAddress.value.isEmpty && profile.address.value.isNotEmpty) {
        userAddress.value = profile.address.value;
      }
    }
  }

  Future<void> fetchMySubscription() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      hasSubscription.value = false;

      _loadProfileFallback();

      final response = await ApiService.get('subscription/subscribe');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data["data"];

        if (data != null && data is Map && (data['_id'] != null || data['name'] != null)) {
          // Set subscription data
          subscriptionId.value = data['_id']?.toString() ?? '';
          packageName.value = data['name']?.toString() ?? '';
          price.value = (data['price'] ?? 0).toDouble();
          status.value = data['status']?.toString() ?? '';
          txId.value = data['txId']?.toString() ?? '';
          remainingDays.value = (data['remainingDays'] is num) ? (data['remainingDays'] as num).toInt() : 0;

          // Format dates
          if (data['startDate'] != null) {
            startDate.value = _formatDate(data['startDate'].toString());
          }
          if (data['endDate'] != null) {
            endDate.value = _formatDate(data['endDate'].toString());
          }

          // Set user data
          if (data['user'] != null && data['user'] is Map) {
            final user = data['user'];
            userName.value = user['name']?.toString() ?? userName.value;
            userEmail.value = user['email']?.toString() ?? userEmail.value;
            userImage.value = user['image']?.toString() ?? userImage.value;
            userAddress.value = user['address']?.toString() ?? userAddress.value;
            userDesignation.value = user['designation']?.toString() ?? userDesignation.value;
          }

          hasSubscription.value = packageName.value.isNotEmpty || subscriptionId.value.isNotEmpty;
        } else {
          hasSubscription.value = false;
        }
      } else {
        final msg = (response.data is Map ? response.data['message']?.toString() : '') ?? '';
        final lowerMsg = msg.toLowerCase();
        final isNoSubscription = response.statusCode == 404 ||
            lowerMsg.contains('no subscription') ||
            lowerMsg.contains('not found') ||
            lowerMsg.contains('no active') ||
            lowerMsg.contains('don\'t have') ||
            lowerMsg.contains('not subscribed');

        if (isNoSubscription) {
          hasSubscription.value = false;
          errorMessage.value = '';
        } else {
          errorMessage.value = msg.isNotEmpty ? msg : 'Failed to fetch subscription';
        }
      }
    } catch (e) {
      print('Error fetching subscription: $e');
      if (e.toString().contains('null') || e.toString().contains('NoSuchMethodError')) {
        hasSubscription.value = false;
        errorMessage.value = '';
      } else {
        errorMessage.value = 'Error fetching subscription: $e';
      }
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
    if (userImage.value.startsWith('http')) {
      return userImage.value;
    }
    return '${ApiEndPoint.imageUrl}${userImage.value}';
  }

  void onRenewPack() {
    Get.to(() => const RecruiterSubscriptionPackScreen());
  }
}