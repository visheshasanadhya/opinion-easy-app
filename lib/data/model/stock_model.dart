import 'package:flutter/material.dart';

class StockModel {
  final String ticker;
  final String company;
  final double price;
  final double percentChange;
  final double netChange;
  final double bid;
  final double ask;
  final double high;
  final double low;
  final double open;
  final double lowCircuitLimit;
  final double upCircuitLimit;
  final int volume;
  final double close;
  final String overallRating;
  final String shortTermTrend;
  final String longTermTrend;
  final double weekLow52;
  final double weekHigh52;

  StockModel({
    required this.ticker,
    required this.company,
    required this.price,
    required this.percentChange,
    required this.netChange,
    required this.bid,
    required this.ask,
    required this.high,
    required this.low,
    required this.open,
    required this.lowCircuitLimit,
    required this.upCircuitLimit,
    required this.volume,
    required this.close,
    required this.overallRating,
    required this.shortTermTrend,
    required this.longTermTrend,
    required this.weekLow52,
    required this.weekHigh52,
  });

  bool get isPositive => percentChange >= 0;

  Color get trendColor {
    if (overallRating.toLowerCase().contains('bullish')) {
      return Colors.green.shade600;
    } else if (overallRating.toLowerCase().contains('bearish')) {
      return Colors.red.shade600;
    } else {
      return Colors.grey.shade600;
    }
  }

  IconData get trendIcon {
    if (overallRating.toLowerCase().contains('bullish')) {
      return Icons.trending_up;
    } else if (overallRating.toLowerCase().contains('bearish')) {
      return Icons.trending_down;
    } else {
      return Icons.trending_flat;
    }
  }

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      ticker: json['ticker'] ?? '',
      company: json['company'] ?? '',
      price: _parseDouble(json['price']),
      percentChange: _parseDouble(json['percent_change']),
      netChange: _parseDouble(json['net_change']),
      bid: _parseDouble(json['bid']),
      ask: _parseDouble(json['ask']),
      high: _parseDouble(json['high']),
      low: _parseDouble(json['low']),
      open: _parseDouble(json['open']),
      lowCircuitLimit: _parseDouble(json['low_circuit_limit']),
      upCircuitLimit: _parseDouble(json['up_circuit_limit']),
      volume: _parseInt(json['volume']),
      close: _parseDouble(json['close']),
      overallRating: json['overall_rating'] ?? 'Neutral',
      shortTermTrend: json['short_term_trend'] ?? 'Neutral',
      longTermTrend: json['long_term_trend'] ?? 'Neutral',
      weekLow52: _parseDouble(json['52_week_low']),
      weekHigh52: _parseDouble(json['52_week_high']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'company': company,
      'price': price,
      'percent_change': percentChange,
      'net_change': netChange,
      'bid': bid,
      'ask': ask,
      'high': high,
      'low': low,
      'open': open,
      'low_circuit_limit': lowCircuitLimit,
      'up_circuit_limit': upCircuitLimit,
      'volume': volume,
      'close': close,
      'overall_rating': overallRating,
      'short_term_trend': shortTermTrend,
      'long_term_trend': longTermTrend,
      '52_week_low': weekLow52,
      '52_week_high': weekHigh52,
    };
  }

  @override
  String toString() {
    return 'StockModel(ticker: $ticker, company: $company, price: $price, percentChange: $percentChange)';
  }
}
