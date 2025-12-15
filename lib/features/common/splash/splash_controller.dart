import 'package:get/get.dart';

import '../../../core/config/dependency/dependency_injection.dart';
import '../../../core/services/notification/notification_service.dart';
import '../../../core/services/socket/socket_service.dart';
import '../../../core/services/storage/storage_services.dart';

class AppInitController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    DependencyInjection().dependencies();

    await Future.wait([
      LocalStorage.getAllPrefData(),
      NotificationService.initLocalNotification(),
    ]);

    SocketServices.connectToSocket();
  }
}
