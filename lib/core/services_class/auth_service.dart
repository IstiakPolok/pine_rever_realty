import 'package:get/get.dart';
import 'package:pine_rever_realty/feature/auth/login/controller/login_controller.dart';
import 'package:pine_rever_realty/feature/auth/roleSelect/screens/roleSelectScreen.dart';
import 'local_service/shared_preferences_helper.dart';

/// Authentication Service
/// Handles logout and other auth-related operations
class AuthService {
  /// Logout user and clear all stored data
  static Future<void> logout() async {
    try {
      print('🚪 Starting logout process...');

      // Get or create LoginController instance
      final loginController = Get.put(LoginController());

      // Clear all tokens and user data
      await loginController.logout();

      print('✅ Logout completed successfully');

      // Navigate to role select screen and clear navigation stack
      Get.offAll(() => const roleSelect());

      print('✅ Navigated to role select screen');
    } catch (e) {
      print('❌ Error during logout: $e');

      // Fallback: Clear data directly if controller fails
      try {
        await SharedPreferencesHelper.logoutUser();
        Get.offAll(() => const roleSelect());
      } catch (fallbackError) {
        print('❌ Fallback logout also failed: $fallbackError');
      }
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final isLogin = await SharedPreferencesHelper.checkLogin();
      return isLogin ?? false;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  /// Get current user role
  static Future<String?> getUserRole() async {
    try {
      final prefs =
          await SharedPreferencesHelper.getSharedPreferencesInstance();
      return prefs.getString('user_role');
    } catch (e) {
      print('❌ Error getting user role: $e');
      return null;
    }
  }

  /// Get current user email
  static Future<String?> getUserEmail() async {
    try {
      return await SharedPreferencesHelper.getEmail();
    } catch (e) {
      print('❌ Error getting user email: $e');
      return null;
    }
  }

  /// Get current user name
  static Future<String?> getUserName() async {
    try {
      return await SharedPreferencesHelper.getName();
    } catch (e) {
      print('❌ Error getting user name: $e');
      return null;
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    try {
      return await SharedPreferencesHelper.getAccessToken();
    } catch (e) {
      print('❌ Error getting access token: $e');
      return null;
    }
  }
}
