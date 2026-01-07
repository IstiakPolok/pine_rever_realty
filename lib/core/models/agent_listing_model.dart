class AgentListingResponse {
  final List<AgentListing> results;
  final int total;
  final int page;
  final int perPage;
  final int totalPages;

  AgentListingResponse({
    required this.results,
    required this.total,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory AgentListingResponse.fromJson(Map<String, dynamic> json) {
    return AgentListingResponse(
      results:
          (json['results'] as List?)
              ?.map((i) => AgentListing.fromJson(i))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

class AgentListing {
  final int id;
  final String mlsNumber;
  final String title;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double price;
  final int bedrooms;
  final double bathrooms;
  final int squareFeet;
  final String propertyType;
  final String status;
  final String description;
  final String? photoUrl;
  final int photosCount;
  final int documentsCount;
  final String createdAt;
  final String updatedAt;
  final String? publishedAt;
  final int? agentId;
  final String? agentName;

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
    this.photoUrl,
    required this.photosCount,
    required this.documentsCount,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
    this.agentId,
    this.agentName,
  });

  factory AgentListing.fromJson(Map<String, dynamic> json) {
    return AgentListing(
      id: json['id'],
      mlsNumber: json['mls_number'] ?? '',
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zip_code'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toDouble() ?? 0.0,
      squareFeet: json['square_feet'] ?? 0,
      propertyType: json['property_type'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      photoUrl: json['photo_url'],
      photosCount: json['photos_count'] ?? 0,
      documentsCount: json['documents_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      publishedAt: json['published_at'],
      agentId: json['agent_id'],
      agentName: json['agent_name'],
    );
  }
}
