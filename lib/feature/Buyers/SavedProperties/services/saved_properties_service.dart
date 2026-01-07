import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';

import '../../../../core/network_caller/endpoints.dart';

class SavedPropertiesService {
  static Future<void> addSavedProperty(int listingId) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null) throw Exception('No access token');
    final url = '${_endpoint}add/';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'listing_id': listingId}),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to save property');
    }
  }

  static Future<void> deleteSavedProperty(int savedListingId) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null) throw Exception('No access token');
    final url = '$_endpoint$savedListingId/';
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete saved property');
    }
  }

  static const String _endpoint = '${Urls.baseUrl}/buyer/saved-listings/';

  static Future<List<Map<String, dynamic>>> fetchSavedProperties() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null) throw Exception('No access token');
    final response = await http.get(
      Uri.parse(_endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'] ?? [];
      return results.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load saved properties');
    }
  }
}
