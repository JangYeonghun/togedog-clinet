import 'package:flutter/material.dart';

Widget horizontalDivider({
  double margin = 8
}) {
  return Container(
    height: 1,
    width: double.infinity,
    color: const Color(0xFFE5E5E5),
    margin: EdgeInsets.only(
      top: margin,
      bottom: margin
    ),
  );
}