import 'package:flutter/material.dart';

class AcadForm extends StatefulWidget {
  const AcadForm({super.key});

  @override
  State<AcadForm> createState() => _AcadFormState();
}

class _AcadFormState extends State<AcadForm> {
  int currentStep = 0;
  int currentSubstep = 0;
  final TextEditingController academyNameController = TextEditingController();
  final TextEditingController ufController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  Map<int, Map<int, Widget>> buildFormStepsWidgets() {
    return {
      0: {
        0: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Como se chama sua academia?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: academyNameController,
              decoration: const InputDecoration(labelText: 'Minha academia'),
            ),
          ],
        ),
        1: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Onde fica a ${academyNameController.text}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: ufController,
              decoration: InputDecoration(labelText: 'UF'),
            ),
            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'Selecione uma cidade'),
            ),
          ],
        ),
      },
      // Outras etapas iguais
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
  }

  void formController(amountToHandle) {
    handleValueBySteps();
    stepController(amountToHandle);
  }

  void handleValueBySteps() {
    if (currentStep == 0 && currentSubstep == 0) {
      //setState(() => academyName = '');
    }
  }

  void stepController(int amountToHandle) {
    if (buildFormStepsWidgets()[currentStep]?.containsKey(
          currentSubstep + amountToHandle,
        ) ??
        false) {
      return setState(() => currentSubstep += amountToHandle);
    }
    if (buildFormStepsWidgets().containsKey(currentStep + amountToHandle)) {
      setState(() => currentSubstep = 0);
      return setState(() => currentStep += amountToHandle);
    }
    if (currentStep + amountToHandle < 0) {
      setState(() => currentStep = 0);
      setState(() => currentSubstep = 0);
      return Navigator.pop(context);
    }
    if (currentStep + amountToHandle > (buildFormStepsWidgets().length - 1)) {
      Navigator.pushNamed(context, '/end_screen');
      return;
    }
    print(currentStep);
  }

  @override
  Widget build(BuildContext context) {
    final Widget? currentWidget =
        buildFormStepsWidgets()[currentStep]?[currentSubstep];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/acad-logo.png'),
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_rounded),
          onPressed: () {
            formController(-1);
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
              formController(1);
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
