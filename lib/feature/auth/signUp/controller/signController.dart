import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pine_rever_realty/core/network_caller/endpoints.dart';
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';
import '../model/registration_models.dart';

class SignController extends GetxController {
  var isPasswordVisible = false.obs;
  var agreedToTerms = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleTermsAgreement(bool? value) {
    agreedToTerms.value = value ?? false;
  }

  /// Register Agent
  Future<bool> registerAgent({
    required String username,
    required String email,
    required String password,
    required String password2,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    try {
      print('📝 Starting Agent registration...');
      print('📧 Email: $email');
      print('👤 Username: $username');

      isLoading.value = true;

      final request = AgentRegistrationRequest(
        username: username,
        email: email,
        password: password,
        password2: password2,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      print('🌐 Calling API: ${Urls.agentRegister}');

      final response = await http.post(
        Uri.parse(Urls.agentRegister),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final registrationResponse = AgentRegistrationResponse.fromJson(
          responseData,
        );

        print('✅ Agent registration successful!');

        // Save tokens and user data
        await _saveAgentData(registrationResponse, email);

        isLoading.value = false;
        return true;
      } else {
        print('❌ Registration failed: ${response.statusCode}');
        _handleErrorResponse(response);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      print('❌ Error during agent registration: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return false;
    }
  }

  /// Register Buyer
  Future<bool> registerBuyer({
    required String name,
    required String email,
    required String password,
    required String password2,
    String? phoneNumber,
    String? priceRange,
    String? location,
    int? bedrooms,
    int? bathrooms,
  }) async {
    try {
      print('📝 Starting Buyer registration...');
      print('📧 Email: $email');
      print('👤 Name: $name');

      isLoading.value = true;

      final request = BuyerRegistrationRequest(
        name: name,
        email: email,
        password: password,
        password2: password2,
        phoneNumber: phoneNumber,
        priceRange: priceRange,
        location: location,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
      );

      print('🌐 Calling API: ${Urls.buyerRegister}');

      final response = await http.post(
        Uri.parse(Urls.buyerRegister),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final registrationResponse = BuyerRegistrationResponse.fromJson(
          responseData,
        );

        print('✅ Buyer registration successful!');

        // Save tokens and user data
        await _saveBuyerData(registrationResponse, name);

        isLoading.value = false;
        return true;
      } else {
        print('❌ Registration failed: ${response.statusCode}');
        _handleErrorResponse(response);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      print('❌ Error during buyer registration: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return false;
    }
  }

  /// Register Seller
  Future<bool> registerSeller({
    required String name,
    required String email,
    required String password,
    required String password2,
    String? phoneNumber,
    String? priceRange,
    String? location,
    int? bedrooms,
    int? bathrooms,
  }) async {
    try {
      print('📝 Starting Seller registration...');
      print('📧 Email: $email');
      print('👤 Name: $name');

      isLoading.value = true;

      final request = SellerRegistrationRequest(
        name: name,
        email: email,
        password: password,
        password2: password2,
        phoneNumber: phoneNumber,
        priceRange: priceRange,
        location: location,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
      );

      print('🌐 Calling API: ${Urls.sellerRegister}');

      final response = await http.post(
        Uri.parse(Urls.sellerRegister),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final registrationResponse = SellerRegistrationResponse.fromJson(
          responseData,
        );

        print('✅ Seller registration successful!');

        // Save tokens and user data
        await _saveSellerData(registrationResponse, name);

        isLoading.value = false;
        return true;
      } else {
        print('❌ Registration failed: ${response.statusCode}');
        _handleErrorResponse(response);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      print('❌ Error during seller registration: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return false;
    }
  }

  /// Save Agent data to SharedPreferences
  Future<void> _saveAgentData(
    AgentRegistrationResponse response,
    String email,
  ) async {
    try {
      print('💾 Saving agent data...');

      await SharedPreferencesHelper.saveToken(response.accessToken);
      await SharedPreferencesHelper.saveEmail(email);
      await SharedPreferencesHelper.saveName(
        response.firstName ?? response.username,
      );

      final prefs =
          await SharedPreferencesHelper.getSharedPreferencesInstance();
      await prefs.setString('refresh_token', response.refreshToken);
      await prefs.setString('user_role', 'agent');
      await prefs.setString('username', response.username);
      if (response.phoneNumber != null) {
        await prefs.setString('phone_number', response.phoneNumber!);
      }

      print('✅ Agent data saved successfully');
    } catch (e) {
      print('❌ Error saving agent data: $e');
    }
  }

  /// Save Buyer data to SharedPreferences
  Future<void> _saveBuyerData(
    BuyerRegistrationResponse response,
    String name,
  ) async {
    try {
      print('💾 Saving buyer data...');

      await SharedPreferencesHelper.saveToken(response.accessToken);
      await SharedPreferencesHelper.saveEmail(response.email);
      await SharedPreferencesHelper.saveName(name);

      final prefs =
          await SharedPreferencesHelper.getSharedPreferencesInstance();
      await prefs.setString('refresh_token', response.refreshToken);
      await prefs.setString('user_role', 'buyer');
      if (response.phoneNumber != null) {
        await prefs.setString('phone_number', response.phoneNumber!);
      }
      if (response.priceRange != null) {
        await prefs.setString('price_range', response.priceRange!);
      }
      if (response.location != null) {
        await prefs.setString('location', response.location!);
      }

      print('✅ Buyer data saved successfully');
    } catch (e) {
      print('❌ Error saving buyer data: $e');
    }
  }

  /// Save Seller data to SharedPreferences
  Future<void> _saveSellerData(
    SellerRegistrationResponse response,
    String name,
  ) async {
    try {
      print('💾 Saving seller data...');

      await SharedPreferencesHelper.saveToken(response.accessToken);
      await SharedPreferencesHelper.saveEmail(response.email);
      await SharedPreferencesHelper.saveName(name);

      final prefs =
          await SharedPreferencesHelper.getSharedPreferencesInstance();
      await prefs.setString('refresh_token', response.refreshToken);
      await prefs.setString('user_role', 'seller');
      if (response.phoneNumber != null) {
        await prefs.setString('phone_number', response.phoneNumber!);
      }
      if (response.priceRange != null) {
        await prefs.setString('price_range', response.priceRange!);
      }
      if (response.location != null) {
        await prefs.setString('location', response.location!);
      }

      print('✅ Seller data saved successfully');
    } catch (e) {
      print('❌ Error saving seller data: $e');
    }
  }

  /// Handle error responses
  void _handleErrorResponse(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);

      if (errorData is Map<String, dynamic>) {
        // Handle field-specific errors
        String errorMessage = '';

        errorData.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            errorMessage += '$key: ${value.first}\n';
          } else if (value is String) {
            errorMessage += '$key: $value\n';
          }
        });

        Get.snackbar(
          'Registration Failed',
          errorMessage.trim(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Error',
          'Registration failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error parsing error response: $e');
      Get.snackbar(
        'Error',
        'Registration failed. Please check your details and try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
