import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/models/agent_notification_model.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../../../core/models/selling_request_response.dart';

class AgentNotificationController extends GetxController {
  final isLoading = false.obs;
  final notifications = <AgentNotificationItem>[].obs;
  final unreadCount = 0.obs;
  final errorMessage = ''.obs;

  // Track per-selling-request update state so the UI can show a spinner
  final updatingRequests = <int, bool>{}.obs;
  final sellingRequestDetails = <int, SellingRequest>{}.obs;

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
        Uri.parse('${Urls.baseUrl}/agent/notifications/?page=$page'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Agent Notifications response: ${response.statusCode}');
      print('Agent Notifications body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final notificationResponse = AgentNotificationResponse.fromJson(
          jsonData,
        );

        notifications.value = notificationResponse.results;
        unreadCount.value = notificationResponse.results
            .where((n) => !n.isRead)
            .length;

        // Fetch details for selling requests
        for (var notification in notifications) {
          if (notification.notificationType == 'new_selling_request' &&
              notification.sellingRequestId != null) {
            fetchSellingRequestDetail(notification.sellingRequestId!);
          }
        }

        // Fetch details for selling requests
        for (var notification in notifications) {
          if (notification.notificationType == 'new_selling_request' &&
              notification.sellingRequestId != null) {
            fetchSellingRequestDetail(notification.sellingRequestId!);
          }
        }
      } else {
        errorMessage.value =
            'Failed to load notifications: ${response.statusCode}';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      print('Error fetching agent notifications: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final response = await http.patch(
        Uri.parse(
          '${Urls.baseUrl}/agent/notifications/$notificationId/mark-read/',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Update local state
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index] = AgentNotificationItem(
            id: notifications[index].id,
            notificationType: notifications[index].notificationType,
            title: notifications[index].title,
            message: notifications[index].message,
            sellingRequestId: notifications[index].sellingRequestId,
            sellingRequestStatus: notifications[index].sellingRequestStatus,
            sellerName: notifications[index].sellerName,
            sellerEmail: notifications[index].sellerEmail,
            documentId: notifications[index].documentId,
            documentTitle: notifications[index].documentTitle,
            documentType: notifications[index].documentType,
            cmaStatus: notifications[index].cmaStatus,
            showingScheduleId: notifications[index].showingScheduleId,
            buyerName: notifications[index].buyerName,
            propertyTitle: notifications[index].propertyTitle,
            actionUrl: notifications[index].actionUrl,
            actionText: notifications[index].actionText,
            isRead: true,
            createdAt: notifications[index].createdAt,
            updatedAt: notifications[index].updatedAt,
          );
          notifications.refresh();
          unreadCount.value--;
        }
      }
    } catch (e) {
      print('Error marking agent notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/agent/notifications/mark-all-read/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Update all notifications to read
        notifications.value = notifications
            .map(
              (n) => AgentNotificationItem(
                id: n.id,
                notificationType: n.notificationType,
                title: n.title,
                message: n.message,
                sellingRequestId: n.sellingRequestId,
                sellingRequestStatus: n.sellingRequestStatus,
                sellerName: n.sellerName,
                sellerEmail: n.sellerEmail,
                documentId: n.documentId,
                documentTitle: n.documentTitle,
                documentType: n.documentType,
                cmaStatus: n.cmaStatus,
                showingScheduleId: n.showingScheduleId,
                buyerName: n.buyerName,
                propertyTitle: n.propertyTitle,
                actionUrl: n.actionUrl,
                actionText: n.actionText,
                isRead: true,
                createdAt: n.createdAt,
                updatedAt: n.updatedAt,
              ),
            )
            .toList();
        unreadCount.value = 0;
        Get.snackbar('Success', 'All notifications marked as read');
      }
    } catch (e) {
      print('Error marking all agent notifications as read: $e');
      Get.snackbar('Error', 'Failed to mark all as read');
    }
  }

  Future<void> updateSellingRequestStatus({
    required int sellingRequestId,
    required String status,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token found');
        return;
      }

      // mark as updating so UI can show a spinner for this request
      updatingRequests[sellingRequestId] = true;
      notifications.refresh();

      final response = await http.patch(
        Uri.parse(
          '${Urls.baseUrl}/agent/selling-requests/$sellingRequestId/status/',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      print('Update status response: ${response.statusCode}');
      print('Update status body: ${response.body}');

      // clear updating flag
      updatingRequests[sellingRequestId] = false;
      notifications.refresh();

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final message =
            responseData['message'] ?? 'Request updated successfully';
        Get.snackbar('Success', message);

        // Refresh notifications after status update
        await fetchNotifications();
      } else {
        Get.snackbar(
          'Error',
          'Failed to update request: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error updating selling request status: $e');
      Get.snackbar('Error', 'An error occurred: $e');
      // ensure we clear updating flag on error
      updatingRequests[sellingRequestId] = false;
      notifications.refresh();
    }
  }

  Future<void> fetchSellingRequestDetail(int id) async {
    if (sellingRequestDetails.containsKey(id)) return;

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${Urls.baseUrl}/agent/selling-requests/$id/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        sellingRequestDetails[id] = SellingRequest.fromJson(data);
      }
    } catch (e) {
      print('Error fetching selling request details: $e');
    }
  }
}
