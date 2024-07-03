import 'package:flutter/material.dart';

class OnboardingTemplate extends StatefulWidget {
  const OnboardingTemplate({super.key});

  @override
  State<OnboardingTemplate> createState() => _OnboardingTemplateState();
}

class _OnboardingTemplateState extends State<OnboardingTemplate> {
  late final double deviceHeight;

  @override
  void initState() {

    super.initState();
  }

  static const TextStyle textStyle = TextStyle(
    color: Color(0xFF222222),
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500
  );

  Widget onboarding({required String content, required String assetSrc}) {
    return Padding(
      padding: EdgeInsets.only(top: deviceHeight / 791 * 214),
      child: Column(
        children: [
          Text(
            content,
            style: textStyle,
          ),
          const SizedBox(height: 36),
          Image.asset(assetSrc, height: 146)
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    return const Placeholder();
  }
}
