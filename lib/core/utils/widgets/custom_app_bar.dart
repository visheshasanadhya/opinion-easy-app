import 'package:flutter/material.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.title = "",
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.centerTitle = true,
    this.bottom,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + 1 + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColor.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? (leading ??
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: onBackButtonPressed ?? () => Navigator.pop(context),
              ))
          : leading,
      actions: actions,
      title: titleWidget ??
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: AppColor.whiteColor,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
      bottom: bottom ??
          PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: AppColor.borderFaint,
            ),
          ),
    );
  }
}
