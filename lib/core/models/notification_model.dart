class NotificationResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<NotificationItem> results;

  NotificationResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class NotificationItem {
  final int id;
  final String notificationType;
  final String title;
  final String message;
  final String? actionUrl;
  final String? actionText;
  final bool isRead;
  final int? sellingRequestId;
  final String? sellingRequestStatus;
  final int? agentId;
  final int? cmaId;
  final int? agreementId;
  final String createdAt;
  final String updatedAt;

  NotificationItem({
    required this.id,
    required this.notificationType,
    required this.title,
    required this.message,
    this.actionUrl,
    this.actionText,
    required this.isRead,
    this.sellingRequestId,
    this.sellingRequestStatus,
    this.agentId,
    this.cmaId,
    this.agreementId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      notificationType: json['notification_type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      actionUrl: json['action_url'],
      actionText: json['action_text'],
      isRead: json['is_read'] ?? false,
      sellingRequestId: json['selling_request_id'],
      sellingRequestStatus: json['selling_request_status'],
      agentId: json['agent_id'],
      cmaId: json['cma_id'],
      agreementId: json['agreement_id'] ?? json['selling_agreement_id'],
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
