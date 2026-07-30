class MenuVariantModel {
  final int id;
  final int menuId;
  final String name;
  final bool isRequired;
  final bool isMultiple;
  final List<MenuVariantOptionModel> options;

  MenuVariantModel({
    required this.id,
    required this.menuId,
    required this.name,
    required this.isRequired,
    required this.isMultiple,
    required this.options,
  });

  factory MenuVariantModel.fromJson(Map<String, dynamic> json) {
    return MenuVariantModel(
      id: json["id"],
      menuId: json["menu_id"],
      name: json["name"],
      isRequired: json["is_required"] == 1 || json["is_required"] == true,
      isMultiple: json["is_multiple"] == 1 || json["is_multiple"] == true,
      options: json["options"] != null
          ? (json["options"] as List)
              .map((e) => MenuVariantOptionModel.fromJson(e))
              .toList()
          : [],
    );
  }
}

class MenuVariantOptionModel {
  final int id;
  final int menuVariantId;
  final String name;
  final double extraPrice;
  final bool isAvailable;

  MenuVariantOptionModel({
    required this.id,
    required this.menuVariantId,
    required this.name,
    required this.extraPrice,
    required this.isAvailable,
  });

  factory MenuVariantOptionModel.fromJson(Map<String, dynamic> json) {
    return MenuVariantOptionModel(
      id: json["id"],
      menuVariantId: json["menu_variant_id"],
      name: json["name"],
      extraPrice: double.parse(json["extra_price"].toString()),
      isAvailable: json["is_available"] == 1 || json["is_available"] == true,
    );
  }
}
