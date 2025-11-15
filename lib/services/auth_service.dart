import 'package:suarafe/core/api_client.dart';
import 'package:suarafe/core/constants.dart';
import 'package:suarafe/models/user_model.dart';

class AuthService {
  final _api = ApiClient();

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? nidn,
    String? nim,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.register,
        body: {
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
          if (nidn != null) 'nidn': nidn,
          if (nim != null) 'nim': nim,
        },
      );

      final data = _api.parseResponse(response);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': data?['message'] ?? 'Registration successful',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data?['message'] ?? 'Registration failed',
          'errors': data?['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.login,
        body: {
          'email': email,
          'password': password,
        },
      );

      final data = _api.parseResponse(response);
      if (response.statusCode == 200 && data != null) {
        final rootData = data['data'] as Map<String, dynamic>?; // wrapper
        final token = rootData?['token'] as String?;
        final userMap = rootData?['user'] as Map<String, dynamic>?;
        if (token != null) {
          await _api.setToken(token);
        }
        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'token': token,
          'user': userMap != null ? UserModel.fromJson(userMap) : null,
        };
      }
      return {
        'success': false,
        'message': data?['message'] ?? 'Login failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _api.post(
        ApiConstants.logout,
        requireAuth: true,
      );

      await _api.clearToken();
      
      return {
        'success': response.statusCode == 200,
        'message': 'Logout successful',
      };
    } catch (e) {
      await _api.clearToken();
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<UserModel?> getProfile() async {
    try {
      final response = await _api.get(
        ApiConstants.profile,
        requireAuth: true,
      );
      if (response.statusCode == 200) {
        final data = _api.parseResponse(response);
        if (data != null) {
          final inner = data['data'] as Map<String, dynamic>?; // wrapper
          if (inner != null) {
            return UserModel.fromJson(inner);
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (avatar != null) body['avatar'] = avatar;

      final response = await _api.put(
        ApiConstants.profile,
        body: body,
        requireAuth: true,
      );

      final data = _api.parseResponse(response);
      if (response.statusCode == 200 && data != null) {
        final inner = data['data'] as Map<String, dynamic>?; // wrapper
        return {
          'success': true,
          'message': data['message'] ?? 'Profile updated',
          'user': inner != null ? UserModel.fromJson(inner) : null,
        };
      }
      return {
        'success': false,
        'message': data?['message'] ?? 'Update failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<WalletInfo?> getWallet() async {
    try {
      final response = await _api.get(
        ApiConstants.profileWallet,
        requireAuth: true,
      );
      if (response.statusCode == 200) {
        final data = _api.parseResponse(response);
        if (data != null) {
          final inner = data['data'] as Map<String, dynamic>?; // wrapper
          if (inner != null) {
            return WalletInfo.fromJson(inner);
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
