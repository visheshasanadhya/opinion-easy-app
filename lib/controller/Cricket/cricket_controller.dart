// FILE 2: cricket_controller.dart
// ========================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/data/model/cricket_match_model.dart';
import 'package:opinion_easy/data/service/cricket_service.dart';

class CricketController extends GetxController {
  final CricketService _cricketService = CricketService();

  // ================= UI STATE =================
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // ================= DATA =================
  final RxList<CricketMatchModel> allMatches = <CricketMatchModel>[].obs;

  // ================= FILTERED LISTS =================
  List<CricketMatchModel> get liveMatches =>
      allMatches.where((m) => m.isLive).toList();

  List<CricketMatchModel> get upcomingMatches =>
      allMatches.where((m) => m.isUpcoming).toList();

  List<CricketMatchModel> get resultMatches =>
      allMatches.where((m) => m.isResult).toList();

  @override
  void onInit() {
    super.onInit();
    fetchCricketData();

    // Debug timezone conversion
    ever(allMatches, (matches) {
      if (matches.isNotEmpty) {
        debugPrint('=== TIMEZONE DEBUG ===');
        final match = matches.first;
        debugPrint('GMT: ${match.dateTimeGMT}');
        debugPrint('IST DateTime: ${match.matchDateTimeIST}');
        debugPrint('IST Formatted: ${match.formattedISTTime}');
        debugPrint('IST Date: ${match.formattedISTDate}');
        debugPrint('=====================');
      }
    });
  }

  // ================= API CALL =================
  Future<void> fetchCricketData({bool isRefresh = false}) async {
    try {
      if (!isRefresh) {
        isLoading.value = true;
      }

      hasError.value = false;
      errorMessage.value = '';

      final response = await _cricketService.getAllMatches();

      if (response.status) {
        allMatches.assignAll(response.matches);

        /// 🔥 SORT USING IST TIME
        allMatches.sort((a, b) {
          // 1️⃣ Live matches first
          if (a.isLive && !b.isLive) return -1;
          if (!a.isLive && b.isLive) return 1;

          // 2️⃣ Sort by IST datetime
          final da = a.matchDateTimeIST;
          final db = b.matchDateTimeIST;

          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;

          return da.compareTo(db); // ASC
        });
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load data';
      allMatches.clear();
      debugPrint('Error fetching cricket data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= REFRESH =================
  Future<void> refreshCricketData() async {
    await fetchCricketData(isRefresh: true);
  }

  // ================= GROUP BY SERIES =================
  Map<String, List<CricketMatchModel>> groupMatchesBySeries(
    List<CricketMatchModel> matches,
  ) {
    final Map<String, List<CricketMatchModel>> grouped = {};
    for (final m in matches) {
      grouped.putIfAbsent(m.series, () => []).add(m);
    }
    return grouped;
  }

  @override
  void onClose() {
    allMatches.clear();
    super.onClose();
  }
}
