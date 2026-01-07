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

  // Track update states so the UI can show a spinner
  final updatingRequests = <int, bool>{}.obs;
  final updatingShowings = <int, bool>{}.obs;
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
        return;
      }

      final url = '${Urls.baseUrl}/agent/notifications/?page=$page';
      print('Agent Notifications URL: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Agent Notifications status: ${response.statusCode}');
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
      } else {
        errorMessage.value =
            'Failed to load notifications: ${response.statusCode}';
      }
    } catch (e) {
      print('Error fetching agent notifications: $e');
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final url =
          '${Urls.baseUrl}/agent/notifications/$notificationId/mark-read/';
      print('Mark As Read URL: $url');
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final old = notifications[index];
          notifications[index] = AgentNotificationItem(
            id: old.id,
            notificationType: old.notificationType,
            title: old.title,
            message: old.message,
            sellingRequestId: old.sellingRequestId,
            sellingRequestStatus: old.sellingRequestStatus,
            sellerName: old.sellerName,
            sellerEmail: old.sellerEmail,
            documentId: old.documentId,
            documentTitle: old.documentTitle,
            documentType: old.documentType,
            cmaStatus: old.cmaStatus,
            showingScheduleId: old.showingScheduleId,
            showingStatus: old.showingStatus,
            buyerName: old.buyerName,
            propertyTitle: old.propertyTitle,
            actionUrl: old.actionUrl,
            actionText: old.actionText,
            isRead: true,
            createdAt: old.createdAt,
            updatedAt: old.updatedAt,
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

      final url = '${Urls.baseUrl}/agent/notifications/mark-all-read/';
      print('Mark All As Read URL: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
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
                showingStatus: n.showingStatus,
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
    }
  }

  Future<void> updateSellingRequestStatus({
    required int sellingRequestId,
    required String status,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      updatingRequests[sellingRequestId] = true;
      notifications.refresh();

      final url =
          '${Urls.baseUrl}/agent/selling-requests/$sellingRequestId/status/';
      print('Update Selling Request Status URL: $url');
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      updatingRequests[sellingRequestId] = false;
      notifications.refresh();

      if (response.statusCode == 200) {
        await fetchNotifications();
        Get.snackbar('Success', 'Status updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update status');
      }
    } catch (e) {
      updatingRequests[sellingRequestId] = false;
      notifications.refresh();
      print('Error updating selling request: $e');
    }
  }

  Future<void> acceptShowing(int showingScheduleId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      updatingShowings[showingScheduleId] = true;
      notifications.refresh();

      final url = '${Urls.baseUrl}/agent/showings/$showingScheduleId/accept/';
      print('Accept Showing URL: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Accept Showing response: ${response.statusCode}');
      print('Accept Showing body: ${response.body}');

      updatingShowings[showingScheduleId] = false;
      notifications.refresh();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchNotifications();
        Get.snackbar('Success', 'Showing accepted successfully');
      } else {
        Get.snackbar('Error', 'Failed to accept showing');
      }
    } catch (e) {
      updatingShowings[showingScheduleId] = false;
      notifications.refresh();
      print('Error accepting showing: $e');
    }
  }

  Future<void> declineShowing(int showingScheduleId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      updatingShowings[showingScheduleId] = true;
      notifications.refresh();

      final url = '${Urls.baseUrl}/agent/showings/$showingScheduleId/reject/';
      print('Decline Showing URL: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: json.encode({'agent_response': 'Declined by agent'}),
      );

      print('Decline Showing response: ${response.statusCode}');
      print('Decline Showing body: ${response.body}');

      updatingShowings[showingScheduleId] = false;
      notifications.refresh();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchNotifications();
        Get.snackbar('Success', 'Showing declined successfully');
      } else {
        Get.snackbar('Error', 'Failed to decline showing');
      }
    } catch (e) {
      updatingShowings[showingScheduleId] = false;
      notifications.refresh();
      print('Error declining showing: $e');
    }
  }

  Future<void> updateShowingStatus({
    required int showingScheduleId,
    required String status,
  }) async {
    if (status == 'accepted') {
      return acceptShowing(showingScheduleId);
    } else if (status == 'declined') {
      return declineShowing(showingScheduleId);
    }
    // Fallback for other statuses if any
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      updatingShowings[showingScheduleId] = true;
      notifications.refresh();

      final url = '${Urls.baseUrl}/agent/showings/$showingScheduleId/status/';
      print('Update Showing Status URL: $url');
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      print('Update Showing Status response: ${response.statusCode}');
      print('Update Showing Status body: ${response.body}');

      updatingShowings[showingScheduleId] = false;
      notifications.refresh();

      if (response.statusCode == 200) {
        await fetchNotifications();
        Get.snackbar('Success', 'Showing status updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update showing status');
      }
    } catch (e) {
      updatingShowings[showingScheduleId] = false;
      notifications.refresh();
      print('Error updating showing status: $e');
    }
  }

  Future<void> fetchSellingRequestDetail(int id) async {
    if (sellingRequestDetails.containsKey(id)) return;
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final url = '${Urls.baseUrl}/agent/selling-requests/$id/';
      print('Fetch Selling Request Detail URL: $url');
      final response = await http.get(
        Uri.parse(url),
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
