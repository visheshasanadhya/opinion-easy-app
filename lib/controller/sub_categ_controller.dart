import 'package:opinion_easy/data/model/sub_categ_model.dart';
import 'package:opinion_easy/data/service/sub_categ_service.dart';
import 'package:get/get.dart';

class SubCategController extends GetxController {
  var isLoading = false.obs;
  var subCategList = <SubCategModel>[].obs;
  final SubCategService subCategService = SubCategService();

  Future<void> fetchSubCateg(int categId, String categName) async {
    try {
      isLoading.value = true;

      var response = await subCategService.fetchSubCateg(categId);
      subCategList.assignAll(response);

      Get.toNamed('/sub-categ');
    } catch (e) {
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar("Oops", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
