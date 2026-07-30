import 'package:flutter/material.dart';

import '../cart/cart_page.dart';
import '../home/home_page.dart';
import '../order/order_page.dart';
import '../profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  List<Widget> get pages => [
    const HomePage(),
    const OrderPage(),

    CartPage(
      onStartShopping: () {
        setState(() {
          currentIndex = 0;
        });
      },
    ),

    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: NavigationBar(
              height: 72,
              elevation: 8,
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFFFFEBEE),
              selectedIndex: currentIndex,
              onDestinationSelected: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: Color(0xFFE53935)),
                  label: "Beranda",
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(
                    Icons.receipt_long,
                    color: Color(0xFFE53935),
                  ),
                  label: "Pesanan",
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart_outlined),
                  selectedIcon: Icon(
                    Icons.shopping_cart,
                    color: Color(0xFFE53935),
                  ),
                  label: "Keranjang",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: Color(0xFFE53935)),
                  label: "Profil",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
