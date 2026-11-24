import 'package:opinion_easy/controller/question_controller.dart';
import 'package:opinion_easy/controller/sub_categ_controller.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:opinion_easy/view/home/questions_view.dart';
import 'package:opinion_easy/view/home/widgets/live_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryCard extends StatelessWidget {
  final dynamic subCategory;
  final int index;
  final QuestionController questionController;

  final SubCategController subCategController = Get.find<SubCategController>();

  SubCategoryCard({
    super.key,
    required this.subCategory,
    required this.index,
    required this.questionController,
  });

  @override
  Widget build(BuildContext context) {
    final title = (subCategory.name?.trim().isNotEmpty ?? false)
        ? subCategory.name!
        : "Unknown Subcategory";
    final subTitle = (subCategory.description?.trim().isNotEmpty ?? false)
        ? subCategory.description!
        : "No description available.";
    final bool hasNew = (subCategory.leftQuestionCount ?? 0) > 0;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => QuestionView(
            subCategName: subCategory.name.toString(),
            categInt: subCategory.id ?? 0,
          ),
        );
        questionController.fetchQuestions(
          subCategory.name.toString(),
          subCategory.id.toString(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Index badge ────────────────────────────
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              alignment: Alignment.center,
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ── Text ───────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasNew) ...[
                        HS(8),
                        const LiveIndicator(),
                      ],
                    ],
                  ),
                  VS(4),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // ── Arrow ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
