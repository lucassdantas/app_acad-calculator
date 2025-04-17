import 'package:acad_calculator/screens/form/form_main.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/acad-logo.png'),
          Image.asset('assets/discount-man.png'),
          Text(
            'Descubra quanto sua academia pode economizar',
            style: TextStyle(color: Colors.blue),
          ),
          Text(
            'sendo um associado ACAD Brasil!',
            style: TextStyle(color: Colors.grey),
          ),
          ElevatedButton.icon(
            label: Text('Calcular minha economia agora'),
            onPressed: () {
              Navigator.pushNamed(context, '/acad_form');
            },
            icon: Icon(Icons.arrow_outward),
            iconAlignment: IconAlignment.end,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.yellow),
            ),
          ),
          Image.asset('assets/feito-por-diagonal.png'),
        ],
      ),
    );
  }
}
