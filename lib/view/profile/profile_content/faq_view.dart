import 'package:opinion_easy/controller/faq_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/widgets/app_loader.dart';
import '../../../core/utils/widgets/app_refresh.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';

class FAQView extends StatelessWidget {
  final FaqController faqController = Get.put(FaqController());

  FAQView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: const CustomAppBar(title: "FAQ'S"),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Obx(() {
          final faqs = faqController.faqs;

          if (faqController.isLoading.value) {
            return const AppLoader();
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

          return AppRefresh(
            onRefresh: faqController.fetchFaqs,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: faqs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = faqs[index];
                return _FAQTile(item: item);
              },
            ),
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
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _expanded
              ? primaryColor.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.07),
          width: 1,
        ),
        boxShadow: _expanded
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.08),
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
              vertical: 4,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _expanded
                    ? primaryColor.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.help_outline_rounded,
                color: _expanded ? primaryColor : Colors.grey[400],
                size: 20,
              ),
            ),
            title: Text(
              widget.item.question ?? "",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _expanded ? Colors.white : Colors.grey[200],
              ),
            ),
            trailing: AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _expanded ? primaryColor : Colors.grey[500],
                size: 24,
              ),
            ),
            children: [
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.item.answer ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey[300],
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
