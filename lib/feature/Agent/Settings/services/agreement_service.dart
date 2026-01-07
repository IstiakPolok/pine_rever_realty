import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../../../core/network_caller/endpoints.dart';

class AgreementService {
  static Future<List<Map<String, dynamic>>> fetchAgreements({
    int page = 1,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null) throw Exception('No access token');
    final url = Uri.parse('${Urls.agentAgreements}?page=$page');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List agreements = data['agreements'] ?? [];
      return agreements.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load agreements');
    }
  }
}
