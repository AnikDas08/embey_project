import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'app.dart';
import 'core/config/dependency/dependency_injection.dart';
import 'core/services/notification/notification_service.dart';
import 'core/services/socket/socket_service.dart';
import 'core/services/storage/storage_services.dart';
import 'main.dart' as GetStorage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();

  /// 🔥 GetStorage initialize
  await init.tryCatch();
  runApp(const MyApp());
}

init() async {
  DependencyInjection dI = DependencyInjection();
  dI.dependencies();
  SocketServices.connectToSocket();

  await Future.wait([
    LocalStorage.getAllPrefData(),
    NotificationService.initLocalNotification(),
    dotenv.load(fileName: ".env"),
  ]);
}
