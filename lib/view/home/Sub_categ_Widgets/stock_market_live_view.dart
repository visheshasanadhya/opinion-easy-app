import 'package:opinion_easy/controller/Stocks/stock_controller.dart';
import 'package:opinion_easy/core/admob/admob.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:opinion_easy/data/model/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class StockMarketLiveView extends StatefulWidget {
  const StockMarketLiveView({super.key});

  @override
  State<StockMarketLiveView> createState() => _StockMarketLiveViewState();
}

class _StockMarketLiveViewState extends State<StockMarketLiveView>
    with SingleTickerProviderStateMixin {
  final StockController _stockController = Get.put(StockController());
  final AdsController _adsController =
      Get.put(AdsController(), tag: "stock_ad");

  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _blinkAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(_blinkController);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_isAdLoadedOnce) {
  //     _isAdLoadedOnce = true;
  //     _adsController.loadAdaptiveBanner(
  //       context,
  //       "ca-app-pub-4639427395020302/9834697729",
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColor.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            "Live Stock Market",
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColor.black),
              onPressed: _stockController.refreshStockData,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _stockController.refreshStockData,
          child: SafeArea(
            child: Obx(() {
              final controller = _stockController;
              if (controller.hasError.value && !controller.isLoading.value) {
                return _buildErrorState(
                  controller.errorMessage.value,
                  controller.fetchStockData,
                );
              }
              if (controller.isLoading.value) {
                return _buildShimmerLoader();
              }
              return _buildContentList();
            }),
          ),
        ),
        bottomNavigationBar: _buildBottomAdBanner(),
      ),
    );
  }

  Widget _buildContentList() {
    final stocks = _stockController.stocks;
    final hasContent = stocks.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListView(
        children: [
          _buildSectionTitle(
            "Live Market Data",
            Icons.show_chart,
            Colors.blue.shade700,
            isBlinking: true,
          ),
          VS(12),
          if (hasContent) ...[
            ...stocks.map(
              (stock) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildStockCard(stock),
              ),
            ),
          ],
          if (!hasContent) ...[VS(40), _buildEmptyState(), VS(40)],
          VS(20),
        ],
      ),
    );
  }

  Widget _buildBlinkingIcon(IconData icon, Color color) {
    return FadeTransition(
      opacity: _blinkAnimation,
      child: Icon(icon, size: 20, color: color),
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon,
    Color iconColor, {
    bool isBlinking = false,
  }) {
    final Widget iconWidget = isBlinking
        ? _buildBlinkingIcon(icon, iconColor)
        : Icon(icon, size: 20, color: iconColor);

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCard(StockModel stock) {
    final changeColor =
        stock.isPositive ? Colors.green.shade600 : Colors.red.shade600;
    final changeIcon =
        stock.isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.company,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stock.ticker,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: stock.trendColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(stock.trendIcon, size: 14, color: stock.trendColor),
                      const SizedBox(width: 4),
                      Text(
                        stock.overallRating,
                        style: TextStyle(
                          color: stock.trendColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${stock.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: changeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(changeIcon, size: 14, color: changeColor),
                            const SizedBox(width: 4),
                            Text(
                              '${stock.netChange >= 0 ? '+' : ''}${stock.netChange.toStringAsFixed(2)} (${stock.percentChange.toStringAsFixed(2)}%)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: changeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildInfoColumn(
                        'Open', '₹${stock.open.toStringAsFixed(2)}')),
                Expanded(
                    child: _buildInfoColumn(
                        'High', '₹${stock.high.toStringAsFixed(2)}')),
                Expanded(
                    child: _buildInfoColumn(
                        'Low', '₹${stock.low.toStringAsFixed(2)}')),
                Expanded(
                    child: _buildInfoColumn(
                        'Close', '₹${stock.close.toStringAsFixed(2)}')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildInfoColumn(
                        'Volume', _formatVolume(stock.volume))),
                Expanded(
                    child: _buildInfoColumn(
                        '52W Low', '₹${stock.weekLow52.toStringAsFixed(2)}')),
                Expanded(
                    child: _buildInfoColumn(
                        '52W High', '₹${stock.weekHigh52.toStringAsFixed(2)}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  String _formatVolume(int volume) {
    if (volume >= 10000000)
      return '${(volume / 10000000).toStringAsFixed(2)}Cr';
    if (volume >= 100000) return '${(volume / 100000).toStringAsFixed(2)}L';
    if (volume >= 1000) return '${(volume / 1000).toStringAsFixed(2)}K';
    return volume.toString();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 100, color: Colors.grey.shade200),
          const SizedBox(height: 20),
          Text(
            "No stock data available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Pull down to refresh or check back later",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded,
                size: 80, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              "Oops! Something went wrong",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.white,
                foregroundColor: AppColor.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: ListView(
          children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAdBanner() {
    return Obx(() {
      if (!_adsController.isLoaded.value || _adsController.bannerAd == null) {
        return const SizedBox.shrink();
      }
      final AdSize adSize = _adsController.bannerAd!.size;
      return SafeArea(
        child: SizedBox(
          width: adSize.width.toDouble(),
          height: adSize.height.toDouble(),
          child: AdWidget(ad: _adsController.bannerAd!),
        ),
      );
    });
  }
}
