import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CopticLiturgyApp());
}

class CopticLiturgyApp extends StatelessWidget {
  const CopticLiturgyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'القراءات القبطية',
      theme: ThemeData(
        fontFamily: 'Cairo',
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF9F5E9),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
