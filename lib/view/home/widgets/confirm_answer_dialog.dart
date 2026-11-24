import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:opinion_easy/core/admob/admob.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/app_shimmer.dart';
import 'package:opinion_easy/data/model/question_model.dart';

class ConfirmAnswerDialog extends StatefulWidget {
  final String answer;
  final Question question;
  final Future<void> Function(String answer) onConfirm;
  final VoidCallback onCancel;

  const ConfirmAnswerDialog({
    super.key,
    required this.answer,
    required this.question,
    required this.onConfirm,
    required this.onCancel,
  });

  static void show({
    required String answer,
    required Question question,
    required Future<void> Function(String answer) onConfirm,
    required VoidCallback onCancel,
  }) {
    Get.dialog(
      ConfirmAnswerDialog(
        answer: answer,
        question: question,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
      barrierDismissible: false,
      barrierColor: AppColor.black.withOpacity(0.75),
    );
  }

  @override
  State<ConfirmAnswerDialog> createState() => _ConfirmAnswerDialogState();
}

class _ConfirmAnswerDialogState extends State<ConfirmAnswerDialog> {
  late final AdsController _topAdController;
  late final AdsController _bottomAdController;

  bool _showTopLoading = true;
  bool _showBottomLoading = true;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _topAdController = AdsController();
    _bottomAdController = AdsController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _topAdController.loadAdaptiveBanner(
        context,
        adUnitId: AdUnits.dialogTopBanner,
      );
      _bottomAdController.loadAdaptiveBanner(
        context,
        adUnitId: AdUnits.dialogBottomBanner,
      );
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted &&
          (!_topAdController.isLoaded.value ||
              _topAdController.bannerAd == null)) {
        setState(() => _showTopLoading = false);
      }
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted &&
          (!_bottomAdController.isLoaded.value ||
              _bottomAdController.bannerAd == null)) {
        setState(() => _showBottomLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _topAdController.disposeBanner();
    _bottomAdController.disposeBanner();
    super.dispose();
  }

  void _handleCancel() {
    if (Get.isDialogOpen ?? false) Get.back();
    widget.onCancel();
  }

  Future<void> _handleConfirm() async {
    if (_isConfirming) return;
    setState(() => _isConfirming = true);
    if (Get.isDialogOpen ?? false) Get.back();
    await Future.delayed(const Duration(milliseconds: 200));
    await widget.onConfirm(widget.answer);
  }

  @override
  Widget build(BuildContext context) {
    final isYes = widget.answer == "Yes";
    final accentColor = isYes ? AppColor.green : AppColor.red;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColor.borderFaint),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Top banner ───────────────────────────
              _bannerSlot(
                controller: _topAdController,
                showLoading: _showTopLoading,
              ),
              const SizedBox(height: 20),

              // ── Icon ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withOpacity(0.25)),
                ),
                child: Icon(
                  isYes
                      ? Icons.check_circle_outline_rounded
                      : Icons.cancel_outlined,
                  color: accentColor,
                  size: 30,
                ),
              ),
              const SizedBox(height: 14),

              // ── Title ─────────────────────────────────
              const Text(
                "Confirm Selection",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColor.textWhite,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              // ── Subtitle ─────────────────────────────
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.textMuted,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: "Are you sure you want to select "),
                    TextSpan(
                      text: "'${widget.answer}'",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                    const TextSpan(text: "?"),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Points row ───────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColor.cardAlt,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColor.borderFaint),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _pointItem(
                        "Spend", widget.question.attempPoint, AppColor.red),
                    Container(
                        width: 1, height: 28, color: AppColor.borderLight),
                    _pointItem("Earn", widget.question.points, AppColor.green),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── Buttons ──────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isConfirming ? null : _handleCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(
                          color: AppColor.white.withOpacity(0.15),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColor.textGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isConfirming ? null : _handleConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isConfirming
                            ? accentColor.withOpacity(0.4)
                            : accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isConfirming
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.white,
                              ),
                            )
                          : const Text(
                              "Confirm",
                              style: TextStyle(
                                color: AppColor.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Bottom banner ────────────────────────
              _bannerSlot(
                controller: _bottomAdController,
                showLoading: _showBottomLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Ad banner slot ─────────────────────────────────────────

  Widget _bannerSlot({
    required AdsController controller,
    required bool showLoading,
  }) {
    return Obx(() {
      if (controller.isLoaded.value && controller.bannerAd != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: controller.bannerAd!.size.width.toDouble(),
            height: controller.bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: controller.bannerAd!),
          ),
        );
      }
      if (showLoading) {
        return AppShimmer.nativeAdPlaceholder(height: 50);
      }
      return const SizedBox.shrink();
    });
  }

  // ── Point item ─────────────────────────────────────────────

  Widget _pointItem(String label, int val, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "label",
          style: TextStyle(
            fontSize: 11,
            color: AppColor.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAsset.coin, height: 16),
            const SizedBox(width: 4),
            Text(
              "$val",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
