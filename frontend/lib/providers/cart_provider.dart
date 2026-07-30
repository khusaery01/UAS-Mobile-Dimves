import 'package:flutter/material.dart';

import '../models/menu_model.dart';
import '../models/variant_model.dart';

class SelectedVariant {
  final MenuVariantModel variant;
  final MenuVariantOptionModel option;

  SelectedVariant({required this.variant, required this.option});
}

class CartItem {
  final MenuModel menu;
  int quantity;
  String note;
  List<SelectedVariant> selectedVariants;

  CartItem({
    required this.menu,
    this.quantity = 1,
    this.note = "",
    this.selectedVariants = const [],
  });

  double get unitPrice {
    double extra = 0;
    for (var v in selectedVariants) {
      extra += v.option.extraPrice;
    }
    return menu.price + extra;
  }

  double get subtotal => unitPrice * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  String _orderType = "delivery"; // dine_in, takeaway, delivery
  String? _tableNumber;
  String? _voucherCode;
  double _discountAmount = 0;
  double _deliveryFee = 10000;

  List<CartItem> get items => _items;
  String get orderType => _orderType;
  String? get tableNumber => _tableNumber;
  String? get voucherCode => _voucherCode;
  double get discountAmount => _discountAmount;
  double get deliveryFee => _orderType == "delivery" ? _deliveryFee : 0;

  void setOrderType(String type, {String? table}) {
    _orderType = type;
    _tableNumber = table;
    notifyListeners();
  }

  void applyVoucher(String code, double discount) {
    _voucherCode = code;
    _discountAmount = discount;
    notifyListeners();
  }

  void removeVoucher() {
    _voucherCode = null;
    _discountAmount = 0;
    notifyListeners();
  }

  void addToCart(
    MenuModel menu, {
    int quantity = 1,
    String note = "",
    List<SelectedVariant> selectedVariants = const [],
  }) {
    // Cek item sejenis dengan varian yang sama persis
    final index = _items.indexWhere((e) => e.menu.id == menu.id && e.note == note);

    if (index >= 0 && selectedVariants.isEmpty) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(
        menu: menu,
        quantity: quantity,
        note: note,
        selectedVariants: List.from(selectedVariants),
      ));
    }

    notifyListeners();
  }

  void updateNote(int index, String note) {
    _items[index].note = note;
    notifyListeners();
  }

  void increase(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decrease(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  double get subtotalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.subtotal;
    }
    return total;
  }

  double get grandTotalPrice {
    double total = subtotalPrice - _discountAmount + deliveryFee;
    return total > 0 ? total : 0;
  }

  int get totalItem {
    int total = 0;
    for (var item in _items) {
      total += item.quantity;
    }
    return total;
  }

  void clearCart() {
    _items.clear();
    _voucherCode = null;
    _discountAmount = 0;
    notifyListeners();
  }
}
