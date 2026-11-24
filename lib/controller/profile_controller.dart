import 'dart:io';
import 'package:opinion_easy/core/utils/widgets/invalid_pincode_bottom_sheet.dart';
import 'package:opinion_easy/data/model/profile_model.dart';
import 'package:opinion_easy/data/service/postal_pincode_api.dart';
import 'package:opinion_easy/data/service/profile_service.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  final RxBool isVerifyingPincode = false.obs;
  final RxBool isPincodeValid = false.obs;
  String _lastCheckedPincode = "";

  @override
  void onInit() {
    super.onInit();
    _loadInitialPrefs();
    pincodeController.addListener(_onPincodeChanged);
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            color: AppColor.scaffold,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
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
    );
  }

  Future<bool> updateProfile({bool navigateHomeOnSuccess = false}) async {
    try {
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
          Get.snackbar('Success', response['message'] ?? 'Profile updated successfully');
          if (navigateHomeOnSuccess) {
            Get.offAllNamed('/bottom-nav');
          } else {
            Get.back();
          }
          return true;
        } else {
          final errorMsg = response['message'] ??
              response['details']?['reason'] ??
              'Failed to update profile';
          Get.snackbar('Error', errorMsg.toString());
          return false;
        }
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProfile() async {
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
      Get.offAllNamed('/login');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    pincodeController.removeListener(_onPincodeChanged);
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    districtController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    referralController.dispose();
    selectedImage.value = null;
    selectedState.value = "Uttar Pradesh";
    selectedDob.value = '';
    super.onClose();
  }
}
