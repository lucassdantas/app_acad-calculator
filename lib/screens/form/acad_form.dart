import 'package:flutter/material.dart';

class AcadForm extends StatefulWidget {
  const AcadForm({super.key});

  @override
  State<AcadForm> createState() => _AcadFormState();
}

class _AcadFormState extends State<AcadForm> {
  int currentStep = 0;
  int currentSubstep = 0;

  final Map<int, Map<int, Widget>> formStepsWidgets = {
    0: {
      0: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Como se chama a sua academia?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const TextField(decoration: InputDecoration(labelText: 'Input 1')),
        ],
      ),
    },
    1: {
      0: Column(
        children: [
          const Text('Outro título aqui'),
          const TextField(
            decoration: InputDecoration(labelText: 'Outro input'),
          ),
        ],
      ),
    },
  };

  void stepController() {
    setState(() {
      currentStep++;
    });

    print(currentStep);
  }

  @override
  Widget build(BuildContext context) {
    final Widget? currentWidget =
        formStepsWidgets[currentStep]?[currentSubstep];

    return Column(
      children: [
        if (currentWidget != null)
          currentWidget
        else
          const Text('Etapa não encontrada'),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          label: const Text('Próximo'),
          onPressed: () {
            stepController();
          },
          icon: const Icon(Icons.arrow_outward),
          iconAlignment: IconAlignment.end,
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.yellow),
          ),
        ),
      ],
    );
  }
}
