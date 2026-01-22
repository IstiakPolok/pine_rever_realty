import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_rever_realty/core/models/chat_message_model.dart';
import 'package:pine_rever_realty/feature/chat/controller/chat_detail_controller.dart';
import '../../../core/const/app_colors.dart';

class ChatDetailScreen extends StatefulWidget {
  final int conversationId;
  final String otherUserName;
  final String otherUserImage;
  final String otherUserStatus;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.otherUserName,
    this.otherUserImage = '',
    this.otherUserStatus = 'Active',
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ChatDetailController _controller = Get.put(ChatDetailController());
  final TextEditingController _textController = TextEditingController();

  // Colors
  static const Color _primaryGreen = Color(0xFF2D6A5F);

  @override
  void initState() {
    super.initState();
    print(
      'ChatDetailScreen: initState for conversationId=${widget.conversationId}',
    );
    // Connect to WebSocket
    _controller.connectToSocket(widget.conversationId);
  }

  @override
  void dispose() {
    // _controller.disconnect(); // Controller handles this on onClose if we used Get.put correctly.
    // However, since we might come back to this screen, we might want to manually disconnect if we pop.
    // GetX controller stays alive if we just pop? Get.put by default keeps it?
    // Actually Get.to pushes a route. Get.put puts controller in memory.
    // If we pop, we should ideally delete the controller or disconnect.
    // We can use Get.delete<ChatDetailController>() or rely on GetX smart management.
    super.dispose();
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            print('ChatDetailScreen: back button pressed, deleting controller');
            Get.delete<ChatDetailController>(); // Clean up
            Navigator.of(context).pop();
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.otherUserImage.isNotEmpty
                  ? NetworkImage(widget.otherUserImage)
                  : null,
              backgroundColor: Colors.grey[200],
              child: widget.otherUserImage.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUserName,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.otherUserStatus,
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
      ),
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true, // Show latest messages at the bottom?
                // Usually reverse: true means index 0 is at bottom.
                // Our controller inserts new messages at index 0.
                // So if we use reverse: true, index 0 (newest) will be at bottom. Correct.
                padding: const EdgeInsets.all(20),
                itemCount: _controller.messages.length,
                itemBuilder: (context, index) {
                  final message = _controller.messages[index];
                  final isMe =
                      message.senderEmail == _controller.currentUserEmail.value;
                  print(
                    'ChatDetailScreen: rendering message $index: ${message.content} isMe=$isMe',
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildMessageBubble(
                      text: message.content ?? '',
                      time: _formatTime(message.createdAt),
                      isMe: isMe,
                    ),
                  );
                },
              );
            }),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _primaryGreen),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: _primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_textController.text.trim().isNotEmpty) {
                        print(
                          'ChatDetailScreen: sending message: ${_textController.text.trim()}',
                        );
                        _controller.sendMessage(_textController.text.trim());
                        _textController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Bottom padding for safety
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String text,
    required String time,
    required bool isMe,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment
                    .end // Changed to end for proper alignment
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isMe ? _primaryGreen : Colors.white,
                border: isMe ? null : Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : primaryColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
