class OrderDetailModel {
  final int id;
  final String orderCode;
  final double totalPrice;
  final double discountAmount;
  final double deliveryFee;
  final double grandTotal;
  final String paymentMethod;
  final String shippingAddress;
  final String orderType;
  final String? tableNumber;
  final String kitchenStatus;
  final String status;
  final String createdAt;
  final List<OrderItemModel> items;

  OrderDetailModel({
    required this.id,
    required this.orderCode,
    required this.totalPrice,
    required this.discountAmount,
    required this.deliveryFee,
    required this.grandTotal,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.orderType,
    this.tableNumber,
    required this.kitchenStatus,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    double total = double.parse((json["total_price"] ?? 0).toString());
    double discount = double.parse((json["discount_amount"] ?? 0).toString());
    double delivery = double.parse((json["delivery_fee"] ?? 0).toString());
    double grand = json["grand_total"] != null
        ? double.parse(json["grand_total"].toString())
        : (total - discount + delivery);

    return OrderDetailModel(
      id: json["id"],
      orderCode: json["order_code"] ?? "",
      totalPrice: total,
      discountAmount: discount,
      deliveryFee: delivery,
      grandTotal: grand > 0 ? grand : total,
      paymentMethod: json["payment_method"] ?? "Cash",
      shippingAddress: json["shipping_address"] ?? "",
      orderType: json["order_type"] ?? "delivery",
      tableNumber: json["table_number"],
      kitchenStatus: json["kitchen_status"] ?? "waiting",
      status: json["status"] ?? "Pending",
      createdAt: json["created_at"] ?? "",
      items: json["items"] != null
          ? (json["items"] as List)
              .map((e) => OrderItemModel.fromJson(e))
              .toList()
          : [],
    );
  }
}

class OrderItemModel {
  final String name;
  final int quantity;
  final double price;
  final double subtotal;
  final String? note;
  final List<OrderItemVariantModel> variants;

  OrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
    required this.subtotal,
    this.note,
    this.variants = const [],
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json["menu"] != null ? json["menu"]["name"] : "Menu",
      quantity: json["quantity"] ?? 1,
      price: double.parse((json["price"] ?? 0).toString()),
      subtotal: double.parse((json["subtotal"] ?? 0).toString()),
      note: json["note"],
      variants: json["variants"] != null
          ? (json["variants"] as List)
              .map((e) => OrderItemVariantModel.fromJson(e))
              .toList()
          : [],
    );
  }
}

class OrderItemVariantModel {
  final String variantName;
  final String optionName;
  final double extraPrice;

  OrderItemVariantModel({
    required this.variantName,
    required this.optionName,
    required this.extraPrice,
  });

  factory OrderItemVariantModel.fromJson(Map<String, dynamic> json) {
    return OrderItemVariantModel(
      variantName: json["variant_name"] ?? "",
      optionName: json["option_name"] ?? "",
      extraPrice: double.parse((json["extra_price"] ?? 0).toString()),
    );
  }
}
