import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/data/model/stock_model.dart';

import '../../data/service/stock_service.dart';

class StockController extends GetxController {
  final StockService _stockService = StockService();

  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var stocks = <StockModel>[].obs;
  var errorMessage = ''.obs;
  var hasError = false.obs;

  // Filtered lists based on trends
  var bullishStocks = <StockModel>[].obs;
  var bearishStocks = <StockModel>[].obs;
  var neutralStocks = <StockModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    if (isLoading.value || isRefreshing.value) return;

    try {
      if (!isRefreshing.value) {
        isLoading.value = true;
      }

      hasError.value = false;
      errorMessage.value = '';

      await _fetchStocksFromApi();
      _categorizeStocks();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Failed to load data. Please check your connection.";
      stocks.clear();
      _clearCategorizedStocks();

      Get.snackbar(
        "Error",
        "Failed to fetch stock market data: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> _fetchStocksFromApi() async {
    try {
      final stockData = await _stockService.fetchStockMarketData();
      stocks.value = stockData;
    } catch (e) {
      print('API Stock data error: $e');
      rethrow;
    }
  }

  void _categorizeStocks() {
    bullishStocks.clear();
    bearishStocks.clear();
    neutralStocks.clear();

    for (var stock in stocks) {
      if (stock.overallRating.toLowerCase().contains('bullish')) {
        bullishStocks.add(stock);
      } else if (stock.overallRating.toLowerCase().contains('bearish')) {
        bearishStocks.add(stock);
      } else {
        neutralStocks.add(stock);
      }
    }

    // Sort by percent change
    bullishStocks.sort((a, b) => b.percentChange.compareTo(a.percentChange));
    bearishStocks.sort((a, b) => a.percentChange.compareTo(b.percentChange));
  }

  void _clearCategorizedStocks() {
    bullishStocks.clear();
    bearishStocks.clear();
    neutralStocks.clear();
  }

  Future<void> refreshStockData() async {
    try {
      isRefreshing.value = true;
      await fetchStockData();
    } finally {
      isRefreshing.value = false;
    }
  }

  List<StockModel> searchStocks(String query) {
    if (query.isEmpty) return stocks;

    final lowerQuery = query.toLowerCase();
    return stocks.where((stock) {
      return stock.company.toLowerCase().contains(lowerQuery) ||
          stock.ticker.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  StockModel? getStockByTicker(String ticker) {
    try {
      return stocks.firstWhere(
        (stock) => stock.ticker.toLowerCase() == ticker.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  void clearData() {
    stocks.clear();
    _clearCategorizedStocks();
    hasError.value = false;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}
