import '../../../../core/services/api/api_service.dart';
import '../../../../core/config/api/api_end_point.dart';
import '../../../recruiter/notifications/data/model/notification_model.dart';
import '../data/model/notification_model.dart';

Future<List<NotificationModel>> notificationRepository(int page) async {
  var response = await ApiService.get(
    "notification?page=$page",
  );

  if (response.statusCode == 200) {
    // Access the nested 'data' array inside response.data['data']
    var notificationList = response.data['data']['data'] ?? [];

    List<NotificationModel> list = [];

    for (var notification in notificationList) {
      list.add(NotificationModel.fromJson(notification));
    }

    return list;
  } else {
    return [];
  }
}