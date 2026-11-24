import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/notification_model.dart';
import 'api_client.dart';

class NotificationService1 {
  /// Fetch paginated notifications
  Future<Map<String, dynamic>> fetchNotifications({
    int page = 1,
    int limit = ApiEndpoints.limitPagination,
  }) async {
    final url = Uri.parse(
      "${ApiEndpoints.notification}?start=$page&limit=$limit",
    );
    final response = await ApiClient.get(url);

    debugPrint("📩 [NotificationService] Response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData is Map<String, dynamic> && jsonData["status"] == true) {
        final dataObject = jsonData["data"];

        if (dataObject is Map<String, dynamic> &&
            dataObject.containsKey('data')) {
          final List<dynamic> list = dataObject['data'] ?? [];
          final int lastPage = dataObject['last_page'] ?? 1;
          final int total = dataObject['total'] ?? list.length;

          final notifications = list
              .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList();

          return {
            "notifications": notifications,
            "last_page": lastPage,
            "total": total,
          };
        } else if (dataObject is List) {
          final notifications = dataObject
              .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList();

          return {
            "notifications": notifications,
            "last_page": 1,
            "total": notifications.length,
          };
        }
      }
      return {
        "notifications": <NotificationModel>[],
        "last_page": 1,
        "total": 0,
      };
    } else {
      throw Exception("Failed to fetch notifications (${response.statusCode})");
    }
  }

  /// Fetch unread notifications count
  Future<int> fetchUnreadCount() async {
    final url = Uri.parse(ApiEndpoints.unreadNotification);
    final response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data["status"] == true) {
        if (data["unread_count"] is int) {
          return data["unread_count"];
        } else if (data["unread_count"] != null) {
          return int.tryParse(data["unread_count"].toString()) ?? 0;
        }
      }
    }
    return 0;
  }

  /// Mark specific notification IDs as read
  Future<bool> markAsRead(List<int> ids) async {
    final url = Uri.parse(ApiEndpoints.markReadNotification);
    final response = await ApiClient.post(
      url,
      body: jsonEncode({"ids": ids}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is Map<String, dynamic> && data["status"] == true;
    }
    return false;
  }
}

/// Alias for NotificationService1
typedef NotificationService = NotificationService1;
