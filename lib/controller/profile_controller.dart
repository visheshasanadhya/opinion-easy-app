import 'dart:io';
import 'package:opinion_easy/data/model/profile_model.dart';
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
  final TextEditingController pincodeController = TextEditingController();

  @override
  onInit() {
    super.onInit();
    fetchProfile();
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
    selectedDob.value = data?.dob ?? '';
    cityController.text = data?.address?.city ?? '';
    addressController.text = data?.address?.address ?? '';
    districtController.text = data?.address?.district ?? '';
    pincodeController.text = data?.address?.pincode ?? '';
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

        var response = await profileService.updateProfile(
          nameController.text.trim(),
          emailController.text.trim(),
          phoneController.text.trim(),
          selectedState.value,
          cityController.text.trim(),
          addressController.text.trim(),
          pincodeController.text.trim(),
          districtController.text.trim(),
          selectedImage.value,
          selectedDob.value,
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    districtController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    selectedImage.value = null;
    selectedState.value = "Uttar Pradesh";
    selectedDob.value = '';
    super.onClose();
  }
}
