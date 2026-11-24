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
  final AdPreloadService _preload = Get.find<AdPreloadService>();

  /// Single native ad shared across ALL pages — consumed once from pool.
  late final AdsController _sharedNativeAd;

  @override
  void initState() {
    super.initState();
    _sharedNativeAd = _preload.consumeFromPool();
    controller.fetchQuestions(widget.subCategName, widget.categInt.toString());
  }

  @override
  void dispose() {
    _sharedNativeAd.disposeNative();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,

      // ── Native ad pinned at the very bottom ───────────────────────────────
      // Shrinks to nothing instantly if the ad isn't loaded — no shimmer wait.
      bottomNavigationBar: Obx(() {
        if (!_sharedNativeAd.isNativeLoaded.value)
          return const SizedBox.shrink();
        return SafeArea(
          top: false,
          child: DarkNativeAdWidget(
            isLoaded: _sharedNativeAd.isNativeLoaded,
            nativeAd: _sharedNativeAd.nativeAd,
            height: 300,
            showShimmer: false, // no shimmer — we only render when ready
          ),
        );
      }),

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

                    // ── Yes / No buttons ───────────────────────────────────
                    Obx(() {
                      final isDisabled = controller.isSubmitting.value;
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 52),
                                backgroundColor: isDisabled
                                    ? AppColor.green.withOpacity(0.4)
                                    : AppColor.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              onPressed: isDisabled
                                  ? null
                                  : () => controller.confirmSubmission('Yes'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: AppColor.white.withOpacity(
                                      isDisabled ? 0.6 : 1,
                                    ),
                                    size: 22,
                                  ),
                                  HS(6),
                                  Text(
                                    'Yes',
                                    style: AppText.body.copyWith(
                                      color: AppColor.white.withOpacity(
                                        isDisabled ? 0.6 : 1,
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
                                minimumSize: const Size(double.infinity, 52),
                                backgroundColor: isDisabled
                                    ? AppColor.red.withOpacity(0.4)
                                    : AppColor.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              onPressed: isDisabled
                                  ? null
                                  : () => controller.confirmSubmission('No'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel_outlined,
                                    color: AppColor.white.withOpacity(
                                      isDisabled ? 0.6 : 1,
                                    ),
                                    size: 22,
                                  ),
                                  HS(6),
                                  Text(
                                    'No',
                                    style: AppText.body.copyWith(
                                      color: AppColor.white.withOpacity(
                                        isDisabled ? 0.6 : 1,
                                      ),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    VS(8),

                    // ── Back / Skip ────────────────────────────────────────
                    Obx(
                      () => Row(
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
                                  color: AppColor.whileColor,
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
                                  : () =>
                                      controller.nextQuestion(isSkipped: true),
                              icon: Text(
                                'Skip',
                                style: AppText.captionSm.copyWith(
                                  color: AppColor.whileColor,
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
                    ),
                    VS(12),

                    PollResultWidget(
                      yesCount: question.yesCount,
                      noCount: question.noCount,
                    ),
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
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3)),
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
              color: AppColor.red.withOpacity(0.85),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
