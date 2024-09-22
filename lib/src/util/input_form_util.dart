import 'package:flutter/material.dart';

class InputFormUtil extends StatefulWidget {
  final Widget child;
  const InputFormUtil({super.key, required this.child});

  @override
  State<InputFormUtil> createState() => _InputFormUtilState();
}

class _InputFormUtilState extends State<InputFormUtil> {
  double? parentHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          parentHeight ??= constraints.maxHeight;

          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: SizedBox(
                height: parentHeight,
                child: widget.child,
              ),
            ),
          );
        }
    );
  }
}
