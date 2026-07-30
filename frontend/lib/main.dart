import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'pages/splash/splash_page.dart';
import 'providers/cart_provider.dart';
import 'providers/menu_provider.dart';

void main() {
  runApp(const DimvesApp());
}

class DimvesApp extends StatelessWidget {
  const DimvesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),

        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "DIMVES",
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
