import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/view/template/main_template.dart';
import 'package:dog/src/view/template/onboarding_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalVariables.width = MediaQuery.of(context).size.width;
    GlobalVariables.height = MediaQuery.of(context).size.height;

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingTemplate(),
        '/main': (context) => const MainTemplate(),
        // '/terms': (context) => const SignTermsTemplate(),
        // '/home': (context) => const MainTemplate(),
      },
    );
  }
}