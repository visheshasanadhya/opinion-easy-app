import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/data/model/notification_model.dart';
import '../data/service/api_client.dart';
import '../data/service/internet_monitor.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var isMarking = false.obs;
  var isLoadingMore = false.obs;

  int currentPage = 1;
  int totalPages = 1;

  bool get hasMore => currentPage < totalPages;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  /// Fetch notifications (with pagination)
  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (InternetMonitor.isOffline) {
      isLoading.value = false;
      isRefreshing.value = false;
      return;
    }
    try {
      if (isRefresh) {
        currentPage = 1;
        isRefreshing.value = true;
      } else if (currentPage == 1) {
        isLoading.value = true;
      }

      final response = await ApiClient.get(
        Uri.parse(
          "${ApiEndpoints.notification}?start=$currentPage&limit=${ApiEndpoints.limitPagination}",
        ),
      );

      debugPrint("📩 Notification Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Safe type checking to prevent 'List<dynamic>' is not a subtype of 'Map<String, dynamic>' error
        if (jsonData is Map<String, dynamic> && jsonData["status"] == true) {
          final dataObject = jsonData["data"];

          if (dataObject is Map<String, dynamic> &&
              dataObject.containsKey('data')) {
            final List<dynamic> list = dataObject['data'];
            totalPages = dataObject['last_page'] ?? 1;

            if (isRefresh || currentPage == 1) {
              notifications.value = list
                  .map((e) => NotificationModel.fromJson(e))
                  .toList();
            } else {
              notifications.addAll(
                list.map((e) => NotificationModel.fromJson(e)).toList(),
              );
            }
          }
        }
      }
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) return;
      debugPrint("❌ Exception fetching notifications: $e");
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load more when scrolled
  Future<void> loadMoreNotifications() async {
    if (isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    currentPage++;
    await fetchNotifications();
  }

  /// Fetch unread count
  Future<void> fetchUnreadCount() async {
    if (InternetMonitor.isOffline) return;
    try {
      final response = await ApiClient.get(
        Uri.parse(ApiEndpoints.unreadNotification),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Ensure data is a Map before accessing 'status' and 'unread_count'
        if (data is Map<String, dynamic> && data["status"] == true) {
          // Use a safe cast or check if the value is an int
          unreadCount.value = data["unread_count"] is int
              ? data["unread_count"]
              : 0;
        }
      }
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) return;
      debugPrint("❌ Exception fetching unread count: $e");
    }
  }

  /// Mark given notifications as read
  Future<void> markNotificationsAsRead(List<int> ids) async {
    try {
      isMarking.value = true;
      final response = await ApiClient.post(
        Uri.parse(ApiEndpoints.markReadNotification),
        body: jsonEncode({"ids": ids}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data["status"] == true) {
          // After successfully marking as read, refresh the list and count
          await fetchNotifications(isRefresh: true);
          await fetchUnreadCount();
        }
      }
    } catch (e) {
      debugPrint("❌ Exception marking notifications: $e");
    } finally {
      isMarking.value = false;
    }
  }
}
