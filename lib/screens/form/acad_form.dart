import 'package:acad_calculator/entities/brazilian_state.dart';
import 'package:acad_calculator/entities/search_states_and_cities.dart';
import 'package:acad_calculator/functions/send_email.dart';
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
  String? ufSelecionada;
  String? cidadeSelecionada;

  final TextEditingController academyQuantityController = TextEditingController();
  final TextEditingController academyBillingController = TextEditingController();
  final TextEditingController ecadBillingController = TextEditingController();
  final TextEditingController lightBillingController = TextEditingController();
  final TextEditingController traineeBillingController = TextEditingController();
  final TextEditingController lawyerBillingController = TextEditingController();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userWhatsappController = TextEditingController();

  final int economyWithAcad = 0;

  List<BrazilianState> estados = [];

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
            TextField(
              controller: academyBillingController,
              decoration: InputDecoration(labelText: 'Faturamento'),
            ),
          ],
        ),
        1: Column(
          children: [
            Text('Quanto você paga de ECAD?'),
            TextField(controller: ecadBillingController, decoration: InputDecoration(labelText: 'Valor')),
          ],
        ),
        2: Column(
          children: [
            Text('Quanto a ${academyNameController.text} gasta de energia em média por mês?'),
            TextField(controller: lightBillingController, decoration: InputDecoration(labelText: 'Valor')),
          ],
        ),
        3: Column(
          children: [
            Text('Quanto paga por seguro estagiário?'),
            TextField(controller: traineeBillingController, decoration: InputDecoration(labelText: 'Valor')),
          ],
        ),
        4: Column(
          children: [
            Text('Quanto paga de advogado?'),
            TextField(controller: lawyerBillingController, decoration: InputDecoration(labelText: 'Valor')),
          ],
        ),
      },
      2: {
        0: Column(
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: 'Como se chama?', hintText: 'Nome sobrenome'),
            ),
            TextField(
              controller: userEmailController,
              decoration: InputDecoration(labelText: 'Seu e-mail', hintText: 'email@email.com.br'),
            ),
            TextField(
              controller: userWhatsappController,
              decoration: InputDecoration(labelText: 'Whatsapp', hintText: '(00)00000-0000'),
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
      fillEmailDataAndSendEmail();
      calculateEconomy();
      Navigator.pushNamed(context, '/end_screen');
      return;
    }
  }

  void calculateEconomy() {}
  void fillEmailDataAndSendEmail() async {
    final academyName = academyNameController.text;
    final city = cidadeSelecionada ?? '';
    final state = ufSelecionada ?? '';
    final unitCount = academyQuantityController.text;
    final totalBilling = academyBillingController.text;
    final ecad = ecadBillingController.text;
    final electricity = lightBillingController.text;
    final traineeInsurance = traineeBillingController.text;
    final lawyer = lawyerBillingController.text;

    final userName = userNameController.text;
    final userEmail = userEmailController.text;
    final userWhatsapp = userWhatsappController.text;

    final emailBody = '''
      Nova submissão do formulário da calculadora:

      🏋️ Academia: $academyName
      📍 Localização: $city - $state
      🏢 Unidades: $unitCount

      💰 Faturamento total: $totalBilling

      Gastos mensais:
      🎵 ECAD: $ecad
      💡 Energia: $electricity
      👨‍🎓 Seguro estagiário: $traineeInsurance
      ⚖️ Advogado: $lawyer

      Economia total: $economyWithAcad
      👤 Informações do responsável:
      Nome: $userName
      E-mail: $userEmail
      WhatsApp: $userWhatsapp
      ''';

    await sendEmail(subject: 'Nova submissão - $academyName', body: emailBody);
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
        ],
      ),
    );
  }
}
