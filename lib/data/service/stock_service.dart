import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/stock_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StockService {
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found. Please login again.');
    }
    return token;
  }

  Future<List<StockModel>> fetchStockMarketData() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(ApiEndpoints.stocks),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Stock Market Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['status'] == true && jsonData['data'] != null) {
          final List<dynamic> stocksJson = jsonData['data'] is List
              ? jsonData['data']
              : [jsonData['data']];

          return stocksJson
              .map((json) => StockModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
            jsonData['message'] ?? 'Failed to load stock market data',
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Stock market data endpoint not found.');
      } else {
        throw Exception(
          'Failed to load stock market data: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching stock market data: $e');
      throw Exception('Error fetching stock market data: $e');
    }
  }

  Future<T> _retryRequest<T>(
    Future<T> Function() request, {
    int maxRetries = 2,
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await request();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        await Future.delayed(Duration(seconds: attempts));
      }
    }
    throw Exception('Max retries exceeded');
  }

  Future<List<StockModel>> fetchStockMarketDataWithRetry() async {
    return _retryRequest(() => fetchStockMarketData());
  }

  Future<StockModel?> fetchStockByTicker(String ticker) async {
    try {
      final stocks = await fetchStockMarketData();
      return stocks.firstWhere(
        (stock) => stock.ticker.toLowerCase() == ticker.toLowerCase(),
        orElse: () => throw Exception('Stock with ticker $ticker not found'),
      );
    } catch (e) {
      print('Error fetching stock by ticker: $e');
      return null;
    }
  }
}
