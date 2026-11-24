import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/admob/admob.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
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
      barrierColor: AppColor.black.withValues(alpha: 0.75),
    );
  }

  @override
  State<ConfirmAnswerDialog> createState() => _ConfirmAnswerDialogState();
}

class _ConfirmAnswerDialogState extends State<ConfirmAnswerDialog> {
  bool _isConfirming = false;

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
              AppBannerAd(adUnitId: AdUnits.dialogTopBanner),
              const SizedBox(height: 20),

              // ── Icon ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withValues(alpha: 0.25)),
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
                          color: AppColor.white.withValues(alpha: 0.15),
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
                            ? accentColor.withValues(alpha: 0.4)
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
              AppBannerAd(adUnitId: AdUnits.dialogBottomBanner),
            ],
          ),
        ),
      ),
    );
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
