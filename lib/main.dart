import 'package:acad_calculator/screens/end_screen.dart';
import 'package:acad_calculator/screens/form/acad_form.dart';
import 'package:acad_calculator/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/acad_form': (context) => AcadForm(),
        '/end_screen': (context) => EndScreen(),
      },
    );
  }
}
