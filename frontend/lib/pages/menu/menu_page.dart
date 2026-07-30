import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../cart/cart_page.dart';
import '../../models/category_model.dart';
import '../../models/menu_model.dart';
import '../../providers/menu_provider.dart'; // Menambahkan import provider
import '../../services/api_service.dart'; // Pastikan ApiService terimport
import 'detail_menu_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Menghapus menuFuture sesuai instruksi
  late Future<List<CategoryModel>> categoryFuture;

  List<MenuModel> allMenus = [];
  List<CategoryModel> categories = [];

  int selectedCategory = 0;
  String search = "";

  @override
  void initState() {
    super.initState();

    // Memanggil loadMenus saat inisialisasi
    Future.microtask(() {
      context.read<MenuProvider>().loadMenus();
    });

    categoryFuture = ApiService().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Menu"),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      );
                    },
                  ),
                  if (cart.totalItem > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart.totalItem.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: categoryFuture, // Menggunakan categoryFuture saja
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Menambahkan pengecekan MenuProvider
          final menuProvider = context.watch<MenuProvider>();

          if (menuProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (menuProvider.error != null) {
            return Center(child: Text(menuProvider.error!));
          }

          allMenus = menuProvider.menus;
          categories = snapshot.data as List<CategoryModel>;

          // Logika Filter
          List<MenuModel> filtered = allMenus.where((menu) {
            final cocokKategori = selectedCategory == 0
                ? true
                : menu.categoryId == selectedCategory;

            final cocokSearch = menu.name.toLowerCase().contains(
              search.toLowerCase(),
            );

            return cocokKategori && cocokSearch;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Cari menu...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text("Semua"),
                        selected: selectedCategory == 0,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = 0;
                          });
                        },
                      ),
                    ),
                    ...categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category.name),
                          selected: selectedCategory == category.id,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category.id;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Bagian Expanded dengan RefreshIndicator
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<MenuProvider>().loadMenus();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final menu = filtered[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: menu.categoryId == 1
                                ? const Color(0xFFFF7043)
                                : const Color(0xFF42A5F5),
                            child: Icon(
                              menu.categoryId == 1
                                  ? Icons.lunch_dining
                                  : Icons.local_drink,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            menu.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: menu.categoryId == 1
                                      ? Colors.orange.shade100
                                      : Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  menu.categoryId == 1 ? "Dimsum" : "Minuman",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: menu.categoryId == 1
                                        ? Colors.orange.shade900
                                        : Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(menu.description),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Rp ${menu.price.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Color(0xFFE53935),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Icon(Icons.arrow_forward_ios, size: 18),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailMenuPage(menu: menu),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
