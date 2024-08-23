import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Scaffold는 appBar 속성에 PreferredSizeWidget을 기대함. 이를 통해 나머지 레이아웃을 조정함(body 등)
class PopHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? useBackButton;
  final Color color;

  const PopHeader({
    super.key,
    required this.title,
    this.useBackButton = false,
    this.color = Colors.white,
  });

  @override
  Size get preferredSize => Size.fromHeight(55.h);

  @override
  Widget build(BuildContext context) {
    bool isPressed = false;

    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 0.1.sw,
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
            ) : SizedBox(width: 0.1.sw),
          ),
          SizedBox(
            width: 0.6.sw,
            height: 19.h,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF222222),
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 0.1.sw),
        ],
      ),
    );
  }
}
