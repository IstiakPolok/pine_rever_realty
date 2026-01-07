class NotificationResponse {
  final int? count;
  final int? unreadCount;
  final List<NotificationItem>? results;

  NotificationResponse({this.count, this.unreadCount, this.results});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      count: json['count'],
      unreadCount: json['unread_count'],
      results: json['results'] != null
          ? (json['results'] as List)
                .map((i) => NotificationItem.fromJson(i))
                .toList()
          : null,
    );
  }
}

class NotificationItem {
  final int? id;
  final String? notificationType;
  final String? title;
  final String? message;
  final bool isRead;
  final String? readAt;
  final String? actionUrl;
  final String? actionText;
  final int? showingScheduleId;
  final String? propertyTitle;
  final String? agentName;
  final String? createdAt;
  final BuyerDetails? buyerDetails;
  final AgentDetails? agentDetails;
  final ShowingDetails? showingDetails;
  final PropertyDetails? propertyDetails;

  // Seller specific fields found in Seller NotificationController
  final int? sellingRequestId;
  final String? sellingRequestStatus;
  final int? agentId;
  final String? updatedAt;
  final int? agreementId;
  final int? cmaId;

  NotificationItem({
    this.id,
    this.notificationType,
    this.title,
    this.message,
    this.isRead = false,
    this.readAt,
    this.actionUrl,
    this.actionText,
    this.showingScheduleId,
    this.propertyTitle,
    this.agentName,
    this.createdAt,
    this.buyerDetails,
    this.agentDetails,
    this.showingDetails,
    this.propertyDetails,
    this.sellingRequestId,
    this.sellingRequestStatus,
    this.agentId,
    this.updatedAt,
    this.agreementId,
    this.cmaId,
  });

  String get relativeTime {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays >= 1) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (_) {
      return '';
    }
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      notificationType: json['notification_type'],
      title: json['title'],
      message: json['message']?.toString(),
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'],
      actionUrl: json['action_url'],
      actionText: json['action_text'],
      showingScheduleId: json['showing_schedule_id'],
      propertyTitle: json['property_title'],
      agentName: json['agent_name'],
      createdAt: json['created_at'],
      buyerDetails: json['buyer_details'] != null
          ? BuyerDetails.fromJson(json['buyer_details'])
          : null,
      agentDetails: json['agent_details'] != null
          ? AgentDetails.fromJson(json['agent_details'])
          : null,
      showingDetails: json['showing_details'] != null
          ? ShowingDetails.fromJson(json['showing_details'])
          : null,
      propertyDetails: json['property_details'] != null
          ? PropertyDetails.fromJson(json['property_details'])
          : null,
      sellingRequestId: json['selling_request_id'],
      sellingRequestStatus: json['selling_request_status'],
      agentId: json['agent_id'],
      updatedAt: json['updated_at'],
      agreementId: json['agreement_id'],
      cmaId: json['cma_id'],
    );
  }
}

class BuyerDetails {
  final int? id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;

  BuyerDetails({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
  });

  factory BuyerDetails.fromJson(Map<String, dynamic> json) {
    return BuyerDetails(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}

class AgentDetails {
  final int? id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? licenseNumber;

  AgentDetails({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.licenseNumber,
  });

  factory AgentDetails.fromJson(Map<String, dynamic> json) {
    return AgentDetails(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      licenseNumber: json['license_number'],
    );
  }
}

class ShowingDetails {
  final int? id;
  final String? requestedDate;
  final String? confirmedDate;
  final String? confirmedTime;
  final String? preferredTime;
  final String? status;
  final String? additionalNotes;

  ShowingDetails({
    this.id,
    this.requestedDate,
    this.confirmedDate,
    this.confirmedTime,
    this.preferredTime,
    this.status,
    this.additionalNotes,
  });

  factory ShowingDetails.fromJson(Map<String, dynamic> json) {
    return ShowingDetails(
      id: json['id'],
      requestedDate: json['requested_date'],
      confirmedDate: json['confirmed_date'],
      confirmedTime: json['confirmed_time'],
      preferredTime: json['preferred_time'],
      status: json['status'],
      additionalNotes: json['additional_notes'],
    );
  }
}

class PropertyDetails {
  final int? id;
  final String? title;
  final String? address;
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? zipCode;
  final num? price;
  final num? bedrooms;
  final num? bathrooms;
  final num? squareFeet;
  final String? propertyType;
  final String? description;

  PropertyDetails({
    this.id,
    this.title,
    this.address,
    this.streetAddress,
    this.city,
    this.state,
    this.zipCode,
    this.price,
    this.bedrooms,
    this.bathrooms,
    this.squareFeet,
    this.propertyType,
    this.description,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) {
    return PropertyDetails(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      streetAddress: json['street_address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      price: json['price'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      squareFeet: json['square_feet'],
      propertyType: json['property_type'],
      description: json['description'],
    );
  }
}
