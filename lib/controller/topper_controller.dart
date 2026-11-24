import 'package:opinion_easy/data/model/topper_model.dart';
import 'package:opinion_easy/data/service/topper_service.dart';
import 'package:get/get.dart';

class TopperController extends GetxController {
  var isLoading = false.obs;
  var isMonthlyLoading = false.obs;
  var isYearlyLoading = false.obs;

  var topperModel = TopperModel().obs;
  var monthlyModel = TopperModel().obs;
  var yearlyModel = TopperModel().obs;

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

  Future<void> fetchYearlyList() async {
    try {
      isYearlyLoading(true);
      final result = await topperService.fetchTopperList("year");
      yearlyModel.value = result;
      topperModel.value = result;
    } catch (e) {
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Error', e.toString());
    } finally {
      isYearlyLoading(false);
    }
  }

  Future<void> fetchTopperList(String whichTopper) async {
    if (whichTopper == "month") {
      await fetchMonthlyList();
      return;
    }
    if (whichTopper == "year") {
      await fetchYearlyList();
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
