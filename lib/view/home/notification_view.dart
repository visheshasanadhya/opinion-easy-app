import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/controller/notification_controller.dart';
import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController controller = Get.put(NotificationController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 150 &&
          !controller.isLoadingMore.value &&
          controller.hasMore) {
        controller.loadMoreNotifications();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: CustomAppBar(
        title: "Notifications",
        showBackButton: true,
        actions: [
          Obx(() {
            final unreadCount =
                controller.notifications.where((e) => !e.isRead).length;

            final bool hasUnread = unreadCount > 0;

            return controller.isMarking.value
                ? const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: hasUnread
                                ? const Color(0xFF4A90E2).withOpacity(0.15)
                                : const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: hasUnread
                                  ? const Color(0xFF4A90E2).withOpacity(0.3)
                                  : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: InkWell(
                            onTap: controller.notifications.isEmpty ||
                                    !hasUnread
                                ? null
                                : () {
                                    final ids = controller.notifications
                                        .where((e) => !e.isRead)
                                        .map((e) => e.id)
                                        .toList();
                                    if (ids.isNotEmpty) {
                                      controller.markNotificationsAsRead(ids);
                                    }
                                  },
                            borderRadius: BorderRadius.circular(12),
                            child: Icon(
                              Icons.done_all_rounded,
                              color: hasUnread
                                  ? const Color(0xFF4A90E2)
                                  : Colors.grey[700],
                              size: 22,
                            ),
                          ),
                        ),
                        if (hasUnread)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF512F),
                                    Color(0xFFDD2476),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF141414),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF512F,
                                    ).withOpacity(0.4),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99 ? '99+' : '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.notifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A90E2)),
            );
          }

          if (controller.notifications.isEmpty && !controller.isLoading.value) {
            return const _EmptyStateWidget();
          }

          return RefreshIndicator(
            color: const Color(0xFF4A90E2),
            backgroundColor: const Color(0xFF1A1A1A),
            onRefresh: () => controller.fetchNotifications(isRefresh: true),
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.notifications.length +
                  (controller.hasMore ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == controller.notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  );
                }

                final item = controller.notifications[index];
                return _NotificationItemWidget(
                  item: item,
                  controller: controller,
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF4A90E2).withOpacity(0.2),
                      const Color(0xFF357ABD).withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: 64,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "All Clear! 🎉",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "You're all caught up!\nNo new notifications right now.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationItemWidget extends StatelessWidget {
  final dynamic item;
  final NotificationController controller;

  const _NotificationItemWidget({required this.item, required this.controller});

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    } else if (difference.inDays >= 1) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }

  IconData _getNotificationIcon() {
    return item.isRead
        ? Icons.mark_email_read_rounded
        : Icons.mark_email_unread_rounded;
  }

  @override
  Widget build(BuildContext context) {
    bool isRead = item.isRead;

    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        controller.notifications.remove(item);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (!isRead) {
              item.isRead = true;
              controller.notifications.refresh();
              await controller.markNotificationsAsRead([item.id]);
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isRead
                    ? Colors.white.withOpacity(0.1)
                    : const Color(0xFF4A90E2).withOpacity(0.4),
                width: isRead ? 1 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isRead
                      ? Colors.black.withOpacity(0.3)
                      : const Color(0xFF4A90E2).withOpacity(0.2),
                  blurRadius: isRead ? 12 : 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isRead
                          ? [
                              Colors.grey.withOpacity(0.15),
                              Colors.grey.withOpacity(0.1),
                            ]
                          : [
                              const Color(0xFF4A90E2).withOpacity(0.2),
                              const Color(0xFF357ABD).withOpacity(0.2),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isRead
                          ? Colors.grey.withOpacity(0.2)
                          : const Color(0xFF4A90E2).withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    _getNotificationIcon(),
                    color: isRead ? Colors.grey[600] : const Color(0xFF4A90E2),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isRead ? FontWeight.w600 : FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isRead)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF512F),
                                    Color(0xFFDD2476),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF512F,
                                    ).withOpacity(0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                          height: 1.5,
                          letterSpacing: 0.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTimeAgo(item.createdAt),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
