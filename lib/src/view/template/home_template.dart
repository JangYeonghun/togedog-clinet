import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/body/home_body.dart';
import 'package:dog/src/view/component/home/home_header.dart';
import 'package:flutter/material.dart';

class HomeTemplate extends StatelessWidget {
  const HomeTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonScaffoldUtil(
        appBar: HomeHeader(),
        body: HomeBody()
    );
  }
}
