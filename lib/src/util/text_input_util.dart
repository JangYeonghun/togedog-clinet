import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TextInputUtil {

  TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12.sp,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500
  );

  InputDecoration inputDecoration({
    required String hintText,
    required
  }) {
    return InputDecoration(
      counterText: '',
      hintText: hintText,
      hintStyle: TextStyle(
          color: Palette.darkFont2,
          fontSize: 12.sp,
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
          color: Palette.green6,
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

  Widget phone({
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
      keyboardType: TextInputType.phone,
      decoration: inputDecoration(hintText: hintText),
    );
  }

  Widget money({
    required TextEditingController controller,
    required String hintText,
    Function? onChanged
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: textStyle,
      onChanged: (value) {
        if (value.isNotEmpty) {
          final formatter = NumberFormat('#,###');
          final numericValue = int.parse(value.replaceAll(',', ''));
          final newValue = '${formatter.format(numericValue)} 원';
          if (controller.text != newValue) {
            controller.value = controller.value.copyWith(
              text: newValue,
              selection: TextSelection.collapsed(offset: newValue.length - 1),
            );
          }
        } else {
          controller.clear();
        }
        if (onChanged != null) onChanged(controller.text);
      },
      decoration: inputDecoration(hintText: '$hintText 원'),
    );
  }
}