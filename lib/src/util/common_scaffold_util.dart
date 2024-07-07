import 'package:flutter/material.dart';

class CommonScaffoldUtil extends StatelessWidget {
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  const CommonScaffoldUtil({super.key, this.backgroundColor = Colors.white, this.appBar, required this.body, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        )
    );
  }
}
