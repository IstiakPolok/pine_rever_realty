import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/models/agent_agreement_model.dart';
import '../../../../core/models/agent_listing_model.dart';
import '../../../../core/models/agent_stats_model.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../../../core/services_class/profile_service.dart';
import '../../../auth/login/model/login_response_model.dart';

class AgentHomeController extends GetxController {
  var isLoading = false.obs;
  var isAgreementsLoading = false.obs;
  var user = Rxn<UserModel>();
  var stats = AgentStats.empty().obs;
  var listings = <AgentListing>[].obs;
  var agreements = <AgentAgreement>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
    fetchAgreements();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load profile, stats and listings in parallel
      await Future.wait([loadProfile(), fetchStats(), fetchListings()]);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProfile() async {
    final profile = await ProfileService.fetchAgentProfile();
    if (profile != null) {
      user.value = profile;
    }
  }

  Future<void> fetchStats() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(Urls.agentSellingStats),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Agent Stats status: ${response.statusCode}');
      print('Agent Stats body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        stats.value = AgentStats.fromJson(jsonData);
      }
    } catch (e) {
      print('Error fetching agent stats: $e');
    }
  }

  Future<void> fetchListings() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(Urls.agentListings),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Agent Listings status: ${response.statusCode}');
      print('Agent Listings body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final listingResponse = AgentListingResponse.fromJson(jsonData);
        listings.value = listingResponse.results;
      }
    } catch (e) {
      print('Error fetching agent listings: $e');
    }
  }

  Future<void> fetchAgreements() async {
    try {
      isAgreementsLoading.value = true;
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(Urls.agentAgreements),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Agent Agreements status: ${response.statusCode}');
      print('Agent Agreements body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final agreementResponse = AgentAgreementResponse.fromJson(jsonData);
        agreements.value = agreementResponse.results;
      }
    } catch (e) {
      print('Error fetching agent agreements: $e');
    } finally {
      isAgreementsLoading.value = false;
    }
  }
}
