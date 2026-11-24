import 'package:opinion_easy/data/model/faq_model.dart';
import 'package:opinion_easy/data/service/faq_service.dart';
import 'package:opinion_easy/data/service/internet_monitor.dart';
import 'package:get/get.dart';

class FaqController extends GetxController {
  var isLoading = false.obs;
  final FaqService faqService = FaqService();
  var faqs = <FAQsModel>[].obs;

  @override
  void onInit() {
    fetchFaqs();
    super.onInit();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;

      var response = await faqService.fetchFaqs();
      faqs.assignAll(response);
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
