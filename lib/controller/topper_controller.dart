import 'package:opinion_easy/data/model/topper_model.dart';
import 'package:opinion_easy/data/service/topper_service.dart';
import 'package:get/get.dart';

class TopperController extends GetxController {
  var isLoading = false.obs;

  var topperModel = TopperModel().obs;
  final TopperService topperService = TopperService();

  Future<void> fetchTopperList(String whichTopper) async {
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
