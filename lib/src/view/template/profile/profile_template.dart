import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/profile/dog_profile_template.dart';
import 'package:dog/src/view/template/profile/user_profile_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTemplate extends StatefulWidget {
  const ProfileTemplate({super.key});

  @override
  State<ProfileTemplate> createState() => _ProfileTemplateState();
}

class _ProfileTemplateState extends State<ProfileTemplate> {

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(

        body: Consumer(
          builder: (context, ref, _) {
            final mode = ref.watch(modeProvider);
            return CommonScaffoldUtil(
                appBar: const PopHeader(title: '프로필'),
                body: mode ?
                const DogProfileTemplate() :
                const UserProfileTemplate()
            );
          },
        )
    );
  }
}
