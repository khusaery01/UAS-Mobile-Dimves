import 'dart:async';
import 'package:flutter/material.dart';

import '../main/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      // Selalu langsung arahkan ke Home / MainPage agar user bisa melihat menu
      // Login baru akan diminta saat user ingin melakukan checkout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 200,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color(0xFFE53935),
            ),
          ],
        ),
      ),
    );
  }
}