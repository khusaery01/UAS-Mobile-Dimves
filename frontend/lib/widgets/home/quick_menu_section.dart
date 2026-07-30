import 'package:flutter/material.dart';

class QuickMenuSection extends StatelessWidget {
  const QuickMenuSection({super.key});

  Widget menuItem({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 30),
            ),

            const SizedBox(height: 10),

            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Row(
        children: [
          menuItem(
            icon: Icons.restaurant_menu,
            title: "Menu",
            color: Colors.red,
          ),

          menuItem(
            icon: Icons.category,
            title: "Kategori",
            color: Colors.orange,
          ),

          menuItem(
            icon: Icons.local_offer,
            title: "Promo",
            color: Colors.green,
          ),

          menuItem(icon: Icons.favorite, title: "Favorit", color: Colors.pink),
        ],
      ),
    );
  }
}
