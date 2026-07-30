import 'package:flutter/material.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFF6B35),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
      child: Column(
        children: [
          const Text(
            "Siap Menikmati Dimsum Kami?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Pesan sekarang dan rasakan kelezatan Dimsum Vespa yang dibuat setiap hari menggunakan bahan berkualitas.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.6),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFF6B35),
              ),
              onPressed: () {},
              icon: const Icon(Icons.chat),
              label: const Text("Pesan via WhatsApp"),
            ),
          ),

          const SizedBox(height: 30),

          const Divider(color: Colors.white30),

          const SizedBox(height: 20),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.white),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Jl. Pekiringan",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, color: Colors.white),
              SizedBox(width: 8),
              Text("16.00 - 01.00 WIB", style: TextStyle(color: Colors.white)),
            ],
          ),

          SizedBox(height: 25),

          const Text(
            "© 2026 DIMVES - Dimsum Vespa",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
