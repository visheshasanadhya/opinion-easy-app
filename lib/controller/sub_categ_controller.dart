import 'package:opinion_easy/data/model/sub_categ_model.dart';
import 'package:opinion_easy/data/service/sub_categ_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategController extends GetxController {
  var isLoading = false.obs;
  var subCategList = <SubCategModel>[].obs;
  final SubCategService subCategService = SubCategService();

  // Specialized Gradients (Moved from SubCategView)
  final List<Color> cricketGradient = const [
    Color(0xFF1A237E),
    Color(0xFF3F51B5),
    Color(0xFF00BCD4),
  ];
  final List<Color> stockMarketGradient = const [
    Color(0xFF1A237E),
    Color(0xFF3F51B5),
    Color(0xFF00BCD4),
  ];

  Future<void> fetchSubCateg(int categId, String categName) async {
    try {
      isLoading.value = true;

      var response = await subCategService.fetchSubCateg(categId);
      subCategList.assignAll(response);

      Get.toNamed('/sub-categ');
    } catch (e) {
      Get.snackbar("Oops", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
