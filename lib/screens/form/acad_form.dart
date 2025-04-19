import 'package:acad_calculator/entities/brazilian_state.dart';
import 'package:acad_calculator/entities/search_states_and_cities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AcadForm extends StatefulWidget {
  const AcadForm({super.key});

  @override
  State<AcadForm> createState() => _AcadFormState();
}

class _AcadFormState extends State<AcadForm> {
  int currentStep = 0;
  int currentSubstep = 0;
  final TextEditingController academyNameController = TextEditingController();
  final TextEditingController academyQuantityController = TextEditingController();
  final TextEditingController academyBilling = TextEditingController();

  List<BrazilianState> estados = [];
  String? ufSelecionada;
  String? cidadeSelecionada;

  @override
  void initState() {
    super.initState();
    carregarEstadosECidades().then((dados) {
      setState(() {
        estados = dados;
      });
    });
  }

  Map<int, Map<int, Widget>> buildFormStepsWidgets() {
    return {
      0: {
        0: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Como se chama sua academia?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            DropdownButtonFormField<String>(
              value: ufSelecionada,
              decoration: const InputDecoration(labelText: 'UF'),
              items:
                  estados.map((estado) {
                    return DropdownMenuItem(value: estado.acronym, child: Text(estado.acronym));
                  }).toList(),
              onChanged: (String? newUf) {
                setState(() {
                  ufSelecionada = newUf;
                  cidadeSelecionada = null;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: cidadeSelecionada,
              decoration: const InputDecoration(labelText: 'Cidade'),
              items:
                  (estados
                      .firstWhere(
                        (e) => e.acronym == ufSelecionada,
                        orElse: () => BrazilianState(acronym: '', name: '', cities: []),
                      )
                      .cities
                      .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                      .toList()),
              onChanged: (String? newCity) {
                setState(() {
                  cidadeSelecionada = newCity;
                });
              },
            ),
          ],
        ),
        2: Column(
          children: [
            Text('Quantas unidades a ${academyNameController.text} tem?'),
            TextField(
              controller: academyQuantityController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Número de unidades'),
            ),
          ],
        ),
      },
      1: {
        0: Column(
          children: [
            Text('Qual o faturamento da ${academyNameController.text}'),
            TextField(decoration: InputDecoration(labelText: 'Faturamento')),
          ],
        ),
        1: Column(
          children: [
            const Text('Quanto você paga de ECAD?'),
            const TextField(decoration: InputDecoration(labelText: 'Valor')),
          ],
        ),
        2: Column(
          children: [
            Text('Quanto a ${academyNameController.text} gasta de energia em média por mês?'),
            TextField(decoration: InputDecoration(labelText: 'Valor')),
          ],
        ),
        3: Column(
          children: [
            Text('Quanto paga por seguro estagiário?'),
            TextField(decoration: InputDecoration(labelText: 'Valor')),
          ],
        ),
        4: Column(
          children: [
            Text('Quanto paga de advogado?'),
            TextField(decoration: InputDecoration(labelText: 'Valor')),
          ],
        ),
      },
      2: {
        0: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Como se chama?', hintText: 'Nome sobrenome'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Seu e-mail', hintText: 'email@email.com.br'),
            ),
            const TextField(decoration: InputDecoration(labelText: 'Whatsapp', hintText: '(00)00000-0000')),
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
    if (buildFormStepsWidgets()[currentStep]?.containsKey(currentSubstep + amountToHandle) ?? false) {
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
  }

  @override
  Widget build(BuildContext context) {
    final Widget? currentWidget = buildFormStepsWidgets()[currentStep]?[currentSubstep];

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
          if (currentWidget != null) currentWidget else const Text('Etapa não encontrada'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            label: const Text('Próximo'),
            onPressed: () {
              formController(1);
            },
            icon: const Icon(Icons.arrow_outward),
            iconAlignment: IconAlignment.end,
            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.yellow)),
          ),
          //
        ],
      ),
    );
  }
}
