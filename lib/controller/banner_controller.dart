import 'package:opinion_easy/data/model/banner_model.dart';
import 'package:opinion_easy/data/service/banner_service.dart';
import 'package:opinion_easy/data/service/internet_monitor.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  var isLoading = false.obs;
  var banners = <BannerModel>[].obs;

  final BannerService bannerService = BannerService();

  @override
  onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    if (InternetMonitor.isOffline) {
      isLoading.value = false;
      return;
    }
    try {
      isLoading.value = true;
      var response = await bannerService.fetchBanners();

      if (response.isNotEmpty) {
        banners.assignAll(response);
      } else {
        banners.clear();
      }
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) return;
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Oops', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
