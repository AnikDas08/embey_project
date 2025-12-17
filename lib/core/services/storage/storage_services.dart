import 'package:embeyi/core/utils/enum/enum.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/route/app_routes.dart';
import '../../utils/log/app_log.dart';
import 'storage_keys.dart';

class LocalStorage {
  static String token = "";
  static String refreshToken = "";
  static bool isLogIn = false;
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static String USER = "";
  static String role = "";
  static UserRole userRole = UserRole.jobSeeker;

  // Create Local Storage Instance
  static SharedPreferences? preferences;

  /// Get SharedPreferences Instance
  static Future<SharedPreferences> _getStorage() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }

  /// Get All Data From SharedPreferences
  static Future<void> getAllPrefData() async {
    final localStorage = await _getStorage();

    token = localStorage.getString(LocalStorageKeys.token) ?? "";
    refreshToken = localStorage.getString(LocalStorageKeys.refreshToken) ?? "";
    isLogIn = localStorage.getBool(LocalStorageKeys.isLogIn) ?? false;
    userId = localStorage.getString(LocalStorageKeys.userId) ?? "";
    myImage = localStorage.getString(LocalStorageKeys.myImage) ?? "";
    myName = localStorage.getString(LocalStorageKeys.myName) ?? "";
    myEmail = localStorage.getString(LocalStorageKeys.myEmail) ?? "";
    role = localStorage.getString(LocalStorageKeys.role) ?? "";
    userRole = UserRole.values.firstWhere(
      (element) =>
          element.name == localStorage.getString(LocalStorageKeys.userRole),
      orElse: () => UserRole.jobSeeker,
    );

    appLog(userId, source: "Local Storage");
  }

  /// Remove All Data From SharedPreferences
  static Future<void> removeAllPrefData() async {
    final localStorage = await _getStorage();
    await localStorage.clear();
    _resetLocalStorageData();
    Get.offAllNamed(AppRoutes.selectedRole);
    await getAllPrefData();
  }

  // Reset LocalStorage Data
  static void _resetLocalStorageData() {
    final localStorage = preferences!;
    localStorage.setString(LocalStorageKeys.token, "");
    localStorage.setString(LocalStorageKeys.refreshToken, "");
    localStorage.setString(LocalStorageKeys.userId, "");
    localStorage.setString(LocalStorageKeys.myImage, "");
    localStorage.setString(LocalStorageKeys.myName, "");
    localStorage.setString(LocalStorageKeys.myEmail, "");
    localStorage.setBool(LocalStorageKeys.isLogIn, false);
    localStorage.setString(LocalStorageKeys.userRole, "");

    // Reset static variables
    token = "";
    refreshToken = "";
    userId = "";
    myImage = "";
    myName = "";
    myEmail = "";
    isLogIn = false;
    userRole = UserRole.jobSeeker;
  }

  // Save Data To SharedPreferences
  static Future<void> setString(String key, String value) async {
    final localStorage = await _getStorage();
    await localStorage.setString(key, value);

    // Update static variables based on the key
    switch (key) {
      case LocalStorageKeys.token:
        token = value;
        break;
      case LocalStorageKeys.refreshToken:
        refreshToken = value;
        break;
      case LocalStorageKeys.userId:
        userId = value;
        break;
      case LocalStorageKeys.myImage:
        myImage = value;
        break;
      case LocalStorageKeys.myName:
        myName = value;
        break;
      case LocalStorageKeys.myEmail:
        myEmail = value;
        break;
      case LocalStorageKeys.userRole:
        userRole = UserRole.values.firstWhere(
          (element) => element.name == value,
          orElse: () => UserRole.jobSeeker,
        );
        break;
    }
  }

  static Future<void> setRole(String key, String value)async{
    final localStorage = await _getStorage();
    await localStorage.setString(key, value);
  }
  static Future<String> getRole(String key)async{
    return _getStorage().then((value) => value.getString(key) ?? "");
  }

  static Future<void> setBool(String key, bool value) async {
    final localStorage = await _getStorage();
    await localStorage.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    final localStorage = await _getStorage();
    await localStorage.setInt(key, value);
  }

  static Future<void> setUserRole(UserRole role) async {
    final localStorage = await _getStorage();
    await localStorage.setString(LocalStorageKeys.userRole, role.name);
  }
}
