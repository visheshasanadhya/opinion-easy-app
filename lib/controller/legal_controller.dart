import 'package:get/get.dart';
import 'package:opinion_easy/data/service/legal_service.dart';

class LegalController extends GetxController {
  final LegalService _service = LegalService();

  var isTermsLoading = false.obs;
  var isPrivacyLoading = false.obs;

  var termsContent = ''.obs;
  var termsTitle = 'Terms & Conditions'.obs;
  var termsUpdatedAt = ''.obs;

  var privacyContent = ''.obs;
  var privacyTitle = 'Privacy Policy'.obs;
  var privacyUpdatedAt = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
    fetchPrivacy();
  }

  Future<void> fetchTerms() async {
    try {
      isTermsLoading.value = true;
      final data = await _service.fetchTerms();
      termsTitle.value = data['title'] ?? 'Terms & Conditions';
      termsContent.value = data['content'] ?? '';
      termsUpdatedAt.value = data['updated_at'] ?? '';
    } catch (_) {
      // keep offline/fallback content
    } finally {
      isTermsLoading.value = false;
    }
  }

  Future<void> fetchPrivacy() async {
    try {
      isPrivacyLoading.value = true;
      final data = await _service.fetchPrivacy();
      privacyTitle.value = data['title'] ?? 'Privacy Policy';
      privacyContent.value = data['content'] ?? '';
      privacyUpdatedAt.value = data['updated_at'] ?? '';
    } catch (_) {
      // keep offline/fallback content
    } finally {
      isPrivacyLoading.value = false;
    }
  }
}
