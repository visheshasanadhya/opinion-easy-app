import 'package:opinion_easy/data/model/topper_model.dart';
import 'package:opinion_easy/data/service/topper_service.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  var isLoading = false.obs;
  var isMonthlyLoading = false.obs;
  var isAllTimeLoading = false.obs;

  var topperModel = TopperModel().obs;
  var monthlyModel = TopperModel().obs;
  var allTimeModel = TopperModel().obs;

  // Backward compatibility getters
  RxBool get isYearlyLoading => isAllTimeLoading;
  Rx<TopperModel> get yearlyModel => allTimeModel;

  final TopperService topperService = TopperService();

  Future<void> fetchMonthlyList() async {
    try {
      isMonthlyLoading(true);
      final result = await topperService.fetchTopperList("month");
      monthlyModel.value = result;
      topperModel.value = result;
    } catch (e) {
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Error', e.toString());
    } finally {
      isMonthlyLoading(false);
    }
  }

  Future<void> fetchAllTimeList() async {
    try {
      isAllTimeLoading(true);
      final result = await topperService.fetchTopperList("all");
      allTimeModel.value = result;
      topperModel.value = result;
    } catch (e) {
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Error', e.toString());
    } finally {
      isAllTimeLoading(false);
    }
  }

  // Backward compatibility alias
  Future<void> fetchYearlyList() => fetchAllTimeList();

  Future<void> fetchTopperList(String whichTopper) async {
    if (whichTopper == "month") {
      await fetchMonthlyList();
      return;
    }
    if (whichTopper == "year" || whichTopper == "all" || whichTopper.isEmpty) {
      await fetchAllTimeList();
      return;
    }
    try {
      isLoading(true);
      TopperModel result = await topperService.fetchTopperList(whichTopper);
      topperModel.value = result;
    } catch (e) {
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}

/// Backward compatibility aliases
typedef TopperController = LeaderboardController;
typedef Leaderboard = LeaderboardController;
