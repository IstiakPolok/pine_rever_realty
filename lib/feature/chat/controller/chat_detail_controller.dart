import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:pine_rever_realty/core/models/chat_message_model.dart';
import 'package:pine_rever_realty/core/network_caller/endpoints.dart';
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';

class ChatDetailController extends GetxController {
  WebSocket? _socket;
  var messages = <ChatMessage>[].obs;
  var isConnected = false.obs;
  var currentUserEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    currentUserEmail.value = await SharedPreferencesHelper.getEmail();
  }

  void connectToSocket(int conversationId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        print('No token found, cannot connect to socket');
        return;
      }

      final url = '${Urls.wsBaseUrl}/ws/chat/$conversationId/?token=$token';
      print('Connecting to WebSocket: $url');

      _socket = await WebSocket.connect(url);
      isConnected.value = true;
      print('WebSocket Connected');

      _socket!.listen(
        (data) {
          _handleIncomingMessage(data);
        },
        onDone: () {
          print('WebSocket Closed');
          isConnected.value = false;
        },
        onError: (error) {
          print('WebSocket Error: $error');
          isConnected.value = false;
        },
      );
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      isConnected.value = false;
    }
  }

  void _handleIncomingMessage(dynamic data) {
    try {
      print('Incoming: $data');
      final jsonData = json.decode(data);

      // Handle "previous_message" type which comes individually
      final message = ChatMessage.fromJson(jsonData);

      // Add to list if it's a valid message content (or whatever filters apply)
      // The user showed "type": "previous_message" and standard messages might just be echoes?
      // Assuming all valid JSONs with content are messages to be shown.
      if (message.content != null) {
        // Find insert position based on ID or Timestamp if needed, but for now just add to top or bottom?
        // Usually chat is bottom-up.
        // If "previous_message", they might come in order.
        // Let's add to list.
        // Note: Ideally sorting by createdAt would be better.
        messages.insert(0, message); // Insert at 0 for reverse list view
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  void sendMessage(String text) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      final payload = json.encode({'message': text});
      _socket!.add(payload);
      print('Sent: $payload');
      // Optimistically add to UI? Or wait for echo?
      // The API response user showed didn't explicitly show immediate echo structure for sent message,
      // but usually WS echoes back. I'll wait for echo to avoid duplication.
    } else {
      print('WebSocket not connected');
      Get.snackbar('Error', 'Not connected to chat');
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.close();
      isConnected.value = false;
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
