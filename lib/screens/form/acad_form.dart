import 'package:flutter/material.dart';

class AcadForm extends StatefulWidget {
  final BuildContext context;
  final int currentStep;
  final int currentSubstep;
  const AcadForm({
    super.key,
    required this.context,
    required this.currentStep,
    required this.currentSubstep,
  });

  @override
  State<AcadForm> createState() => _AcadFormState();
}

class _AcadFormState extends State<AcadForm> {
  final Map<int, Map<int, Widget>> formStepsWidgets = {
    0: {
      0: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Título do Passo 0 - Subpasso 0',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const TextField(decoration: InputDecoration(labelText: 'Input 1')),
          const TextField(decoration: InputDecoration(labelText: 'Input 2')),
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

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
