import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';

class PostingPage extends StatefulWidget {
  const PostingPage({super.key});

  @override
  State<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      backgroundColor: Colors.white,
      appBar: const PopHeader(title: '산책하기', useBackButton: true),
      body: Column(
        children: [

        ],
      )
    );
  }
}
