import 'dart:convert';

import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/dog_profile_dto.dart';
import 'package:dog/src/repository/dog_profile_repository.dart';
import 'package:dog/src/util/loading_util.dart';
import 'package:dog/src/view/component/home/home_dog_list_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeDogList extends StatefulWidget {
  const HomeDogList({super.key});

  @override
  State<HomeDogList> createState() => _HomeDogListState();
}

class _HomeDogListState extends State<HomeDogList> {

  late Future<List<DogProfileDTO>> randomDogs;

  Future<List<DogProfileDTO>> getRandomDogs() async {
    final Response response = await DogProfileRepository().getRandomDogs(
        context: context,
        page: 0,
        size: 6
    );

    final List<dynamic> list = jsonDecode(response.body)['content'];
    return list.map((e) => DogProfileDTO.fromJson(e)).toList();
  }

  @override
  void initState() {
    randomDogs = getRandomDogs();
    super.initState();
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
          const Padding(
            padding: EdgeInsets.only(top: 23, left: 24),
            child: Text(
              '반려견 프로필 카드',
              style: TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 0
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 24),
            child: Text(
              '나와 딱 맞는 반려견을 추천해드려요!',
              style: TextStyle(
                  color: Palette.darkFont2,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 0
              ),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: randomDogs,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final DogProfileDTO data = snapshot.data[index];
                      return HomeDogListItem(dogProfileDTO: data);
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
