class ConversationModel {
  int? count;
  String? next;
  String? previous;
  List<Conversation>? results;

  ConversationModel({this.count, this.next, this.previous, this.results});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Conversation>[];
      json['results'].forEach((v) {
        results!.add(Conversation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Conversation {
  int? id;
  int? agent;
  String? agentName;
  String? agentEmail;
  int? seller;
  String? sellerName;
  String? sellerEmail;
  String? conversationType;
  dynamic sellingRequest;
  String? subject;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? lastMessageAt;
  LastMessage? lastMessage;
  int? unreadCount;
  OtherUser? otherUser;

  Conversation({
    this.id,
    this.agent,
    this.agentName,
    this.agentEmail,
    this.seller,
    this.sellerName,
    this.sellerEmail,
    this.conversationType,
    this.sellingRequest,
    this.subject,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastMessageAt,
    this.lastMessage,
    this.unreadCount,
    this.otherUser,
  });

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agent = json['agent'];
    agentName = json['agent_name'];
    agentEmail = json['agent_email'];
    seller = json['seller'];
    sellerName = json['seller_name'];
    sellerEmail = json['seller_email'];
    conversationType = json['conversation_type'];
    sellingRequest = json['selling_request'];
    subject = json['subject'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastMessageAt = json['last_message_at'];
    lastMessage = json['last_message'] != null
        ? LastMessage.fromJson(json['last_message'])
        : null;
    unreadCount = json['unread_count'];
    otherUser = json['other_user'] != null
        ? OtherUser.fromJson(json['other_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['agent'] = agent;
    data['agent_name'] = agentName;
    data['agent_email'] = agentEmail;
    data['seller'] = seller;
    data['seller_name'] = sellerName;
    data['seller_email'] = sellerEmail;
    data['conversation_type'] = conversationType;
    data['selling_request'] = sellingRequest;
    data['subject'] = subject;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['last_message_at'] = lastMessageAt;
    if (lastMessage != null) {
      data['last_message'] = lastMessage!.toJson();
    }
    data['unread_count'] = unreadCount;
    if (otherUser != null) {
      data['other_user'] = otherUser!.toJson();
    }
    return data;
  }
}

class LastMessage {
  int? id;
  String? content;
  String? senderType;
  String? createdAt;
  bool? isRead;

  LastMessage({
    this.id,
    this.content,
    this.senderType,
    this.createdAt,
    this.isRead,
  });

  LastMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    senderType = json['sender_type'];
    createdAt = json['created_at'];
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['sender_type'] = senderType;
    data['created_at'] = createdAt;
    data['is_read'] = isRead;
    return data;
  }
}

class OtherUser {
  int? id;
  String? username;
  String? email;
  String? name;
  String? type;
  String? profileImageUrl;

  OtherUser({
    this.id,
    this.username,
    this.email,
    this.name,
    this.type,
    this.profileImageUrl,
  });

  OtherUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    name = json['name'];
    type = json['type'];
    profileImageUrl = json['profile_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['name'] = name;
    data['type'] = type;
    data['profile_image_url'] = profileImageUrl;
    return data;
  }
}
