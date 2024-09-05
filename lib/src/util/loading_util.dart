import 'package:flutter/material.dart';

class LoadingUtil extends StatelessWidget {
  const LoadingUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/images/loading_black.gif', width: 80),
    );
  }
}
