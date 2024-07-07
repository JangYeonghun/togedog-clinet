import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/view/component/home/record_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, _) {
        final mode = ref.watch(modeProvider);
        return Center(
          child: mode ? const RecordTab() : const Text('산책메이트'),
        );
      },
    );
  }
}
