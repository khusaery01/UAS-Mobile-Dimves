import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        "title": "Dimsum",
        "icon": Icons.restaurant,
        "color": const Color(0xFFE53935),
      },
      {
        "title": "Minuman",
        "icon": Icons.local_drink,
        "color": const Color(0xFF29B6F6),
      },
      {
        "title": "Best Seller",
        "icon": Icons.local_fire_department,
        "color": const Color(0xFFFF9800),
      },
      {
        "title": "Promo",
        "icon": Icons.local_offer,
        "color": const Color(0xFF43A047),
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jelajahi Menu",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          const Text(
            "Temukan Menu favoritmu!",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 0),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (context, index) {
              final item = categories[index];

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: (item["color"] as Color).withOpacity(
                            .12,
                          ),
                          child: Icon(
                            item["icon"] as IconData,
                            color: item["color"] as Color,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Text(
                            item["title"] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
