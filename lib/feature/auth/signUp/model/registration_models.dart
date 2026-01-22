/// Registration Request Models for different roles
library;

// Agent Registration Request
class AgentRegistrationRequest {
  final String username;
  final String email;
  final String password;
  final String password2;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  AgentRegistrationRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.password2,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'password2': password2,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    };
  }
}

// Buyer Registration Request
class BuyerRegistrationRequest {
  final String name;
  final String email;
  final String password;
  final String password2;
  final String? phoneNumber;
  final String? priceRange;
  final String? location;
  final int? bedrooms;
  final int? bathrooms;

  BuyerRegistrationRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.password2,
    this.phoneNumber,
    this.priceRange,
    this.location,
    this.bedrooms,
    this.bathrooms,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password2': password2,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (priceRange != null) 'price_range': priceRange,
      if (location != null) 'location': location,
      if (bedrooms != null) 'bedrooms': bedrooms,
      if (bathrooms != null) 'bathrooms': bathrooms,
    };
  }
}

// Seller Registration Request
class SellerRegistrationRequest {
  final String name;
  final String email;
  final String password;
  final String password2;
  final String? phoneNumber;
  final String? priceRange;
  final String? location;
  final int? bedrooms;
  final int? bathrooms;

  SellerRegistrationRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.password2,
    this.phoneNumber,
    this.priceRange,
    this.location,
    this.bedrooms,
    this.bathrooms,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password2': password2,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (priceRange != null) 'price_range': priceRange,
      if (location != null) 'location': location,
      if (bedrooms != null) 'bedrooms': bedrooms,
      if (bathrooms != null) 'bathrooms': bathrooms,
    };
  }
}

// Agent Registration Response
class AgentRegistrationResponse {
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String accessToken;
  final String refreshToken;

  AgentRegistrationResponse({
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AgentRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return AgentRegistrationResponse(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }
}

// Buyer Registration Response
class BuyerRegistrationResponse {
  final String email;
  final String? phoneNumber;
  final String? priceRange;
  final String? location;
  final int? bedrooms;
  final int? bathrooms;
  final String accessToken;
  final String refreshToken;

  BuyerRegistrationResponse({
    required this.email,
    this.phoneNumber,
    this.priceRange,
    this.location,
    this.bedrooms,
    this.bathrooms,
    required this.accessToken,
    required this.refreshToken,
  });

  factory BuyerRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return BuyerRegistrationResponse(
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      priceRange: json['price_range'],
      location: json['location'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }
}

// Seller Registration Response (similar to Buyer)
class SellerRegistrationResponse {
  final String email;
  final String? phoneNumber;
  final String? priceRange;
  final String? location;
  final int? bedrooms;
  final int? bathrooms;
  final String accessToken;
  final String refreshToken;

  SellerRegistrationResponse({
    required this.email,
    this.phoneNumber,
    this.priceRange,
    this.location,
    this.bedrooms,
    this.bathrooms,
    required this.accessToken,
    required this.refreshToken,
  });

  factory SellerRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return SellerRegistrationResponse(
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      priceRange: json['price_range'],
      location: json['location'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }
}
