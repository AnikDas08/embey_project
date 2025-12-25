import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../recruiter/notifications/data/model/notification_model.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../../data/model/notification_model.dart';
import '../../repository/notification_repository.dart';

class NotificationsController extends GetxController {
  /// Notification List
  List notifications = [];

  /// Notification Loading Bar
  bool isLoading = false;

  /// Notification more Data Loading Bar
  bool isLoadingMore = false;

  /// No more notification data
  bool hasNoData = false;

  /// page no here
  int page = 0;

  /// Notification Scroll Controller
  ScrollController scrollController = ScrollController();

  /// Notification More data Loading function

  void moreNotification() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (isLoadingMore || hasNoData) return;
        isLoadingMore = true;
        update();
        page++;
        List<NotificationModel> list = await notificationRepository(page);
        if (list.isEmpty) {
          hasNoData = true;
        } else {
          notifications.addAll(list);
        }
        isLoadingMore = false;
        update();
      }
    });
  }



  /// Notification data Loading function
  getNotificationsRepo() async {
    if (isLoading || hasNoData) return;
    isLoading = true;
    update();

    page++;
    List<NotificationModel> list = await notificationRepository(page);
    if (list.isEmpty) {
      hasNoData = true;
    } else {
      notifications.addAll(list);
    }
    isLoading = false;
    update();
  }

  readNotification()async{
    try{
      final response = await ApiService.patch(
          "notification",
          header: {
            "Content-Type": "application/json",
          }
      );
      if(response.statusCode==200){
        Get.find<HomeController>().readNotification();
      }
    }
    catch(e){

    }
  }

  /// Notification Controller Instance create here
  static NotificationsController get instance =>
      Get.put(NotificationsController());

  /// Controller on Init
  @override
  void onInit() {
    getNotificationsRepo();
    moreNotification();
    readNotification();
    super.onInit();
  }
}
