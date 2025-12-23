class SellingRequest {
  final int id;
  final int seller;
  final String sellerName;
  final String sellerEmail;
  final String? sellerPhone;
  final int? agentId;
  final String? agentName;
  final String? agentEmail;
  final String? agentPhone;
  final String? agentLicenseNumber;
  final String? agentProfilePicture;
  final String sellingReason;
  final String contactName;
  final String contactEmail;
  final String? contactPhone;
  final String askingPrice;
  final String startDate;
  final String endDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  SellingRequest({
    required this.id,
    required this.seller,
    required this.sellerName,
    required this.sellerEmail,
    this.sellerPhone,
    this.agentId,
    this.agentName,
    this.agentEmail,
    this.agentPhone,
    this.agentLicenseNumber,
    this.agentProfilePicture,
    required this.sellingReason,
    required this.contactName,
    required this.contactEmail,
    this.contactPhone,
    required this.askingPrice,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SellingRequest.fromJson(Map<String, dynamic> json) {
    return SellingRequest(
      id: json['id'],
      seller: json['seller'],
      sellerName: json['seller_name'],
      sellerEmail: json['seller_email'],
      sellerPhone: json['seller_phone'],
      agentId: json['agent_id'],
      agentName: json['agent_name'],
      agentEmail: json['agent_email'],
      agentPhone: json['agent_phone'],
      agentLicenseNumber: json['agent_license_number'],
      agentProfilePicture: json['agent_profile_picture'],
      sellingReason: json['selling_reason'],
      contactName: json['contact_name'],
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      askingPrice: json['asking_price'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class SellingRequestsResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<SellingRequest> results;

  SellingRequestsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory SellingRequestsResponse.fromJson(Map<String, dynamic> json) {
    return SellingRequestsResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((e) => SellingRequest.fromJson(e))
          .toList(),
    );
  }
}
