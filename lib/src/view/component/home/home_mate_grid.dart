import 'dart:convert';

import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/dto/user_profile_dto.dart';
import 'package:dog/src/repository/user_profile_repository.dart';
import 'package:dog/src/util/loading_util.dart';
import 'package:dog/src/view/component/home/home_mate_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeMateGrid extends StatefulWidget {
  final Widget gridText;

  const HomeMateGrid({
    super.key,
    this.gridText = const SizedBox(),
  });

  @override
  State<HomeMateGrid> createState() => _HomeMateGridState();
}

class _HomeMateGridState extends State<HomeMateGrid> {
  late final Future<List<UserProfileDTO>> randomMates;
  final deviceWidth = GlobalVariables.width;

  @override
  void initState() {
    randomMates = getRandomMates();
    super.initState();
  }

  Future<List<UserProfileDTO>> getRandomMates() async {
    final Response response = await UserProfileRepository().getRandomList(context: context, page: 0, size: 6);
    final List<dynamic> list = jsonDecode(response.body)['content'];
    final List<UserProfileDTO> result = list.map((e) => UserProfileDTO.fromJson(e)).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.gridText,
          FutureBuilder(
            future: randomMates,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<UserProfileDTO> data = snapshot.data;
                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 11,
                        childAspectRatio: 168/200
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: 12, right: 16, top: 15, bottom: 10),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return HomeMateGridItem(
                          width: deviceWidth - 43,
                          height: (deviceWidth - 43) / 168 * 200,
                          userProfileDTO: data[index],
                      );
                    }
                );
              } else {
                return const LoadingUtil();
              }
            }
          )
        ],
      ),
    );
  }
}