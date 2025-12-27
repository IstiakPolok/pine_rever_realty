class ChatMessage {
  String? type;
  int? messageId;
  int? conversationId;
  String? senderType;
  String? senderName;
  String? senderEmail;
  String? content;
  String? createdAt;
  bool? isRead;

  ChatMessage({
    this.type,
    this.messageId,
    this.conversationId,
    this.senderType,
    this.senderName,
    this.senderEmail,
    this.content,
    this.createdAt,
    this.isRead,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    messageId = json['message_id'];
    conversationId = json['conversation_id'];
    senderType = json['sender_type'];
    senderName = json['sender_name'];
    senderEmail = json['sender_email'];
    content = json['content'];
    createdAt = json['created_at'];
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['message_id'] = messageId;
    data['conversation_id'] = conversationId;
    data['sender_type'] = senderType;
    data['sender_name'] = senderName;
    data['sender_email'] = senderEmail;
    data['content'] = content;
    data['created_at'] = createdAt;
    data['is_read'] = isRead;
    return data;
  }
}
