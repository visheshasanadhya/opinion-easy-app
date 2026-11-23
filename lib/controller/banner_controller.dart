import 'package:opinion_easy/data/model/banner_model.dart';
import 'package:opinion_easy/data/service/banner_service.dart';
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
    try {
      isLoading.value = true;
      var response = await bannerService.fetchBanners();

      if (response.isNotEmpty) {
        banners.assignAll(response);
      } else {
        banners.clear();
        Get.snackbar('Oops', 'No banners found');
      }
    } catch (e) {
      Get.snackbar('Oops', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
