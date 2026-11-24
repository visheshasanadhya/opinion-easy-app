import 'package:opinion_easy/data/model/today_leader_model.dart';
import 'package:opinion_easy/data/service/today_leader_service.dart';
import 'package:get/get.dart';

class TodayLeaderController extends GetxController {
  var isLoading = false.obs;
  var todayLeaderModel = TodayLeaderModel().obs;
  final TodayLeaderService todayLeaderService = TodayLeaderService();

  Future<void> fetchTodayLeaderList(String whichLeader) async {
    try {
      isLoading(true);
      TodayLeaderModel result = await todayLeaderService.fetchTodayLeaderList(
        whichLeader,
      );
      todayLeaderModel.value = result;
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
