class Urls {
  static const String baseUrl = 'http://10.10.13.27:8005/api/v1';

  // Role-specific login endpoints
  static const String agentLogin = '$baseUrl/agent/auth/login/';
  static const String buyerLogin = '$baseUrl/buyer/auth/login/';
  static const String sellerLogin = '$baseUrl/seller/auth/login/';

  // Role-specific registration endpoints
  static const String agentRegister = '$baseUrl/agent/auth/register/';
  static const String buyerRegister = '$baseUrl/buyer/auth/register/';
  static const String sellerRegister = '$baseUrl/seller/auth/register/';

  static const String sellerSellingRequestslist =
      '$baseUrl/seller/selling-requests/';
  static const String sellerAgents = '$baseUrl/seller/agents/';
  static const String sellerSellingpostRequests =
      '$baseUrl/seller/selling-requests/';
  static const String sellerProfile = '$baseUrl/seller/profile/';
  static const String sellerProfileUpdate = '$baseUrl/seller/profile/update/';
  static const String sellerChangePassword =
      '$baseUrl/seller/profile/change-password/';

  // Old endpoints (kept for reference)
  static const String login = '$baseUrl/auth/login';
  static const String updateProfile = '$baseUrl/auth/profile';
  static const String updateProfileImage = '$baseUrl/auth/update/profile-image';
  static const String getProfile = '$baseUrl/auth/profile';
  static const String deleteProfile = '$baseUrl/users/';
  static const String createGroup = '$baseUrl/group/create';
  static const String myGrouplist = '$baseUrl/group/my-groups';
  static const String groupAddMember = '$baseUrl/group/add';

  // Helper method to get login endpoint based on role
  static String getLoginEndpoint(String role) {
    switch (role.toLowerCase()) {
      case 'agent':
        return agentLogin;
      case 'seller':
        return sellerLogin;
      case 'buyer':
      default:
        return buyerLogin;
    }
  }

  // Helper method to get registration endpoint based on role
  static String getRegisterEndpoint(String role) {
    switch (role.toLowerCase()) {
      case 'agent':
        return agentRegister;
      case 'seller':
        return sellerRegister;
      case 'buyer':
      default:
        return buyerRegister;
    }
  }
}
