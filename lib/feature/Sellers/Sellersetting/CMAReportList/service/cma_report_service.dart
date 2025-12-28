import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cma_report_model.dart';
import '../../../../../core/network_caller/endpoints.dart';

class CMAReportService {
  static const String _endpoint = 'http://10.10.13.27:8005/api/v1/seller/cma/';

  Future<CMAReportListResponse?> fetchCMAReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return null;
      final response = await http.get(
        Uri.parse(_endpoint),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CMAReportListResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
