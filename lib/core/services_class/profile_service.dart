import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pine_rever_realty/core/network_caller/endpoints.dart';
import 'package:pine_rever_realty/feature/auth/login/model/login_response_model.dart';
import 'auth_service.dart';

class ProfileService {
  /// Fetch agent profile using saved bearer token
  static Future<UserModel?> fetchAgentProfile() async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        print('ProfileService.fetchAgentProfile: no token found');
        return null;
      }

      final uri = Uri.parse(Urls.agentProfile);
      print('ProfileService.fetchAgentProfile: GET $uri');
      print('ProfileService.fetchAgentProfile: Authorization present');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(
        'ProfileService.fetchAgentProfile: response ${response.statusCode}',
      );
      print('ProfileService.fetchAgentProfile: body ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        // API likely returns user object directly; adapt if response wraps it.
        return UserModel.fromJson(body);
      } else {
        return null;
      }
    } catch (e) {
      print('ProfileService.fetchAgentProfile error: $e');
      return null;
    }
  }

  /// Update agent profile using JSON body
  static Future<UserModel?> updateAgentProfile(
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        print('ProfileService.updateAgentProfile: no token found');
        return null;
      }

      final uri = Uri.parse(Urls.agentProfileUpdate);
      print('ProfileService.updateAgentProfile: PATCH $uri');
      print('ProfileService.updateAgentProfile: body ${jsonEncode(body)}');

      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print(
        'ProfileService.updateAgentProfile: response ${response.statusCode}',
      );
      print('ProfileService.updateAgentProfile: body ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('ProfileService.updateAgentProfile error: $e');
      return null;
    }
  }

  /// Multipart PATCH to upload files along with fields.
  static Future<UserModel?> updateAgentProfileMultipart({
    Map<String, String>? fields,
    String? profilePicturePath,
    List<int>? profilePictureBytes,
    String? profilePictureFilename,
    String? agentPapersPath,
    List<int>? agentPapersBytes,
    String? agentPapersFilename,
  }) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) return null;

      final uri = Uri.parse(Urls.agentProfileUpdate);
      final request = http.MultipartRequest('PATCH', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      if (fields != null) request.fields.addAll(fields);

      if (profilePicturePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_picture',
            profilePicturePath,
            filename: profilePictureFilename,
          ),
        );
      } else if (profilePictureBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'profile_picture',
            profilePictureBytes,
            filename: profilePictureFilename ?? 'profile.jpg',
          ),
        );
      }

      if (agentPapersPath != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'agent_papers',
            agentPapersPath,
            filename: agentPapersFilename,
          ),
        );
      } else if (agentPapersBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'agent_papers',
            agentPapersBytes,
            filename: agentPapersFilename ?? 'agent_papers.pdf',
          ),
        );
      }

      // Debug prints
      print('ProfileService.updateAgentProfileMultipart: PATCH $uri');
      print(
        'ProfileService.updateAgentProfileMultipart: fields ${request.fields}',
      );
      print(
        'ProfileService.updateAgentProfileMultipart: files ${request.files.map((f) => f.filename).toList()}',
      );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print(
        'ProfileService.updateAgentProfileMultipart: response ${response.statusCode}',
      );
      print(
        'ProfileService.updateAgentProfileMultipart: body ${response.body}',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
