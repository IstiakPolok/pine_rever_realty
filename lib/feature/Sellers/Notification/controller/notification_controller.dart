import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/models/notification_model.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';

class NotificationController extends GetxController {
  final isLoading = false.obs;
  final notifications = <NotificationItem>[].obs;
  final unreadCount = 0.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        errorMessage.value = 'No access token found';
        Get.snackbar('Error', 'Please log in again');
        return;
      }

      final response = await http.get(
        Uri.parse('${Urls.baseUrl}/seller/notifications/?page=$page'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Notifications response: ${response.statusCode}');
      print('Notifications body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final notificationResponse = NotificationResponse.fromJson(jsonData);

        notifications.value = notificationResponse.results;
        unreadCount.value = notificationResponse.results
            .where((n) => !n.isRead)
            .length;
      } else {
        errorMessage.value =
            'Failed to load notifications: ${response.statusCode}';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        print('markAsRead: no token found');
        return;
      }

      final url = '${Urls.baseUrl}/seller/notifications/mark-read/';
      print('markAsRead: POST $url');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('markAsRead: status=${response.statusCode} body=${response.body}');

      if (response.statusCode == 200) {
        // Update local state
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index] = NotificationItem(
            id: notifications[index].id,
            notificationType: notifications[index].notificationType,
            title: notifications[index].title,
            message: notifications[index].message,
            actionUrl: notifications[index].actionUrl,
            actionText: notifications[index].actionText,
            isRead: true,
            sellingRequestId: notifications[index].sellingRequestId,
            sellingRequestStatus: notifications[index].sellingRequestStatus,
            agentId: notifications[index].agentId,
            createdAt: notifications[index].createdAt,
            updatedAt: notifications[index].updatedAt,
          );
          notifications.refresh();
          unreadCount.value--;
          print(
            'markAsRead: updated local state for notification $notificationId, unreadCount=${unreadCount.value}',
          );
        }
      } else {
        print('markAsRead: failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        print('markAllAsRead: no token found');
        return;
      }

      final url = '${Urls.baseUrl}/seller/notifications/mark-all-read/';
      print('markAllAsRead: POST $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(
        'markAllAsRead: status=${response.statusCode} body=${response.body}',
      );

      if (response.statusCode == 200) {
        // Update all notifications to read
        notifications.value = notifications
            .map(
              (n) => NotificationItem(
                id: n.id,
                notificationType: n.notificationType,
                title: n.title,
                message: n.message,
                actionUrl: n.actionUrl,
                actionText: n.actionText,
                isRead: true,
                sellingRequestId: n.sellingRequestId,
                sellingRequestStatus: n.sellingRequestStatus,
                agentId: n.agentId,
                createdAt: n.createdAt,
                updatedAt: n.updatedAt,
              ),
            )
            .toList();
        unreadCount.value = 0;
        Get.snackbar('Success', 'All notifications marked as read');
        print(
          'markAllAsRead: marked ${notifications.length} notifications read, unreadCount=${unreadCount.value}',
        );
      } else {
        print('markAllAsRead: failed with status ${response.statusCode}');
        Get.snackbar('Error', 'Failed to mark all as read');
      }
    } catch (e) {
      print('Error marking all as read: $e');
      Get.snackbar('Error', 'Failed to mark all as read');
    }
  }
}
