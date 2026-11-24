import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';

class BackPressExitHandler extends StatefulWidget {
  final Widget child;
  final bool isHomeTab;
  final VoidCallback onGoHome;

  const BackPressExitHandler({
    super.key,
    required this.child,
    required this.isHomeTab,
    required this.onGoHome,
  });

  @override
  State<BackPressExitHandler> createState() => _BackPressExitHandlerState();
}

class _BackPressExitHandlerState extends State<BackPressExitHandler> {
  DateTime? _lastBackPress;
  static const Duration _backPressInterval = Duration(seconds: 2);
  OverlayEntry? _toastEntry;

  // ── Main back-press logic ──────────────────────────────────
  Future<bool> _onWillPop() async {
    // If not on the Home tab, switch back to Home first
    if (!widget.isHomeTab) {
      widget.onGoHome();
      return false;
    }

    final now = DateTime.now();
    final isFirstPress = _lastBackPress == null ||
        now.difference(_lastBackPress!) > _backPressInterval;

    if (isFirstPress) {
      _lastBackPress = now;
      _showToast('Press back again to exit');
      return false;
    }

    // Second press within 2s → show confirmation dialog
    await _showExitDialog();
    return false;
  }

  // ── Floating toast ─────────────────────────────────────────
  void _showToast(String message) {
    _toastEntry?.remove();
    _toastEntry = null;

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    _toastEntry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 90,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: AppColor.transparent,
            child: _ToastBubble(message: message),
          ),
        ),
      ),
    );

    overlay.insert(_toastEntry!);

    Future.delayed(_backPressInterval, () {
      if (mounted) {
        _toastEntry?.remove();
        _toastEntry = null;
      }
    });
  }

  // ── Exit confirmation dialog (matches _showLogoutDialog) ───
  Future<void> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColor.blackOp(0.65),
      builder: (ctx) => const _ExitDialog(),
    );

    if (result == true) {
      SystemNavigator.pop();
    }
  }

  @override
  void dispose() {
    _toastEntry?.remove();
    _toastEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _onWillPop();
      },
      child: widget.child,
    );
  }
}

// ── Toast Bubble ───────────────────────────────────────────────
class _ToastBubble extends StatefulWidget {
  final String message;
  const _ToastBubble({required this.message});

  @override
  State<_ToastBubble> createState() => _ToastBubbleState();
}

class _ToastBubbleState extends State<_ToastBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.cardAlt,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColor.borderLight),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackOp(0.45),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColor.red.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.exit_to_app_rounded,
                  color: AppColor.red,
                  size: 16,
                ),
              ),
              HS(10),
              Text(
                widget.message,
                style: AppText.bodySm.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Exit Dialog (Styled identical to _showLogoutDialog) ─────────
class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.card,
          borderRadius: BorderRadius.circular(AppDeco.radiusLg),
          border: Border.all(color: AppColor.borderLight),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDeco.circleBorder,
              child: const Icon(
                Icons.logout_rounded,
                color: AppColor.white,
                size: 28,
              ),
            ),
            VS(16),
            Text("Exit App?", style: AppText.h1),
            VS(8),
            Text(
              "Are you sure you want to exit\nOpinion Easy?",
              textAlign: TextAlign.center,
              style: AppText.caption,
            ),
            VS(22),
            Row(
              children: [
                Expanded(
                  child: SecondaryBtnWidget(
                    name: "Stay",
                    onTap: () => Navigator.of(context).pop(false),
                    horizontalPadding: 0,
                  ),
                ),
                HS(12),
                Expanded(
                  child: PrimaryBtnWidget(
                    name: "Exit",
                    onTap: () => Navigator.of(context).pop(true),
                    horizontalPadding: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
