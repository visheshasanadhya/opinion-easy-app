import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:opinion_easy/view/home/widgets/sub_category_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/controller/category_controller.dart';
import 'package:opinion_easy/controller/question_controller.dart';
import 'package:opinion_easy/core/admob/admob.dart';
import 'package:opinion_easy/controller/sub_categ_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/app_shimmer.dart';

class SubCategView extends StatefulWidget {
  const SubCategView({super.key});

  @override
  State<SubCategView> createState() => _SubCategViewState();
}

class _SubCategViewState extends State<SubCategView> {
  final CategoryController categoryController = Get.find<CategoryController>();
  final SubCategController subCategController = Get.find<SubCategController>();
  final QuestionController questionController = Get.put(QuestionController());
  final AdPreloadService _preload = Get.find<AdPreloadService>();

  late final AdsController middleNativeAdsController;
  late final AdsController endNativeAdsController;

  bool _showMiddleShimmer = true;
  bool _showEndShimmer = true;

  @override
  void initState() {
    super.initState();
    middleNativeAdsController = _preload.subCategMiddle;
    endNativeAdsController = _preload.subCategEnd;

    _preload.refreshSubCategAds();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      subCategController.fetchSubCateg(
        categoryController.categId,
        categoryController.categName.toString(),
      );
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && !middleNativeAdsController.isNativeLoaded.value) {
        setState(() => _showMiddleShimmer = false);
      }
    });
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && !endNativeAdsController.isNativeLoaded.value) {
        setState(() => _showEndShimmer = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: CustomAppBar(
        titleWidget: Obx(
          () => Text(
            categoryController.categName.value,
            style: const TextStyle(
              fontSize: 18,
              color: AppColor.white,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ),
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Obx(() {
            final subCateg = subCategController.subCategList;

            if (subCategController.isLoading.value) {
              return AppShimmer.subCategoryList();
            }

            if (subCateg.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppDeco.circleBorder,
                      child: const Icon(
                        Icons.category_outlined,
                        size: 40,
                        color: AppColor.white,
                      ),
                    ),
                    VS(16),
                    Text('No subcategories available', style: AppText.caption),
                  ],
                ),
              );
            }
            final List<Widget> children = [];

            for (int i = 0; i < subCateg.length; i++) {
              children.add(
                SubCategoryCard(
                  subCategory: subCateg[i],
                  index: i,
                  questionController: questionController,
                ),
              );

              if (i == 1) {
                children.add(VS(16));
                children.add(
                  DarkNativeAdWidget(
                    key: const ValueKey('subcateg_middle_ad'),
                    controller: middleNativeAdsController,
                    showShimmer: _showMiddleShimmer,
                  ),
                );
                if (i < subCateg.length - 1) children.add(VS(16));
              } else if (i < subCateg.length - 1) {
                children.add(VS(16));
              }
            }

            if (subCateg.isNotEmpty) {
              children.add(VS(16));
              children.add(
                DarkNativeAdWidget(
                  key: const ValueKey('subcateg_end_ad'),
                  controller: endNativeAdsController,
                  showShimmer: _showEndShimmer,
                ),
              );
            }

            return ListView(children: children);
          }),
        ),
      ),
    );
  }
}
