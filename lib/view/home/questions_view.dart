import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/controller/question_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/app_shimmer.dart';
import 'package:opinion_easy/core/admob/admob.dart';
import 'package:opinion_easy/view/home/widgets/poll_result_widget.dart';

class QuestionView extends StatefulWidget {
  final String subCategName;
  final int categInt;

  const QuestionView({
    super.key,
    required this.subCategName,
    required this.categInt,
  });

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final QuestionController controller = Get.put(QuestionController());

  @override
  void initState() {
    super.initState();
    controller.fetchQuestions(widget.subCategName, widget.categInt.toString());
  }

  @override
  void dispose() {
    Get.delete<QuestionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,

      // ── Native ad pinned at the very bottom ───────────────────────────────
      bottomNavigationBar: const SafeArea(
        top: false,
        child: AppNativeAd(height: 300),
      ),

      appBar: CustomAppBar(
        centerTitle: false,
        showBackButton: true,
        titleWidget: Obx(() {
          if (controller.questions.isEmpty) {
            return Text('Questions', style: AppText.h3);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.subCategName, style: AppText.bodyMd),
              VS(2),
              Obx(
                () => Text(
                  'Question ${controller.currentIndex.value + 1} of ${controller.questions.length}',
                  style: AppText.captionSm,
                ),
              ),
            ],
          );
        }),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return SingleChildScrollView(child: AppShimmer.questionCard());
        }
        if (controller.questions.isEmpty) {
          return Center(
            child: Text(
              'Next Opinion questions coming soon!',
              style: AppText.caption,
            ),
          );
        }
        return PageView.builder(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.questions.length,
          itemBuilder: (context, index) {
            final question = controller.questions[index];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // ── Question card ──────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      decoration: AppDeco.card,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Spend', style: AppText.captionSm),
                                    HS(8),
                                    _coinTag(
                                      points: question.attempPoint,
                                      color: AppColor.red,
                                      icon: AppAsset.coin,
                                    ),
                                  ],
                                ),
                              ),
                              HS(8),
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Earn', style: AppText.captionSm),
                                    HS(8),
                                    _coinTag(
                                      points: question.points,
                                      color: AppColor.green,
                                      icon: AppAsset.coin,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          VS(14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 26,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.cardAlt,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColor.borderFaint),
                            ),
                            child: Text(
                              question.question,
                              textAlign: TextAlign.center,
                              style: AppText.h4.copyWith(height: 1.45),
                            ),
                          ),
                          if (question.expiryDate != null)
                            _buildExpiryTime(question.expiryDate!),
                        ],
                      ),
                    ),
                    VS(18),

                    // ── Choice / Action Section ────────────────────────────
                    Obx(() {
                      final currentQ = controller.questions[index];
                      final bool hasAnswered = currentQ.isAnswered;
                      final String? chosenAnswer = currentQ.userAnswer;
                      final bool isYes = chosenAnswer?.toLowerCase() == 'yes';
                      final isDisabled = controller.isSubmitting.value;

                      if (hasAnswered) {
                        // ── User already answered: Show locked choice card & Poll results ─
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.cardAlt,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isYes
                                      ? AppColor.green.withValues(alpha: 0.35)
                                      : AppColor.red.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: (isYes
                                              ? AppColor.green
                                              : AppColor.red)
                                          .withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      isYes
                                          ? Icons.check_circle_rounded
                                          : Icons.cancel_rounded,
                                      color: isYes
                                          ? AppColor.green
                                          : AppColor.red,
                                      size: 20,
                                    ),
                                  ),
                                  HS(12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'YOUR OPINION',
                                        style: AppText.micro.copyWith(
                                          color: AppColor.textGrey,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      VS(2),
                                      Text(
                                        isYes ? 'YES' : 'NO',
                                        style: AppText.body.copyWith(
                                          color: isYes
                                              ? AppColor.green
                                              : AppColor.red,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.cardLight,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColor.borderFaint,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.lock_outline_rounded,
                                          size: 12,
                                          color: AppColor.textMuted,
                                        ),
                                        HS(4),
                                        Text(
                                          'Submitted',
                                          style: AppText.captionSm.copyWith(
                                            fontSize: 11,
                                            color: AppColor.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VS(16),

                            // ── Poll Result Widget (VISIBLE because answered) ─────
                            PollResultWidget(
                              yesCount: currentQ.pollResult?.yesCount ??
                                  currentQ.yesCount,
                              noCount: currentQ.pollResult?.noCount ??
                                  currentQ.noCount,
                              yesPercentage: currentQ.pollResult?.yesPercentage,
                              noPercentage: currentQ.pollResult?.noPercentage,
                              winChoice: currentQ.pollResult?.winChoice,
                            ),
                            VS(16),

                            // ── Navigation Buttons (Back / Next / Finish) ───────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (controller.currentIndex.value > 0)
                                  TextButton.icon(
                                    onPressed: () =>
                                        controller.previousQuestion(),
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 16,
                                      color: AppColor.white,
                                    ),
                                    label: Text(
                                      'Back',
                                      style: AppText.captionSm.copyWith(
                                        color: AppColor.white,
                                      ),
                                    ),
                                  )
                                else
                                  const Spacer(),
                                if (controller.currentIndex.value <
                                    controller.questions.length - 1)
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.white,
                                      foregroundColor: AppColor.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () => controller.nextQuestion(
                                      isSkipped: true,
                                    ),
                                    icon: Text(
                                      'Next Question',
                                      style: AppText.bodySm.copyWith(
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    label: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: AppColor.black,
                                    ),
                                  )
                                else
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.white,
                                      foregroundColor: AppColor.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () =>
                                        Get.offNamed('/thank-you'),
                                    child: Text(
                                      'Finish',
                                      style: AppText.bodySm.copyWith(
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        );
                      }

                      // ── User has NOT answered yet: Show Yes / No buttons & Back / Skip ──
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 52),
                                    backgroundColor: isDisabled
                                        ? AppColor.green.withValues(alpha: 0.4)
                                        : AppColor.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: isDisabled
                                      ? null
                                      : () =>
                                          controller.confirmSubmission('Yes'),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: AppColor.white.withValues(
                                          alpha: isDisabled ? 0.6 : 1,
                                        ),
                                        size: 22,
                                      ),
                                      HS(6),
                                      Text(
                                        'Yes',
                                        style: AppText.body.copyWith(
                                          color: AppColor.white.withValues(
                                            alpha: isDisabled ? 0.6 : 1,
                                          ),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              HS(14),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 52),
                                    backgroundColor: isDisabled
                                        ? AppColor.red.withValues(alpha: 0.4)
                                        : AppColor.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: isDisabled
                                      ? null
                                      : () =>
                                          controller.confirmSubmission('No'),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cancel_outlined,
                                        color: AppColor.white.withValues(
                                          alpha: isDisabled ? 0.6 : 1,
                                        ),
                                        size: 22,
                                      ),
                                      HS(6),
                                      Text(
                                        'No',
                                        style: AppText.body.copyWith(
                                          color: AppColor.white.withValues(
                                            alpha: isDisabled ? 0.6 : 1,
                                          ),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          VS(8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (controller.currentIndex.value > 0)
                                TextButton.icon(
                                  onPressed: controller.isSubmitting.value
                                      ? null
                                      : () => controller.previousQuestion(),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: AppColor.white,
                                  ),
                                  label: Text(
                                    'Back',
                                    style: AppText.captionSm.copyWith(
                                      color: AppColor.white,
                                    ),
                                  ),
                                )
                              else
                                const Spacer(),
                              if (controller.currentIndex.value <
                                  controller.questions.length - 1)
                                TextButton.icon(
                                  onPressed: controller.isSubmitting.value
                                      ? null
                                      : () => controller.nextQuestion(
                                            isSkipped: true,
                                          ),
                                  icon: Text(
                                    'Skip',
                                    style: AppText.captionSm.copyWith(
                                      color: AppColor.white,
                                    ),
                                  ),
                                  label: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: AppColor.white,
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    }),
                    VS(40),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _coinTag({
    required int points,
    required Color color,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 18,
            width: 18,
            child: Image.asset(icon, fit: BoxFit.contain),
          ),
          HS(4),
          Text('$points', style: AppText.labelSm.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildExpiryTime(DateTime expiryDate) {
    final local = expiryDate.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final ampm = local.hour >= 12 ? 'PM' : 'AM';
    final text =
        'Expires at: $hour:$minute $ampm on ${local.day}/${local.month}/${local.year}';
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.access_time_rounded, size: 13, color: AppColor.red),
          HS(5),
          Text(
            text,
            style: AppText.captionSm.copyWith(
              color: AppColor.red.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
