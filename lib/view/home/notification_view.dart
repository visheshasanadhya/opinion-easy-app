import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/controller/notification_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/app_loader.dart';
import 'package:opinion_easy/core/utils/widgets/app_refresh.dart';
import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:opinion_easy/data/model/notification_model.dart';

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
      backgroundColor: AppColor.scaffold,
      appBar: CustomAppBar(
        title: "Notifications",
        showBackButton: true,
        actions: [
          Obx(() {
            final unreadCount =
                controller.notifications.where((e) => !e.isRead).length;
            final bool hasUnread = unreadCount > 0;

            if (controller.isMarking.value) {
              return const Padding(
                padding: EdgeInsets.only(right: 16),
                child: AppLoader(size: 22, strokeWidth: 2.5),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: hasUnread
                          ? AppColor.blue.withValues(alpha: 0.15)
                          : AppColor.cardAlt,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasUnread
                            ? AppColor.blue.withValues(alpha: 0.3)
                            : AppColor.borderLight,
                      ),
                    ),
                    child: InkWell(
                      onTap: controller.notifications.isEmpty || !hasUnread
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
                        color: hasUnread ? AppColor.blue : AppColor.textMuted,
                        size: 22,
                      ),
                    ),
                  ),
                  if (hasUnread)
                    Positioned(
                      right: -3,
                      top: -3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColor.gradientNotif,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.card,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.gradientNotif[0]
                                  .withValues(alpha: 0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: AppText.micro.copyWith(
                              color: AppColor.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
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
            return const AppLoader();
          }

          if (controller.notifications.isEmpty && !controller.isLoading.value) {
            return _buildEmptyState();
          }

          return AppRefresh(
            onRefresh: () => controller.fetchNotifications(isRefresh: true),
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.notifications.length +
                  (controller.hasMore ? 1 : 0),
              separatorBuilder: (context, index) => const VS(12),
              itemBuilder: (context, index) {
                if (index == controller.notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: AppLoader(size: 24, strokeWidth: 2),
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

  Widget _buildEmptyState() {
    return AppRefresh(
      onRefresh: () => controller.fetchNotifications(isRefresh: true),
      child: Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: AppDeco.circleBorder,
                  child: const Icon(
                    Icons.notifications_off_outlined,
                    size: 48,
                    color: AppColor.textGrey,
                  ),
                ),
                const VS(20),
                const Text("No notifications yet", style: AppText.h3),
                const VS(8),
                Text(
                  "We'll notify you when something arrives",
                  textAlign: TextAlign.center,
                  style: AppText.caption.copyWith(color: AppColor.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationItemWidget extends StatelessWidget {
  final NotificationModel item;
  final NotificationController controller;

  const _NotificationItemWidget({
    required this.item,
    required this.controller,
  });

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

  @override
  Widget build(BuildContext context) {
    final bool isRead = item.isRead;

    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColor.red,
          borderRadius: BorderRadius.circular(AppDeco.radiusLg),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColor.white,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        controller.notifications.remove(item);
      },
      child: Material(
        color: AppColor.transparent,
        child: InkWell(
          onTap: () async {
            if (!isRead) {
              item.isRead = true;
              controller.notifications.refresh();
              await controller.markNotificationsAsRead([item.id]);
            }
          },
          borderRadius: BorderRadius.circular(AppDeco.radiusLg),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.cardAlt,
              borderRadius: BorderRadius.circular(AppDeco.radiusLg),
              border: Border.all(
                color: isRead
                    ? AppColor.borderLight
                    : AppColor.blue.withValues(alpha: 0.4),
                width: isRead ? 1 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isRead
                      ? AppColor.blackOp(0.3)
                      : AppColor.blue.withValues(alpha: 0.15),
                  blurRadius: isRead ? 8 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isRead
                        ? AppColor.cardLight
                        : AppColor.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppDeco.radius),
                    border: Border.all(
                      color: isRead
                          ? AppColor.borderFaint
                          : AppColor.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    isRead
                        ? Icons.mark_email_read_outlined
                        : Icons.mark_email_unread_outlined,
                    color: isRead ? AppColor.textMuted : AppColor.blue,
                    size: 22,
                  ),
                ),
                const HS(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: (isRead ? AppText.bodyMd : AppText.body)
                                  .copyWith(
                                color: isRead
                                    ? AppColor.textGrey
                                    : AppColor.textWhite,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isRead)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppColor.gradientNotif,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const VS(6),
                      Text(
                        item.message,
                        style: AppText.captionSm.copyWith(
                          color:
                              isRead ? AppColor.textMuted : AppColor.textGrey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const VS(10),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: AppColor.textMuted,
                          ),
                          const HS(4),
                          Text(
                            _formatTimeAgo(item.createdAt),
                            style: AppText.captionSm.copyWith(
                              fontSize: 12,
                              color: AppColor.textMuted,
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
