import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pine_rever_realty/core/models/notification_model.dart';
import 'package:pine_rever_realty/core/network_caller/endpoints.dart';
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';

class BuyerNotificationController extends GetxController {
  var notifications = <NotificationItem>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        errorMessage.value = 'Authentication token not found';
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.buyerNotifications),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Buyer Notifications response: ${response.statusCode}');
      print('Buyer Notifications body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final notificationResponse = NotificationResponse.fromJson(jsonData);

        notifications.value = notificationResponse.results ?? [];
        unreadCount.value = notificationResponse.unreadCount ?? 0;
      } else {
        errorMessage.value =
            'Failed to load notifications: ${response.statusCode}';
      }
    } catch (e) {
      print('Error fetching buyer notifications: $e');
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Future: Implement mark as read, etc.
}
