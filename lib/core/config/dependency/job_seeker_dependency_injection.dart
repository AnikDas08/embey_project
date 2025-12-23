import 'package:embeyi/features/job_seeker/profile/presentation/controller/subscription_package_all_controllerer.dart';
import 'package:get/get.dart';

import '../../../features/common/auth/change_password/presentation/controller/change_password_controller.dart';
import '../../../features/common/auth/forgot password/presentation/controller/forget_password_controller.dart';
import '../../../features/common/auth/sign in/presentation/controller/sign_in_controller.dart';
import '../../../features/common/auth/sign up/presentation/controller/sign_up_controller.dart';
import '../../../features/job_seeker/message/presentation/controller/chat_controller.dart';
import '../../../features/job_seeker/message/presentation/controller/message_controller.dart';
import '../../../features/job_seeker/notifications/presentation/controller/notifications_controller.dart';
import '../../../features/job_seeker/profile/presentation/controller/profile_controller.dart';
import '../../../features/job_seeker/setting/presentation/controller/privacy_policy_controller.dart';
import '../../../features/job_seeker/setting/presentation/controller/setting_controller.dart';
import '../../../features/job_seeker/setting/presentation/controller/terms_of_services_controller.dart';

class JobSeekerDependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut(() => ChangePasswordController(), fenix: true);
    Get.lazyPut(() => NotificationsController(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => MessageController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => SettingController(), fenix: true);
    Get.lazyPut(() => PrivacyPolicyController(), fenix: true);
    Get.lazyPut(() => TermsOfServicesController(), fenix: true);
    Get.lazyPut(() => SubscriptionController(), fenix: true);
  }
}
