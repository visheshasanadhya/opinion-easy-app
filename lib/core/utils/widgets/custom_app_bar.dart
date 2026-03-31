import 'package:flutter/material.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackButtonPressed,
  });

  @override
  // Standard height + 1 for the bottom border
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.bgCard,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? (leading ??
              IconButton(
                icon: const Icon(
                  // Icons.arrow_back,
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: onBackButtonPressed ?? () => Navigator.pop(context),
              ))
          : leading,
      actions: actions,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: AppColor.whiteColor,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.greyColor.withOpacity(0.1),
                AppColor.greyColor.withOpacity(0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
