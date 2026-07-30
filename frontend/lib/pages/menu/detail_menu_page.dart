import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/menu_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/menu/customization_modal.dart';

class DetailMenuPage extends StatelessWidget {
  final MenuModel menu;

  const DetailMenuPage({super.key, required this.menu});

  void _showCustomizationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomizationModal(
        menu: menu,
        onConfirm: (quantity, note, selectedVariants) {
          context.read<CartProvider>().addToCart(
                menu,
                quantity: quantity,
                note: note,
                selectedVariants: selectedVariants,
              );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFE53935),
              content: Text("${menu.name} berhasil ditambahkan ke keranjang"),
              duration: const Duration(milliseconds: 1000),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(menu.name)),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 240,
              width: double.infinity,
              color: const Color(0xFFFFE5D9),
              child: const Icon(
                Icons.restaurant,
                size: 110,
                color: Color(0xFFE53935),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          menu.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: menu.stock > 0 ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          menu.stock > 0 ? "Stok: ${menu.stock}" : "Habis",
                          style: TextStyle(
                            color: menu.stock > 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Rp ${menu.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 5),
                      Text("4.9 (250+ Review)", style: TextStyle(fontSize: 15)),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    menu.description.isNotEmpty ? menu.description : "Menu khas resto DIMVES yang disajikan hangat dan lezat.",
                    style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: menu.stock > 0
                          ? () => _showCustomizationModal(context)
                          : null,
                      icon: const Icon(Icons.shopping_cart),
                      label: Text(
                        menu.stock > 0 ? "Pilih Varian & Tambah" : "Menu Stok Habis",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
