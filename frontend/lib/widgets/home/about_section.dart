import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              "assets/images/about_us.jpeg",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.storefront,
                  size: 80,
                  color: Color(0xFFE53935),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Tentang Kami",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          const Text(
            "DIMVES (Dimsum Vespa) hadir untuk menyajikan dimsum berkualitas dengan cita rasa oriental yang lezat dan harga yang terjangkau. Seluruh menu dibuat menggunakan bahan pilihan dan disajikan hangat setiap hari agar pelanggan mendapatkan pengalaman terbaik.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.6),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline),
              label: const Text("Selengkapnya"),
            ),
          ),
        ],
      ),
    );
  }
}
