import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopCloseButton extends StatelessWidget {
  final Color color;
  final Function? onTap;

  const PopCloseButton({
    super.key,
    this.color = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () {
          if (onTap != null) {
            onTap!();
          } else {
            Navigator.of(context).pop();
          }
        },
        icon: Icon(Icons.arrow_back_ios_new, size: 25.5.r, color: color),
      ),
    );
  }
}