import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import '../../models/variant_model.dart';
import '../../providers/cart_provider.dart';

class CustomizationModal extends StatefulWidget {
  final MenuModel menu;
  final Function(int quantity, String note, List<SelectedVariant> selectedVariants) onConfirm;

  const CustomizationModal({
    super.key,
    required this.menu,
    required this.onConfirm,
  });

  @override
  State<CustomizationModal> createState() => _CustomizationModalState();
}

class _CustomizationModalState extends State<CustomizationModal> {
  int quantity = 1;
  final TextEditingController noteController = TextEditingController();
  final Map<int, MenuVariantOptionModel> selectedSingleOptions = {};

  @override
  void initState() {
    super.initState();
    // Default pilih opsi pertama dari setiap varian required
    for (var variant in widget.menu.variants) {
      if (variant.options.isNotEmpty) {
        selectedSingleOptions[variant.id] = variant.options.first;
      }
    }
  }

  double get calculateTotalPrice {
    double extra = 0;
    selectedSingleOptions.forEach((key, option) {
      extra += option.extraPrice;
    });
    return (widget.menu.price + extra) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.menu.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${widget.menu.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFFE53935),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.menu.stock > 0 ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.menu.stock > 0 ? "Stok: ${widget.menu.stock}" : "Stok Habis",
                    style: TextStyle(
                      color: widget.menu.stock > 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),

            // Customization Variants (Level Pedas / Topping)
            if (widget.menu.variants.isNotEmpty) ...[
              ...widget.menu.variants.map((variant) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          variant.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (variant.isRequired)
                          const Text(
                            " *Wajib",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: Colors.transparent,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: variant.options.map((option) {
                          final isSelected = selectedSingleOptions[variant.id]?.id == option.id;
                          return ChoiceChip(
                            label: Text(
                              option.extraPrice > 0
                                  ? "${option.name} (+Rp ${option.extraPrice.toStringAsFixed(0)})"
                                  : option.name,
                            ),
                            selected: isSelected,
                            selectedColor: const Color(0xFFE53935),
                            showCheckmark: false,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            side: isSelected
                                ? const BorderSide(color: Color(0xFFE53935))
                                : BorderSide(color: Colors.grey.shade300),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  selectedSingleOptions[variant.id] = option;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ],

            // Note per item
            const Text(
              "Catatan Khusus (Optional)",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: "Contoh: Jangan terlalu pedas, bumbu dipisah...",
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quantity Counter & Confirm Button
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                      ),
                      Text(
                        "$quantity",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: quantity < widget.menu.stock
                            ? () => setState(() => quantity++)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),

                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: widget.menu.stock <= 0
                          ? null
                          : () {
                              List<SelectedVariant> selectedList = [];
                              widget.menu.variants.forEach((v) {
                                if (selectedSingleOptions.containsKey(v.id)) {
                                  selectedList.add(SelectedVariant(
                                    variant: v,
                                    option: selectedSingleOptions[v.id]!,
                                  ));
                                }
                              });

                              widget.onConfirm(
                                quantity,
                                noteController.text.trim(),
                                selectedList,
                              );
                              Navigator.pop(context);
                            },
                      child: Text(
                        widget.menu.stock > 0
                            ? "+ Tambah (Rp ${calculateTotalPrice.toStringAsFixed(0)})"
                            : "Stok Habis",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
