import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';

class TextInputUtil {

  TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500
  );

  InputDecoration inputDecoration({
    required String hintText,
    required
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
          color: Palette.darkFont2,
          fontSize: 12,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          color: Palette.outlinedButton1,
          width: 1,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
          color: Palette.outlinedButton1,
          width: 1,
        ),
      )
    );
  }

  Widget text({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    int? maxLength,
    Function? onChanged
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: (value) {
        if (onChanged != null) onChanged(value);
      },
      style: textStyle,
      keyboardType: TextInputType.text,
      decoration: inputDecoration(hintText: hintText),
    );
  }

  Widget number({
    required TextEditingController controller,
    required String hintText,
    Function? onChanged
  }) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        if (onChanged != null) onChanged(value);
      },
      style: textStyle,
      keyboardType: TextInputType.number,
      decoration: inputDecoration(hintText: hintText),
    );
  }
}