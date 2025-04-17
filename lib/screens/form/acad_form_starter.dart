import 'package:acad_calculator/screens/form/acad_form.dart';
import 'package:flutter/material.dart';

class AcadFormStarter extends StatefulWidget {
  const AcadFormStarter({super.key});

  @override
  State<AcadFormStarter> createState() => _AcadFormStarterState();
}

class _AcadFormStarterState extends State<AcadFormStarter> {
  int currentStep = 0;
  int currentSubstep = 0;

  void handleNavigation() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/acad-logo.png'),
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_rounded),
          onPressed: () {
            handleNavigation;
          },
        ),
      ),
      body: AcadForm(),
    );
  }
}
