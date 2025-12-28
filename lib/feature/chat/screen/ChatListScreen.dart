import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_rever_realty/feature/chat/controller/chat_list_controller.dart';
import 'package:pine_rever_realty/core/models/conversation_model.dart';
import 'ChatDetailScreen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late ChatListController controller;

  // Colors
  static const Color _textDark = Color(0xFF212121);
  static const Color _textGrey = Color(0xFF616161);
  static const Color _badgeColor = Color(0xFF0E4A3B); // Dark Green

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatListController());
    // Fetch data every time the screen is opened
    controller.fetchConversations();
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        return DateFormat('h:mm a').format(dateTime);
      } else if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day - 1) {
        return 'Yesterday';
      } else {
        return DateFormat('MMM d').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ChatListScreen: build called');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0.h),
          child: Container(color: Colors.grey[200], height: 1.0.h),
        ),
      ),
      body: Obx(() {
        print(
          'ChatListScreen: Obx rebuild, isLoading=${controller.isLoading.value}, conversations=${controller.conversations.length}',
        );
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.conversations.isEmpty) {
          return Center(
            child: Text(
              'No conversations yet',
              style: TextStyle(fontSize: 16.sp, color: _textGrey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          itemCount: controller.conversations.length,
          itemBuilder: (context, index) {
            final Conversation conversation = controller.conversations[index];
            final otherUser = conversation.otherUser;
            final lastMessage = conversation.lastMessage;

            // UI Logic: use other user image and name
            final String name =
                otherUser?.name ?? otherUser?.username ?? 'Unknown';
            final String imageUrl = otherUser?.profileImageUrl ?? '';
            final String messageContent = lastMessage?.content ?? '';
            final String time = _formatTime(conversation.lastMessageAt);
            final int unread = conversation.unreadCount ?? 0;

            print(
              'ChatListScreen: building item $index, name=$name, message=$messageContent, unread=$unread',
            );

            return _buildChatItem(
              context: context,
              name: name,
              message: messageContent,
              time: time,
              image: imageUrl,
              unreadCount: unread,
              onTap: () {
                // Pass necessary data if ChatDetailScreen needs it, or just navigate for now
                print(
                  'ChatListScreen: onTap for conversation ${conversation.id}, name=$name',
                );
                Get.to(
                  () => ChatDetailScreen(
                    conversationId: conversation.id!,
                    otherUserName: name,
                    otherUserImage: imageUrl,
                    otherUserStatus: 'Active', // Or dynamic if available
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget _buildChatItem({
    required BuildContext context,
    required String name,
    required String message,
    required String time,
    required String image,
    required int unreadCount,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 28.r,
                backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                backgroundColor: Colors.grey[200],
                child: image.isEmpty
                    ? Icon(Icons.person, color: Colors.grey[400])
                    : null,
              ),
              SizedBox(width: 16.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            message,
                            style: TextStyle(fontSize: 14.sp, color: _textGrey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.all(6.w),
                            decoration: const BoxDecoration(
                              color: _badgeColor,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 20.w,
                              minHeight: 20.h,
                            ),
                            child: Center(
                              child: Text(
                                unreadCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
