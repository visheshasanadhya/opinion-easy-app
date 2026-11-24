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
      var result = await historyService.fetchHistory(page: currentPage.value);

      List<HistoryModel> answers = result["answers"] as List<HistoryModel>;
      List<RedeemModel> redeem = result["redeem_requests"] as List<RedeemModel>;

      if (answers.isEmpty && redeem.isEmpty) {
        hasMoreData.value = false;
      } else {
        if (isRefresh) {
          history.value = answers;
          redeemHistory.value = redeem;
        } else {
          history.assignAll(answers);
          redeemHistory.assignAll(redeem);
        }
      }
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
      currentPage.value += 1;

      var result = await historyService.fetchHistory(page: currentPage.value);

      List<HistoryModel> answers = result["answers"] as List<HistoryModel>;
      List<RedeemModel> redeem = result["redeem_requests"] as List<RedeemModel>;

      if (answers.isEmpty && redeem.isEmpty) {
        hasMoreData.value = false;
      } else {
        history.addAll(answers);
        redeemHistory.addAll(redeem);
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
