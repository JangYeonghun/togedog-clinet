import 'package:flutter/material.dart';

class InputFormUtil extends StatefulWidget {
  final Widget child;
  const InputFormUtil({super.key, required this.child});

  @override
  State<InputFormUtil> createState() => _InputFormUtilState();
}

class _InputFormUtilState extends State<InputFormUtil> {
  late final double columnHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          try {
            columnHeight = constraints.maxHeight - 80;
          } catch(e) {
            debugPrint(e.toString());
          }

          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: SizedBox(
                height: columnHeight,
                child: widget.child,
              ),
            ),
          );
        }
    );
  }
}
