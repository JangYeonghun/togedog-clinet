import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';

class HomeGridText extends StatelessWidget {
  const HomeGridText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 23, left: 24),
          child: Text(
            '산책메이트 프로필 카드',
            style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 20,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 0
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8, left: 24),
          child: Text(
            '나와 딱 맞는 산책 메이트를 추천해드려요!',
            style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 0
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
