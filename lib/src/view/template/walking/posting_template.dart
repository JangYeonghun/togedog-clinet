import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/walking/posting_register.dart';
import 'package:flutter/material.dart';

class PostingTemplate extends StatefulWidget {
  const PostingTemplate({super.key});

  @override
  State<PostingTemplate> createState() => _PostingTemplateState();
}

class _PostingTemplateState extends State<PostingTemplate> {
  @override
  Widget build(BuildContext context) {
    return const CommonScaffoldUtil(
      backgroundColor: Colors.white,
      appBar: PopHeader(title: '산책하기', useBackButton: true),
      body: PostingRegister(),
    );
  }
}
