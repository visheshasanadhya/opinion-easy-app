import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';

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
  static const _backPressInterval = Duration(seconds: 2);

  OverlayEntry? _toastEntry;

  // ── Main back-press logic ──────────────────────────────────
  Future<bool> _onWillPop() async {
    // Not on home tab → go home first
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

    // Second press within 2 s → show confirmation dialog
    await _showExitDialog();
    return false;
  }

  // ── Floating toast ─────────────────────────────────────────
  void _showToast(String message) {
    _toastEntry?.remove();

    _toastEntry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 90,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: _ToastBubble(message: message),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_toastEntry!);

    Future.delayed(_backPressInterval, () {
      _toastEntry?.remove();
      _toastEntry = null;
    });
  }

  // ── Exit confirmation dialog ───────────────────────────────
  Future<void> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (ctx) => const _ExitDialog(),
    );

    if (result == true) {
      SystemNavigator.pop();
    }
  }

  @override
  void dispose() {
    _toastEntry?.remove();
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
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
                  color: Colors.redAccent.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.redAccent,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
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

// ── Exit Dialog ────────────────────────────────────────────────
class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.09), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.55),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon container ─────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),

              // ── Title ──────────────────────────────────────
              const Text(
                'Exit App?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              // ── Subtitle ───────────────────────────────────
              Text(
                'Are you sure you want to exit\n Opinion Easy?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 28),

              // ── Buttons ────────────────────────────────────
              Row(
                children: [
                  // Stay / Cancel
                  Expanded(
                    child: SecondaryBtnWidget(
                      name: 'Stay',
                      onTap: () => Navigator.of(context).pop(false),
                      horizontalPadding: 0,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Exit
                  Expanded(
                    child: PrimaryBtnWidget(
                      name: 'Exit',
                      onTap: () => Navigator.of(context).pop(true),
                      horizontalPadding: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
