import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../model/login_response_model.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  Rx<LoginResponseModel?> loginResponse = Rx<LoginResponseModel?>(null);
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  Future<bool> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      print('🔐 Login attempt started');
      print('📧 Email: $email');
      print('👤 Role: $role');

      // Get the appropriate endpoint based on role
      final String endpoint = Urls.getLoginEndpoint(role);
      print('🌐 API Endpoint: $endpoint');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
      };
      print('📦 Request Body: ${jsonEncode(requestBody)}');

      // Make API call
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📡 Response Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse response using model
        final Map<String, dynamic> data = jsonDecode(response.body);
        loginResponse.value = LoginResponseModel.fromJson(data);
        currentUser.value = loginResponse.value!.user;

        print('✅ Response parsed successfully');
        print('👤 User: ${currentUser.value?.fullName}');
        print(
          '🔑 Access Token: ${loginResponse.value?.accessToken.substring(0, 20)}...',
        );

        // Store tokens and user data
        await _saveUserData(loginResponse.value!, role);

        // Show success message
        _showSuccessMessage('Login successful!');

        isLoading.value = false;
        print('✅ Login completed successfully');
        return true;
      } else {
        // Handle error response
        print('❌ Login failed with status: ${response.statusCode}');
        _handleErrorResponse(response);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      // Handle exceptions
      print('❌ Exception occurred: $e');
      print('📍 Stack trace: ${StackTrace.current}');
      _showErrorMessage('An error occurred: ${e.toString()}');
      isLoading.value = false;
      return false;
    }
  }

  /// Save user data to SharedPreferences
  Future<void> _saveUserData(LoginResponseModel response, String role) async {
    print('💾 Saving user data to SharedPreferences...');

    try {
      await SharedPreferencesHelper.saveToken(response.accessToken);
      print('✅ Access token saved');

      await SharedPreferencesHelper.saveEmail(response.email);
      print('✅ Email saved: ${response.email}');

      await SharedPreferencesHelper.saveName(response.user.fullName);
      print('✅ User name saved: ${response.user.fullName}');

      await SharedPreferencesHelper.saveUserId(response.user.id.toString());
      print('✅ User ID saved: ${response.user.id}');

      await SharedPreferencesHelper.saveSelectedRole(role);
      print('✅ User role saved: $role');

      // Store additional data using the standard method
      final prefs =
          await SharedPreferencesHelper.getSharedPreferencesInstance();
      await prefs.setString('refresh_token', response.refreshToken);
      await prefs.setString('user_data', jsonEncode(response.user.toJson()));

      print('✅ All user data saved successfully');
      print('📊 User Role: $role');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  /// Handle error response from API
  void _handleErrorResponse(http.Response response) {
    try {
      print('🔍 Parsing error response...');
      final errorData = jsonDecode(response.body);
      String errorMessage = 'Login failed';

      if (errorData is Map) {
        if (errorData.containsKey('detail')) {
          errorMessage = errorData['detail'];
        } else if (errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData.containsKey('error')) {
          errorMessage = errorData['error'];
        }
      }

      print('❌ Error message: $errorMessage');
      _showErrorMessage(errorMessage);
    } catch (e) {
      print('❌ Error parsing error response: $e');
      _showErrorMessage('Login failed with status: ${response.statusCode}');
    }
  }

  /// Show success message
  void _showSuccessMessage(String message) {
    print('✅ Success: $message');
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Show error message
  void _showErrorMessage(String message) {
    print('❌ Error: $message');
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }

  // Method to logout
  Future<void> logout() async {
    print('🚪 Logging out user...');
    await SharedPreferencesHelper.logoutUser();
    loginResponse.value = null;
    currentUser.value = null;
    print('✅ Logout completed');
  }

  // Method to check if user is logged in
  Future<bool> isLoggedIn() async {
    final isLogin = await SharedPreferencesHelper.checkLogin();
    print('🔍 Checking login status: ${isLogin ?? false}');
    return isLogin ?? false;
  }

  // Method to get stored user role
  Future<String?> getUserRole() async {
    final role = await SharedPreferencesHelper.getSelectedRole();
    print('👤 Retrieved user role: $role');
    return role;
  }

  // Method to get stored user data
  Future<UserModel?> getStoredUser() async {
    try {
      final prefs =
          await SharedPreferencesHelper.getSharedPreferencesInstance();
      final userDataString = prefs.getString('user_data');

      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        final user = UserModel.fromJson(userData);
        print('✅ Retrieved stored user: ${user.fullName}');
        return user;
      }
      print('⚠️ No stored user data found');
      return null;
    } catch (e) {
      print('❌ Error retrieving stored user: $e');
      return null;
    }
  }

  // Method to get access token
  Future<String?> getAccessToken() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null) {
      print('🔑 Access token retrieved: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ No access token found');
    }
    return token;
  }

  // Method to get refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferencesHelper.getSharedPreferencesInstance();
    final token = prefs.getString('refresh_token');
    if (token != null) {
      print('🔄 Refresh token retrieved: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ No refresh token found');
    }
    return token;
  }

  // Load user data on app start
  Future<void> loadStoredUserData() async {
    print('📂 Loading stored user data...');
    final user = await getStoredUser();
    if (user != null) {
      currentUser.value = user;
      print('✅ User data loaded: ${user.fullName}');
    } else {
      print('⚠️ No user data to load');
    }
  }
}
