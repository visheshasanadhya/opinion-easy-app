import 'dart:io';
import 'package:opinion_easy/core/utils/widgets/invalid_pincode_bottom_sheet.dart';
import 'package:opinion_easy/data/model/profile_model.dart';
import 'package:opinion_easy/data/service/postal_pincode_api.dart';
import 'package:opinion_easy/data/service/profile_service.dart';
import 'package:opinion_easy/data/service/internet_monitor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/app_constants.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  final profileKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString selectedState = "Uttar Pradesh".obs;
  var selectedDob = ''.obs;

  var profile = Rxn<Data>();

  final ProfileService profileService = ProfileService();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController referralController = TextEditingController();

  TextEditingController _ensureFresh(TextEditingController ctrl) {
    try {
      void dummy() {}
      ctrl.addListener(dummy);
      ctrl.removeListener(dummy);
      return ctrl;
    } catch (_) {
      return TextEditingController();
    }
  }

  void ensureControllersActive() {
    nameController = _ensureFresh(nameController);
    emailController = _ensureFresh(emailController);
    phoneController = _ensureFresh(phoneController);
    addressController = _ensureFresh(addressController);
    districtController = _ensureFresh(districtController);
    cityController = _ensureFresh(cityController);
    stateController = _ensureFresh(stateController);
    pincodeController = _ensureFresh(pincodeController);
    referralController = _ensureFresh(referralController);
    phoneController.removeListener(_onPhoneChanged);
    phoneController.addListener(_onPhoneChanged);
  }

  final RxnString phoneError = RxnString(null);

  final RxBool isVerifyingPincode = false.obs;
  final RxBool isPincodeValid = false.obs;
  String _lastCheckedPincode = "";

  void _onPhoneChanged() {
    if (phoneError.value != null) {
      phoneError.value = null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    ensureControllersActive();
    _loadInitialPrefs();
    pincodeController.removeListener(_onPincodeChanged);
    pincodeController.addListener(_onPincodeChanged);
    phoneController.removeListener(_onPhoneChanged);
    phoneController.addListener(_onPhoneChanged);
    fetchProfile();
  }

  Future<void> _loadInitialPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (emailController.text.isEmpty) {
      emailController.text = prefs.getString('user_email') ?? '';
    }
    if (nameController.text.isEmpty) {
      nameController.text = prefs.getString('user_name') ?? '';
    }
    if (phoneController.text.isEmpty) {
      phoneController.text = prefs.getString('user_phone') ?? '';
    }
  }

  void _onPincodeChanged() {
    final pin = pincodeController.text.trim();
    if (pin.length < 6) {
      if (isPincodeValid.value ||
          stateController.text.isNotEmpty ||
          cityController.text.isNotEmpty) {
        isPincodeValid.value = false;
        stateController.clear();
        cityController.clear();
        _lastCheckedPincode = "";
      }
    } else if (pin.length == 6 && pin != _lastCheckedPincode) {
      verifyPincode(pin);
    }
  }

  Future<void> verifyPincode(String pin) async {
    isVerifyingPincode.value = true;
    _lastCheckedPincode = pin;

    final result = await PostalPincodeApi.verifyPincode(pin);
    isVerifyingPincode.value = false;

    if (result.isSuccess && (result.state ?? "").isNotEmpty) {
      stateController.text = result.state!;
      cityController.text = result.city ?? "";
      selectedState.value = result.state!;
      isPincodeValid.value = true;
    } else {
      isPincodeValid.value = false;
      stateController.clear();
      cityController.clear();

      InvalidPincodeBottomSheet.show(
        onDismissed: () {
          pincodeController.clear();
          _lastCheckedPincode = "";
        },
      );
    }
  }

  // Function to populate controllers with fetched data
  void setProfileData(Data? data) async {
    ensureControllersActive();
    final prefs = await SharedPreferences.getInstance();
    nameController.text = (data?.name?.isNotEmpty == true)
        ? data!.name!
        : (prefs.getString('user_name') ?? '');
    emailController.text = (data?.email?.isNotEmpty == true)
        ? data!.email!
        : (prefs.getString('user_email') ?? '');
    phoneController.text = (data?.phone?.isNotEmpty == true)
        ? data!.phone!
        : (prefs.getString('user_phone') ?? '');
    selectedState.value = (data?.address?.state?.isNotEmpty == true)
        ? data!.address!.state!
        : 'Uttar Pradesh';
    stateController.text = data?.address?.state ?? '';
    selectedDob.value = data?.dob ?? '';
    cityController.text = data?.address?.city ?? '';
    addressController.text = data?.address?.address ?? '';
    districtController.text = data?.address?.district ?? '';
    pincodeController.text = data?.address?.pincode ?? '';

    if (pincodeController.text.trim().length == 6) {
      isPincodeValid.value = true;
      _lastCheckedPincode = pincodeController.text.trim();
    }
  }

  List<String> states = <String>[
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
  ];

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void showImageSourceDialog() {
    Get.bottomSheet(
      SafeArea(
        child: Material(
          color: AppColor.scaffold,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a photo"),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Get.back();
                  },
                ),
                const Divider(color: AppColor.borderLight),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Choose from gallery"),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> updateProfile({bool navigateHomeOnSuccess = false}) async {
    try {
      phoneError.value = null;
      if (profileKey.currentState!.validate()) {
        isLoading.value = true;

        final stateValue = stateController.text.trim().isNotEmpty
            ? stateController.text.trim()
            : selectedState.value;

        var response = await profileService.updateProfile(
          nameController.text.trim(),
          emailController.text.trim(),
          phoneController.text.trim(),
          stateValue,
          cityController.text.trim(),
          addressController.text.trim(),
          pincodeController.text.trim(),
          districtController.text.trim(),
          selectedImage.value,
          selectedDob.value,
          referralCode: referralController.text.trim(),
        );

        if (response['status'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_profile_complete', true);
          await fetchProfile();
          Get.snackbar(
              'Success', response['message'] ?? 'Profile updated successfully');
          if (navigateHomeOnSuccess) {
            Get.offAllNamed('/bottom-nav');
          } else {
            Get.back();
          }
          return true;
        } else {
          final errors = response['errors'];
          if (errors != null && errors is Map && errors['phone'] != null) {
            final pErrs = errors['phone'];
            phoneError.value = (pErrs is List && pErrs.isNotEmpty)
                ? pErrs.first.toString()
                : pErrs.toString();
          } else if (response['message'] != null &&
              response['message'].toString().toLowerCase().contains('phone')) {
            phoneError.value = response['message'].toString();
          }

          final errorMsg = phoneError.value ??
              response['message'] ??
              response['details']?['reason'] ??
              'Failed to update profile';

          Get.snackbar(
            'Error',
            errorMsg.toString(),
            backgroundColor: AppColor.red.withValues(alpha: 0.85),
            colorText: AppColor.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return false;
      }
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProfile() async {
    if (InternetMonitor.isOffline) {
      isLoading.value = false;
      return;
    }
    try {
      var response = await profileService.fetchProfile();

      if (response.status == true) {
        profile.value = response.data;
        if (response.data != null) {
          setProfileData(response.data);
        }
        if (response.data?.status == 0) {
          Get.offAllNamed('/deactivated');
        }
      } else {}
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) return;
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      Get.delete<ProfileController>(force: true);
      Get.offAllNamed('/login');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    pincodeController.removeListener(_onPincodeChanged);
    selectedImage.value = null;
    selectedState.value = "Uttar Pradesh";
    selectedDob.value = '';
    super.onClose();
  }
}
