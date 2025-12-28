class AgentListing {
  final int id;
  final String mlsNumber;
  final String title;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final int price;
  final int bedrooms;
  final int bathrooms;
  final int squareFeet;
  final String propertyType;
  final String status;
  final String description;
  final String? photoUrl;
  final int photosCount;
  final String agentName;
  final int agentId;
  final String agentPhone;
  final String agentEmail;
  final String createdAt;
  final String updatedAt;

  AgentListing({
    required this.id,
    required this.mlsNumber,
    required this.title,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.squareFeet,
    required this.propertyType,
    required this.status,
    required this.description,
    required this.photoUrl,
    required this.photosCount,
    required this.agentName,
    required this.agentId,
    required this.agentPhone,
    required this.agentEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AgentListing.fromJson(Map<String, dynamic> json) {
    return AgentListing(
      id: json['id'] ?? 0,
      mlsNumber: json['mls_number'] ?? '',
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zip_code'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
      squareFeet: (json['square_feet'] as num?)?.toInt() ?? 0,
      propertyType: json['property_type'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      photoUrl: json['photo_url'],
      photosCount: json['photos_count'] ?? 0,
      agentName: json['agent_name'] ?? '',
      agentId: json['agent_id'] ?? 0,
      agentPhone: json['agent_phone'] ?? '',
      agentEmail: json['agent_email'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
