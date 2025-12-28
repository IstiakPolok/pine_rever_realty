import 'dart:convert';
import 'package:http/http.dart' as http;
import '../network_caller/endpoints.dart';
import '../models/agent_listing_response.dart';

class AgentListingService {
  /// Fetch agent listings (no auth required for this endpoint)
  /// Supports filters and pagination; returns full response including metadata.
  static Future<AgentListingResponse?> fetchAgentListings({
    int page = 1,
    int perPage = 5,
    int? minPrice,
    int? maxPrice,
    int? bedrooms,
    String? city,
    String? state,
    String? zipCode,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (minPrice != null) queryParameters['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParameters['max_price'] = maxPrice.toString();
      if (bedrooms != null) queryParameters['bedrooms'] = bedrooms.toString();
      if (city != null && city.isNotEmpty) queryParameters['city'] = city;
      if (state != null && state.isNotEmpty) queryParameters['state'] = state;
      if (zipCode != null && zipCode.isNotEmpty)
        queryParameters['zip_code'] = zipCode;

      final uri = Uri.parse(
        '${Urls.baseUrl}/buyer/agent-listings/',
      ).replace(queryParameters: queryParameters);
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(resp.body);
        return AgentListingResponse.fromJson(body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
