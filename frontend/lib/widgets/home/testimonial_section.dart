import 'package:flutter/material.dart';

class TestimonialSection extends StatelessWidget {
  const TestimonialSection({super.key});

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      {
        "name": "Rina",
        "comment":
            "Dimsumnya enak banget, lembut dan gurih. Pasti bakal pesan lagi!",
      },
      {
        "name": "Budi",
        "comment": "Pelayanannya cepat, harga terjangkau, rasanya mantap.",
      },
      {
        "name": "Siska",
        "comment":
            "Tempat favorit buat nongkrong sambil makan dimsum bareng teman.",
      },
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF7F2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          const Text(
            "Apa Kata Pelanggan",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "Kepuasan pelanggan adalah prioritas kami.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 25),

          ...testimonials.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFFFE2D4),
                      child: Icon(
                        Icons.person,
                        color: Color(0xFFFF6B35),
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["name"]!,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              Icon(Icons.star, color: Colors.amber, size: 18),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            item["comment"]!,
                            style: const TextStyle(
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
