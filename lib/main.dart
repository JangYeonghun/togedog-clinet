import 'package:dog/config/global_variables.dart';
import 'package:dog/template/onboarding_template.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalVariables.height = MediaQuery.of(context).size.height;
    GlobalVariables.width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: OnboardingTemplate(),
    );
  }
}
