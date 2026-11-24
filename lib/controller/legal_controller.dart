import 'package:get/get.dart';
import 'package:opinion_easy/data/service/legal_service.dart';

class LegalController extends GetxController {
  final LegalService _service = LegalService();

  // Terms & Conditions
  var isTermsLoading = false.obs;
  var termsContent = ''.obs;
  var termsTitle = 'Terms & Conditions'.obs;
  var termsUpdatedAt = ''.obs;

  // Privacy Policy
  var isPrivacyLoading = false.obs;
  var privacyContent = ''.obs;
  var privacyTitle = 'Privacy Policy'.obs;
  var privacyUpdatedAt = ''.obs;

  // About Us
  var isAboutLoading = false.obs;
  var aboutTitle = 'About Opinion Easy'.obs;
  var aboutSubtitle = 'Your voice. Your rewards.'.obs;
  var aboutContent = ''.obs;
  var aboutUpdatedAt = ''.obs;
  var aboutStats = <Map<String, dynamic>>[].obs;

  // Help & Support
  var isHelpLoading = false.obs;
  var helpTitle = 'Contact Our Support Team'.obs;
  var helpDescription =
      "Welcome to the Help & Support Center for Opinion Easy. We're here to assist you with any questions, issues, or feedback."
          .obs;
  var helpSubDescription =
      "Reach out using the options below and we'll respond promptly.".obs;
  var helpEmail = 'opinioneasy2026@gmail.com'.obs;
  var helpPhone = '+91 870 868 0041'.obs;
  var helpWhatsapp = '+91 870 868 0041'.obs;
  var helpAvailability = '9:00 AM - 6:00 PM IST\nMonday - Sunday'.obs;
  var helpAddress =
      'WeWork DLF Two Horizon Centre, DLF Phase 5, Sector 43, Golf Course Road, Gurugram, Haryana - 122002'
          .obs;
  var helpWebsite = 'https://opinioneasy.com'.obs;
  var helpFooterNote =
      'We value your feedback — helping us improve your experience every day.'
          .obs;
  var helpUpdatedAt = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
    fetchPrivacy();
    fetchAboutUs();
    fetchHelpSupport();
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

  Future<void> fetchAboutUs() async {
    try {
      isAboutLoading.value = true;
      final data = await _service.fetchAboutUs();
      aboutTitle.value = data['title'] ?? 'About Opinion Easy';
      aboutSubtitle.value = data['subtitle'] ?? 'Your voice. Your rewards.';
      aboutContent.value = data['content'] ?? '';
      aboutUpdatedAt.value = data['updated_at'] ?? '';
      if (data['stats'] is List) {
        aboutStats.value = List<Map<String, dynamic>>.from(
          (data['stats'] as List).map((e) => Map<String, dynamic>.from(e)),
        );
      }
    } catch (_) {
      // keep offline/fallback content
    } finally {
      isAboutLoading.value = false;
    }
  }

  Future<void> fetchHelpSupport() async {
    try {
      isHelpLoading.value = true;
      final data = await _service.fetchHelpSupport();
      helpTitle.value = data['title'] ?? 'Contact Our Support Team';
      helpDescription.value = data['description'] ??
          "Welcome to the Help & Support Center for Opinion Easy. We're here to assist you with any questions, issues, or feedback.";
      helpSubDescription.value = data['sub_description'] ??
          "Reach out using the options below and we'll respond promptly.";
      helpEmail.value = data['email'] ?? 'opinioneasy2026@gmail.com';
      helpPhone.value = data['phone'] ?? '+91 870 868 0041';
      helpWhatsapp.value = data['whatsapp'] ?? '+91 870 868 0041';
      helpAvailability.value =
          data['availability'] ?? '9:00 AM - 6:00 PM IST\nMonday - Sunday';
      helpAddress.value = data['address'] ?? '';
      helpWebsite.value = data['website'] ?? 'https://opinioneasy.com';
      helpFooterNote.value = data['footer_note'] ??
          'We value your feedback — helping us improve your experience every day.';
      helpUpdatedAt.value = data['updated_at'] ?? '';
    } catch (_) {
      // keep offline/fallback content
    } finally {
      isHelpLoading.value = false;
    }
  }
}
