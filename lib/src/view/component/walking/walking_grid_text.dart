import 'package:flutter/material.dart';

class WalkingGridText extends StatelessWidget {
  const WalkingGridText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(top: 15, left: 16),
      alignment: Alignment.centerLeft,
      child: const Text(
        '전체',
        style: TextStyle(
          color: Color(0xFF222222),
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
