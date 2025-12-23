class ProfileResponse {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profileImage;
  final String? priceRange;
  final String? location;
  final int? bedrooms;
  final int? bathrooms;
  final String? propertyCondition;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileResponse({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImage,
    this.priceRange,
    this.location,
    this.bedrooms,
    this.bathrooms,
    this.propertyCondition,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      profileImage: json['profile_image'],
      priceRange: json['price_range'],
      location: json['location'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      propertyCondition: json['property_condition'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
