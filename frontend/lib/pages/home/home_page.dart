import 'package:flutter/material.dart';

import '../../widgets/home/about_section.dart';
import '../../widgets/home/contact_section.dart';
import '../../widgets/home/drink_section.dart';
import '../../widgets/home/featured_menu_section.dart';
import '../../widgets/home/promo_section.dart';
import '../../widgets/home/testimonial_section.dart';
import '../cart/cart_page.dart';
import '../menu/menu_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),

        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: 380,
            elevation: 0,
            backgroundColor: const Color(0xffE53935),

            title: Row(
              children: [
                Image.asset("assets/images/logo.png", width: 38),

                const SizedBox(width: 10),

                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DIMVES",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      "Nikmatnya Ga Penah Mogok!",
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),

            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,

              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset("assets/images/kedai.png", fit: BoxFit.cover),

                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color.fromARGB(80, 0, 0, 0),
                          Color.fromARGB(220, 0, 0, 0),
                        ],
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Rating 4.9",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "Fresh dibuat\nsetiap hari",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Dimsum premium dengan berbagai varian rasa favorit.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 22),

                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffE53935),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MenuPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.restaurant_menu),
                              label: const Text(
                                "Pesan Sekarang",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(height: 45),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -30),

              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                ),

                child: const Padding(
                  padding: EdgeInsets.only(top: 22),

                  child: Column(
                    children: [
                      FeaturedMenuSection(),

                      DrinkSection(),

                      PromoSection(),

                      AboutSection(),

                      TestimonialSection(),

                      ContactSection(),

                      SizedBox(height: 45),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
