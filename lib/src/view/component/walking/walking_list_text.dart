import 'package:flutter/material.dart';

class WalkingListText extends StatelessWidget {
  const WalkingListText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 16),
      alignment: Alignment.centerLeft,
      child: const Text(
        '글 목록',
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
