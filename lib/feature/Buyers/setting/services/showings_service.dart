import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pine_rever_realty/core/network_caller/endpoints.dart';
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';

class ShowingsService {
  static const String _endpoint = '${Urls.baseUrl}/buyer/showings/';

  static Future<List<Map<String, dynamic>>> fetchShowings() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null) throw Exception('No access token');

    final response = await http.get(
      Uri.parse(_endpoint),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load showings');
    }
  }
}
