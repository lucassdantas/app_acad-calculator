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
            'Etapa 1 substep 1',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const TextField(decoration: InputDecoration(labelText: 'Input 1')),
        ],
      ),
    },
    1: {
      0: Column(
        children: [
          const Text('Etapa 2 substep 1'),
          const TextField(
            decoration: InputDecoration(labelText: 'Outro input'),
          ),
        ],
      ),
      1: Column(
        children: [
          const Text('Etapa 2 substep 2'),
          const TextField(
            decoration: InputDecoration(labelText: 'Outro input'),
          ),
        ],
      ),
    },
    2: {
      0: Column(
        children: [
          const Text('Etapa 3 substep 1'),
          const TextField(
            decoration: InputDecoration(labelText: 'Outro input 2'),
          ),
          const TextField(
            decoration: InputDecoration(labelText: 'Outro input 2'),
          ),
        ],
      ),
    },
    3: {
      0: Column(
        children: [
          const Text('Etapa 4 substep 1'),
          const TextField(
            decoration: InputDecoration(labelText: 'Outro input 2'),
          ),
          const TextField(
            decoration: InputDecoration(labelText: 'Outro input 2'),
          ),
        ],
      ),
    },
  };

  void stepController(int amountToHandle) {
    if (formStepsWidgets[currentStep]?.containsKey(
          currentSubstep + amountToHandle,
        ) ??
        false) {
      return setState(() => currentSubstep += amountToHandle);
    }
    if (formStepsWidgets.containsKey(currentStep + amountToHandle)) {
      setState(() => currentSubstep = 0);
      return setState(() => currentStep += amountToHandle);
    }
    if (currentStep + amountToHandle < 0) {
      setState(() => currentStep = 0);
      setState(() => currentSubstep = 0);
      return Navigator.pop(context);
    }
    if (currentStep + amountToHandle > (formStepsWidgets.length - 1)) {
      Navigator.pushNamed(context, '/end_screen');
      return;
    }
    print(currentStep);
  }

  @override
  Widget build(BuildContext context) {
    final Widget? currentWidget =
        formStepsWidgets[currentStep]?[currentSubstep];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/acad-logo.png'),
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_rounded),
          onPressed: () {
            stepController(-1);
          },
        ),
      ),
      body: Column(
        children: [
          if (currentWidget != null)
            currentWidget
          else
            const Text('Etapa não encontrada'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            label: const Text('Próximo'),
            onPressed: () {
              stepController(1);
            },
            icon: const Icon(Icons.arrow_outward),
            iconAlignment: IconAlignment.end,
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.yellow),
            ),
          ),
          //
        ],
      ),
    );
  }
}
