import 'package:get/get.dart';
import 'package:opinion_easy/data/model/leaderboard_model.dart';
import 'package:opinion_easy/data/service/leaderboard_service.dart';

class LeaderboardController extends GetxController {
  // Loading flags
  var isLoading = false.obs;
  var isTodayLoading = false.obs;
  var isMonthlyLoading = false.obs;
  var isAllTimeLoading = false.obs;

  // Models for each period
  var todayModel = LeaderboardModel().obs;
  var monthlyModel = LeaderboardModel().obs;
  var allTimeModel = LeaderboardModel().obs;

  // Service
  final LeaderboardService leaderboardService = LeaderboardService();

  // Backward compatibility aliases
  Rx<LeaderboardModel> get topperModel => allTimeModel;
  Rx<LeaderboardModel> get todayLeaderModel => todayModel;
  Rx<LeaderboardModel> get yearlyModel => allTimeModel;
  RxBool get isYearlyLoading => isAllTimeLoading;
  LeaderboardService get topperService => leaderboardService;
  LeaderboardService get todayLeaderService => leaderboardService;

  /// Fetch today's leaderboard
  Future<void> fetchTodayList() async {
    try {
      isTodayLoading(true);
      final result = await leaderboardService.fetchTodayLeaders();
      todayModel.value = result;
    } catch (e) {
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Error', e.toString());
    } finally {
      isTodayLoading(false);
    }
  }

  /// Fetch monthly leaderboard
  Future<void> fetchMonthlyList() async {
    try {
      isMonthlyLoading(true);
      final result = await leaderboardService.fetchMonthlyLeaders();
      monthlyModel.value = result;
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

  /// Fetch all-time top performers
  Future<void> fetchAllTimeList() async {
    try {
      isAllTimeLoading(true);
      final result = await leaderboardService.fetchAllTimeLeaders();
      allTimeModel.value = result;
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

  // Backward compatibility alias: fetchYearlyList
  Future<void> fetchYearlyList() => fetchAllTimeList();

  // Backward compatibility alias: fetchTodayLeaderList
  Future<void> fetchTodayLeaderList(String whichLeader) => fetchTodayList();

  // Backward compatibility alias: fetchTopperList
  Future<void> fetchTopperList(String whichTopper) async {
    if (whichTopper == "today") {
      await fetchTodayList();
      return;
    }
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
      LeaderboardModel result = await leaderboardService.fetchTopperList(whichTopper);
      allTimeModel.value = result;
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
typedef TodayLeaderController = LeaderboardController;
typedef Leaderboard = LeaderboardController;
