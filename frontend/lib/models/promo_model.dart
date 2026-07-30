class PromoModel {
  final int id;
  final String name;
  final String voucherCode;
  final String discountType;
  final double discountValue;
  final double minOrder;

  PromoModel({
    required this.id,
    required this.name,
    required this.voucherCode,
    required this.discountType,
    required this.discountValue,
    required this.minOrder,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json["id"],
      name: json["name"],
      voucherCode: json["voucher_code"],
      discountType: json["discount_type"],
      discountValue: double.parse(json["discount_value"].toString()),
      minOrder: double.parse(json["min_order"].toString()),
    );
  }
}
