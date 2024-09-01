import 'package:flutter/material.dart';

class LoadingUtil extends StatelessWidget {
  const LoadingUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Loading...',
        style: TextStyle(
          fontSize: 30,
          color: Colors.black
        ),
      ),
    );
  }
}
