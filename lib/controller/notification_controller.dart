import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/data/model/notification_model.dart';
import 'package:opinion_easy/data/service/notification_service1.dart';
import '../data/service/internet_monitor.dart';

class NotificationController extends GetxController {
  final NotificationService1 notificationService = NotificationService1();

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

      final result = await notificationService.fetchNotifications(
        page: currentPage,
      );

      final List<NotificationModel> list =
          result["notifications"] as List<NotificationModel>;
      totalPages = result["last_page"] ?? 1;

      if (isRefresh || currentPage == 1) {
        notifications.assignAll(list);
      } else {
        notifications.addAll(list);
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
      final count = await notificationService.fetchUnreadCount();
      unreadCount.value = count;
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) return;
      debugPrint("❌ Exception fetching unread count: $e");
    }
  }

  /// Mark given notifications as read
  Future<void> markNotificationsAsRead(List<int> ids) async {
    try {
      isMarking.value = true;
      final success = await notificationService.markAsRead(ids);

      if (success) {
        // After successfully marking as read, refresh the list and count
        await fetchNotifications(isRefresh: true);
        await fetchUnreadCount();
      }
    } catch (e) {
      debugPrint("❌ Exception marking notifications: $e");
    } finally {
      isMarking.value = false;
    }
  }
}
