import 'variant_model.dart';

class MenuModel {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String image;
  final bool status;
  final List<MenuVariantModel> variants;

  MenuModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.status,
    this.variants = const [],
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json["id"],
      categoryId: json["category_id"],
      name: json["name"],
      description: json["description"] ?? "",
      price: double.parse(json["price"].toString()),
      stock: json["stock"] ?? 0,
      image: json["image"] ?? "",
      status: json["status"] == 1 || json["status"] == true,
      variants: json["variants"] != null
          ? (json["variants"] as List)
              .map((e) => MenuVariantModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
