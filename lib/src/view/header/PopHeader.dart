import 'package:dog/src/config/global_variables.dart';
import 'package:flutter/material.dart';

// Scaffold는 appBar 속성에 PreferredSizeWidget을 기대함. 이를 통해 나머지 레이아웃을 조정함(body 등)
class PopHeader extends StatelessWidget implements PreferredSizeWidget {
  static const double defaultHeight = 55;
  final String title;
  final bool? useBackButton;

  const PopHeader({
    super.key,
    required this.title,
    this.useBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(defaultHeight);

  @override
  Widget build(BuildContext context) {
    GlobalVariables.width = MediaQuery.of(context).size.width;

    final deviceWidth = GlobalVariables.width;

    const double textHeight = 19;

    bool isPressed = false;

    return Container(
      height: defaultHeight,
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: deviceWidth * 0.1,
            child: useBackButton! ? IconButton(
                onPressed: () {
                  if (!isPressed) {
                    isPressed = true;
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                )
            ) : const SizedBox(),
          ),
          SizedBox(
            width: deviceWidth * 0.6,
            height: textHeight,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: deviceWidth * 0.1),
        ],
      ),
    );
  }
}
