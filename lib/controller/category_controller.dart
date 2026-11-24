import 'package:opinion_easy/data/model/categories_model.dart';
import 'package:opinion_easy/data/service/categories_service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <CategoriesData>[].obs;

  var categName = "Select one by one".obs;
  int categId = 0;

  void setCategoryInfo(String name, int id) {
    categName.value = name;
    categId = id;
  }

  final CategoriesService categoriesService = CategoriesService();

  @override
  onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      var response = await categoriesService.fetchCategories();
      if (response.success == true) {
        categories.value = response.data ?? [];
      }
    } catch (e) {
      if (e.toString().contains("AUTHENTICATION_REQUIRED") ||
          e.toString().contains("Authentication is required")) {
        return;
      }
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
