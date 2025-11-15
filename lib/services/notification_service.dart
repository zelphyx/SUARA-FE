import 'package:suarafe/core/api_client.dart';
import 'package:suarafe/core/constants.dart';
import 'package:suarafe/models/notification_model.dart';

class NotificationService {
  final _api = ApiClient();

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _api.get(
        ApiConstants.notifications,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final data = _api.parseListResponse(response) ?? 
                     _api.parseResponse(response)?['data'] as List?;
        if (data != null) {
          return data
              .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> markAsRead(String id) async {
    try {
      final response = await _api.put(
        ApiConstants.notificationRead(id),
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Notification marked as read',
        };
      } else {
        final data = _api.parseResponse(response);
        return {
          'success': false,
          'message': data?['message'] ?? 'Failed to mark as read',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> markAllAsRead() async {
    try {
      final response = await _api.put(
        ApiConstants.notificationsReadAll,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'All notifications marked as read',
        };
      } else {
        final data = _api.parseResponse(response);
        return {
          'success': false,
          'message': data?['message'] ?? 'Failed to mark all as read',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _api.get(
        ApiConstants.notificationsUnreadCount,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final data = _api.parseResponse(response);
        return data?['count'] as int? ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}

