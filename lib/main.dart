import 'package:flutter/material.dart';
import 'package:gdg_solution/farmer/farmer_awareness.dart';
import 'package:gdg_solution/farmer/home_page.dart';
import 'package:gdg_solution/farmer/listing_page.dart';
import 'package:gdg_solution/farmer/mainNav.dart';
import 'package:gdg_solution/farmer/schemes.dart';
import 'package:gdg_solution/farmer/weather.dart';
import 'package:gdg_solution/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      // darkTheme: ,
      home: MainNavigation(),
      routes: {
        '/home_page': (context) => HomePage(),
        '/listing_page': (context) => ListingPage(),
        '/Scheme_page': (context) => Schemes(),
        '/farmer_awareness_page': (context) => FarmerAwareness(),
        '/weather_page': (context) => Weather(),
      },
    );
  }
}
