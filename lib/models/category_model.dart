
import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    List<Category> categories;

    CategoryModel({
        required this.categories,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    };
}

class Category {
    String name;
    List<String> subCategory;

    Category({
        required this.name,
        required this.subCategory,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        subCategory: List<String>.from(json["subCategory"].map((x) => x)),

    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "subCategory": List<dynamic>.from(subCategory.map((x) => x)),
    };
}
