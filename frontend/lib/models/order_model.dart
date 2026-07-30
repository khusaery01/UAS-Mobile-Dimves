class OrderModel {
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

  OrderModel({
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
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    double total = double.parse((json["total_price"] ?? 0).toString());
    double discount = double.parse((json["discount_amount"] ?? 0).toString());
    double delivery = double.parse((json["delivery_fee"] ?? 0).toString());
    double grand = json["grand_total"] != null
        ? double.parse(json["grand_total"].toString())
        : (total - discount + delivery);

    return OrderModel(
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
    );
  }
}
