class CategoryModel {
  bool? success;
  List<CategoriesData>? data;

  CategoryModel({this.success, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CategoriesData>[];
      json['data'].forEach((v) {
        data!.add(CategoriesData.fromJson(v));
      });
    }
  }
}

class CategoriesData {
  int? id;
  String? name;
  String? description;
  String? image;
  int? leftQuestionCount;
  String? createdAt;
  String? updatedAt;

  CategoriesData({
    this.id,
    this.name,
    this.description,
    this.image,
    this.leftQuestionCount,
    this.createdAt,
    this.updatedAt,
  });

  CategoriesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']?.toString();
    description = json['description']?.toString();
    image = json['image']?.toString();
    leftQuestionCount = json['left_question_count'] ?? 0;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
}
