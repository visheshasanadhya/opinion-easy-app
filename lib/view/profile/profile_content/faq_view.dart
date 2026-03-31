import 'package:opinion_easy/controller/faq_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';

class FAQView extends StatelessWidget {
  final FaqController faqController = Get.put(FaqController());

  FAQView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: CustomAppBar(title: "FAQ'S"),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Obx(() {
          final faqs = faqController.faqs;

          if (faqController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primaryColor1),
            );
          }

          if (faqs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  Text(
                    "No FAQs available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: faqs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = faqs[index];

              return _FAQTile(item: item);
            },
          );
        }),
      ),
    );
  }
}

class _FAQTile extends StatefulWidget {
  final dynamic item;
  const _FAQTile({required this.item});

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _expanded
              ? AppColor.primaryColor1.withOpacity(0.4)
              : Colors.white.withOpacity(0.07),
          width: 1,
        ),
        boxShadow: _expanded
            ? [
                BoxShadow(
                  color: AppColor.primaryColor1.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            onExpansionChanged: (val) => setState(() => _expanded = val),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            // Custom trailing icon
            trailing: AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _expanded
                      ? AppColor.primaryColor1.withOpacity(0.15)
                      : Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _expanded ? AppColor.primaryColor1 : Colors.grey[400],
                  size: 20,
                ),
              ),
            ),
            title: Text(
              widget.item.question ?? "",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Text(
                  widget.item.answer ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
