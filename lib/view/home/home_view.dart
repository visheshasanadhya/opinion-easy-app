import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:opinion_easy/controller/banner_controller.dart';
import 'package:opinion_easy/controller/category_controller.dart';
import 'package:opinion_easy/controller/nav_controller.dart';
import 'package:opinion_easy/controller/notification_controller.dart';
import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/controller/sub_categ_controller.dart';
import 'package:opinion_easy/core/admob/admob.dart';
import 'package:opinion_easy/core/admob/ad_preload_service.dart';
import 'package:opinion_easy/core/admob/dark_ad_widget.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:opinion_easy/data/model/banner_model.dart';
import 'package:opinion_easy/data/service/fcm_service.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/app_shimmer.dart';
import 'package:opinion_easy/core/utils/widgets/app_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/view/home/widgets/live_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final CategoryController categoryController;
  late final BottomNavController bottomNavController;
  late final SubCategController subCategController;
  late final BannerController bannerController;
  late final ProfileController profileController;
  late final NotificationController notificationController;
  late final AdPreloadService _preload;
  late final AdsController adsController;

  final RxInt _currentBanner = 0.obs;
  bool _isAdLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    categoryController = Get.put(CategoryController());
    bottomNavController = Get.find<BottomNavController>();
    subCategController = Get.put(SubCategController());
    bannerController = Get.put(BannerController());
    profileController = Get.put(ProfileController());
    notificationController = Get.put(NotificationController());
    //_preload = Get.find<AdPreloadService>();
    // adsController = Get.put(AdsController(), tag: 'home_ad');
    if (!kIsWeb) {
      _preload = Get.find<AdPreloadService>();
      adsController = Get.put(AdsController(), tag: 'home_ad');
    }
    _initializeFCM();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAdLoadedOnce) {
      _isAdLoadedOnce = true;
      if (!kIsWeb) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          adsController?.loadAdaptiveBanner(context);
        });
      }
    }
  }

  void _initializeFCM() async {
    try {
      await FCMService.initialize();
    } catch (e) {
      debugPrint('$e');
    }
  }

  void _handleBannerTap(BannerModel banner) {
    final link = banner.link;
    if (link == null || link.isEmpty || link == 'null') return;
    if (link.startsWith('/')) {
      Get.toNamed(link);
    } else {
      launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColor.card,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              child: _buildHeader(),
            ),
            Expanded(
              child: AppRefresh(
                onRefresh: () async {
                  await Future.wait([
                    categoryController.fetchCategories(),
                    bannerController.fetchBanners(),
                    profileController.fetchProfile(),
                    notificationController.fetchUnreadCount(),
                  ]);
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildBanners(sw),
                          _buildCategories(),
                          VS(24),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // DarkBannerAdWidget(
            //   isLoaded: adsController.isLoaded,
            //   bannerAd: adsController.bannerAd,
            // ),
            if (!kIsWeb)
              DarkBannerAdWidget(
                isLoaded: adsController.isLoaded,
                bannerAd: adsController.bannerAd,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Obx(() {
          final profile = profileController.profile.value;
          final hasImage =
              profile?.profilePic != null && profile!.profilePic!.isNotEmpty;
          return Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.borderLight, width: 1.5),
            ),
            child: ClipOval(
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: profile!.profilePic!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColor.cardAlt),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.person, color: AppColor.textGrey),
                    )
                  : Container(
                      color: AppColor.cardAlt,
                      child: const Icon(Icons.person, color: AppColor.textGrey),
                    ),
            ),
          );
        }),
        HS(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                final name = profileController.profile.value?.name;
                return Text(
                  name != null && name.isNotEmpty
                      ? 'Hi, $name 👋'
                      : 'Welcome back 👋',
                  style: AppText.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }),
              VS(2),
              Text("Today's topics", style: AppText.captionSm),
            ],
          ),
        ),
        HS(10),
        _buildPointsBadge(),
        HS(10),
        _buildNotificationButton(),
      ],
    );
  }

  Widget _buildPointsBadge() {
    return GestureDetector(
      onTap: () => bottomNavController.changeIndex(1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.cardAlt,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/coinc.png', height: 20, width: 20),
            HS(6),
            Obx(
              () => Text(
                '${profileController.profile.value?.points ?? 0}',
                style: AppText.labelSm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Obx(() {
      final unread = notificationController.unreadCount.value;
      return GestureDetector(
        onTap: () => Get.toNamed('/notification'),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColor.cardAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.borderLight),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: AppColor.white,
                size: 22,
              ),
              if (unread > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: AppColor.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.cardAlt, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBanners(double sw) {
    return Obx(() {
      if (bannerController.isLoading.value) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: AppShimmer.banner(height: sw * 0.46),
        );
      }

      if (bannerController.banners.isEmpty) {
        return const SizedBox.shrink();
      }

      final banners = bannerController.banners;

      Widget content;
      if (banners.length == 1) {
        final banner = banners.first;
        final hasLink = banner.link != null &&
            banner.link!.isNotEmpty &&
            banner.link != 'null';
        content = GestureDetector(
          onTap: hasLink ? () => _handleBannerTap(banner) : null,
          child: Container(
            height: sw * 0.46,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.borderFaint),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: banner.image ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) =>
                    AppShimmer.box(height: sw * 0.46, radius: 0),
                errorWidget: (_, __, ___) => Container(
                  color: AppColor.cardAlt,
                  child: const Icon(
                    Icons.broken_image_rounded,
                    color: AppColor.textDisabled,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        content = Column(
          children: [
            CarouselSlider.builder(
              itemCount: banners.length,
              itemBuilder: (context, index, _) {
                final banner = banners[index];
                final hasLink = banner.link != null &&
                    banner.link!.isNotEmpty &&
                    banner.link != 'null';
                return GestureDetector(
                  onTap: hasLink ? () => _handleBannerTap(banner) : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.borderFaint),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: banner.image ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (_, __) =>
                            AppShimmer.box(height: sw * 0.46, radius: 0),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColor.cardAlt,
                          child: const Icon(
                            Icons.broken_image_rounded,
                            color: AppColor.textDisabled,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: sw * 0.46,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.92,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 700),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, _) => _currentBanner.value = index,
              ),
            ),
            VS(14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (index) => Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentBanner.value == index ? 24 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentBanner.value == index
                          ? AppColor.white
                          : AppColor.cardLight,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: content,
      );
    });
  }

  Widget _buildCategories() {
    return Obx(() {
      if (categoryController.isLoading.value) return AppShimmer.categoryList();
      final categories = categoryController.categories;
      if (categories.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 48,
                  color: AppColor.textDisabled,
                ),
                VS(14),
                Text('No categories available', style: AppText.caption),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            final String title = category.name?.trim() ?? 'Unknown';
            final bool hasNew = (category.leftQuestionCount ?? 0) > 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: AppDeco.card,
              child: InkWell(
                onTap: () {
                  categoryController.setCategoryInfo(
                    category.name.toString(),
                    category.id ?? 0,
                  );
                  subCategController.fetchSubCateg(
                    category.id ?? 0,
                    category.name.toString(),
                  );
                  // In _buildCategories() onTap
                  if (!kIsWeb) _preload?.refreshSubCategAds();

                  // _preload.refreshSubCategAds();
                },
                borderRadius: BorderRadius.circular(AppDeco.radius),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColor.cardAlt,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.borderLight),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: category.image ?? '',
                            width: 48,
                            height: 48,
                            fit: BoxFit.contain,
                            placeholder: (_, __) => const SizedBox(),
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.category,
                              color: AppColor.textGrey,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      HS(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: AppText.bodyMd,
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
                            if (category.description != null &&
                                category.description!.isNotEmpty) ...[
                              VS(3),
                              Text(
                                category.description!,
                                style: AppText.captionSm,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      HS(10),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.textGrey,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
