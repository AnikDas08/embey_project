import 'package:get/get.dart';
import '../../data/model/html_model.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../../../core/utils/enum/enum.dart';

class PrivacyPolicyController extends GetxController {
  /// API status
  Status status = Status.completed;

  /// Html model
  HtmlModel? html;

  /// Single instance (GetX)
  static PrivacyPolicyController get instance =>
      Get.put(PrivacyPolicyController());

  /// Fetch Privacy Policy
  Future<void> getPrivacyPolicyRepo() async {
    status = Status.loading;
    update();

    final response =
    await ApiService.get("${ApiEndPoint.privacyPolicies}?type=privacy");

    if (response.statusCode == 200) {
      html = HtmlModel.fromJson(response.data);
      status = Status.completed;
      update();
    } else {
      Utils.errorSnackBar(response.statusCode, response.message);
      status = Status.error;
      update();
    }
  }

  @override
  void onInit() {
    getPrivacyPolicyRepo();
    super.onInit();
  }
}
