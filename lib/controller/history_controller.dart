import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/history_model.dart';
import 'package:opinion_easy/data/service/history_service.dart';
import 'package:opinion_easy/data/service/internet_monitor.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var isDataLoaded = false.obs;

  var history = <HistoryModel>[].obs;
  var redeemHistory = <RedeemModel>[].obs;

  final HistoryService historyService = HistoryService();

  @override
  void onInit() {
    super.onInit();
    if (!isDataLoaded.value) {
      // prevent duplicate fetch
      fetchHistory();
    }
  }

  Future<void> fetchHistory({bool isRefresh = false}) async {
    if (InternetMonitor.isOffline) {
      isLoading.value = false;
      return;
    }
    try {
      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
        history.clear();
        redeemHistory.clear();
      }

      isLoading.value = true;
      var result = await historyService.fetchHistory(page: 1);

      List<HistoryModel> answers = result["answers"] as List<HistoryModel>;
      List<RedeemModel> redeem = result["redeem_requests"] as List<RedeemModel>;

      history.assignAll(answers);
      redeemHistory.assignAll(redeem);

      hasMoreData.value = answers.length >= ApiEndpoints.limitPagination;
      currentPage.value = 1;
      isDataLoaded.value = true;
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) return;
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isMoreLoading.value || !hasMoreData.value) return;

    try {
      isMoreLoading.value = true;
      final nextPage = currentPage.value + 1;

      var result = await historyService.fetchHistory(page: nextPage);

      List<HistoryModel> answers = result["answers"] as List<HistoryModel>;
      List<RedeemModel> redeem = result["redeem_requests"] as List<RedeemModel>;

      if (answers.isEmpty) {
        hasMoreData.value = false;
      } else {
        currentPage.value = nextPage;
        history.addAll(answers);
        if (answers.length < ApiEndpoints.limitPagination) {
          hasMoreData.value = false;
        }
      }

      // Backend returns full unpaginated redeem_requests list.
      // Update with assignAll so the count remains correct and never duplicates on scroll.
      if (redeem.isNotEmpty) {
        redeemHistory.assignAll(redeem);
      }
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) return;
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Error', e.toString());
    } finally {
      isMoreLoading.value = false;
    }
  }
}
