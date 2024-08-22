import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';

class MenuTemplate extends StatefulWidget {
  const MenuTemplate({super.key});

  @override
  State<MenuTemplate> createState() => _MenuTemplateState();
}

class _MenuTemplateState extends State<MenuTemplate> {
  @override
  Widget build(BuildContext context) {
    return const CommonScaffoldUtil(
      appBar: PopHeader(title: '메뉴', useBackButton: true),
      body: SizedBox()
    );
  }
}
