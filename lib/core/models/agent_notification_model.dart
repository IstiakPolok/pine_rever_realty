class AgentNotificationResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<AgentNotificationItem> results;

  AgentNotificationResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory AgentNotificationResponse.fromJson(Map<String, dynamic> json) {
    return AgentNotificationResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results:
          (json['results'] as List<dynamic>?)
              ?.map(
                (e) =>
                    AgentNotificationItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class AgentNotificationItem {
  final int id;
  final String notificationType;
  final String title;
  final String message;
  final int? sellingRequestId;
  final String? sellingRequestStatus;
  final String? sellerName;
  final String? sellerEmail;
  final int? documentId;
  final String? documentTitle;
  final String? documentType;
  final String? cmaStatus;
  final int? showingScheduleId;
  final String? buyerName;
  final String? propertyTitle;
  final String? actionUrl;
  final String? actionText;
  final bool isRead;
  final String createdAt;
  final String updatedAt;

  AgentNotificationItem({
    required this.id,
    required this.notificationType,
    required this.title,
    required this.message,
    this.sellingRequestId,
    this.sellingRequestStatus,
    this.sellerName,
    this.sellerEmail,
    this.documentId,
    this.documentTitle,
    this.documentType,
    this.cmaStatus,
    this.showingScheduleId,
    this.buyerName,
    this.propertyTitle,
    this.actionUrl,
    this.actionText,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AgentNotificationItem.fromJson(Map<String, dynamic> json) {
    return AgentNotificationItem(
      id: json['id'] ?? 0,
      notificationType: json['notification_type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      sellingRequestId: json['selling_request_id'],
      sellingRequestStatus: json['selling_request_status'],
      sellerName: json['seller_name'],
      sellerEmail: json['seller_email'],
      documentId: json['document_id'],
      documentTitle: json['document_title'],
      documentType: json['document_type'],
      cmaStatus: json['cma_status'],
      showingScheduleId: json['showing_schedule_id'],
      buyerName: json['buyer_name'],
      propertyTitle: json['property_title'],
      actionUrl: json['action_url'],
      actionText: json['action_text'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Helper to get relative time (e.g., "5 hours ago")
  String get relativeTime {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }
}
