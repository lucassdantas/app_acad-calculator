import 'package:flutter/material.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});

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
            label: Text('Quero economizar agora'),
            onPressed: () {
              Navigator.pop(context);
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
