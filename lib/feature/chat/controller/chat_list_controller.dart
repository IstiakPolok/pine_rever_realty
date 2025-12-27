import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pine_rever_realty/core/models/conversation_model.dart';
import 'package:pine_rever_realty/core/network_caller/endpoints.dart';
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';

class ChatListController extends GetxController {
  var isLoading = false.obs;
  var conversations = <Conversation>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    isLoading.value = true;
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.conversationList),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final model = ConversationModel.fromJson(data);
        if (model.results != null) {
          conversations.assignAll(model.results!);
        }
      } else {
        print('Failed to fetch conversations: ${response.statusCode}');
        print('Response body: ${response.body}');
        Get.snackbar("Error", "Failed to load chats");
      }
    } catch (e) {
      print('Error fetching conversations: $e');
      Get.snackbar("Error", "An error occurred while loading chats");
    } finally {
      isLoading.value = false;
    }
  }
}
