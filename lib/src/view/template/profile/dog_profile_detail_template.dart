import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/view/component/bottom_navigation.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';

class DogProfileDetailTemplate extends StatefulWidget {
  final Map<String, dynamic> dogProfile;
  const DogProfileDetailTemplate({super.key, required this.dogProfile});

  @override
  State<DogProfileDetailTemplate> createState() => _DogProfileDetailTemplateState();
}

class _DogProfileDetailTemplateState extends State<DogProfileDetailTemplate> with SingleTickerProviderStateMixin {
  final double deviceHeight = GlobalVariables.height;
  final double deviceWidth = GlobalVariables.width;
  late final TabController _tabController;
  late Map<String, dynamic> dogProfile;

  @override
  void initState() {
    dogProfile = widget.dogProfile;
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget miniProfile() {
    return Container(
      width: deviceWidth - 28,
      height: (deviceWidth - 28) / 347 * 143,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ]
      ),
      padding: const EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                dogProfile['name'],
                style: const TextStyle(
                    color: Palette.darkFont4,
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(width: 13),
              Image.asset('assets/images/edit_icon.png', width: 18, height: 18)
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  '${dogProfile['gender']} | ${dogProfile['age']} | ${dogProfile['size']} | ${dogProfile['breed']}',
                  style: const TextStyle(
                      color: Palette.darkFont2,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Container(
                height: 1,
                color: const Color(0xFFC2C2C2),
                margin: const EdgeInsets.only(top: 7, bottom: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  dogProfile['region'],
                  style: const TextStyle(
                      color: Palette.darkFont2,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget infoItem({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 7, bottom: 7),
      child: Row(
        children: [
          SizedBox(
            width: deviceWidth / 375 * 205 - 40,
            child: Text(
              title,
              style: const TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
          Text(
            content,
            style: const TextStyle(
                color: Palette.darkFont4,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500
            ),
          )
        ],
      ),
    );
  }

  Widget additionalInfo() {
    return Container(
      margin: EdgeInsets.only(top: deviceHeight * 0.51),
      height: deviceHeight * 0.49,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)),
          color: Colors.white
      ),
      padding: const EdgeInsets.only(top: 70, left: 36),
      child: Column(
        children: [
          Row(
            children: dogProfile['hashTags'].map<Widget>((e) => hashTagItem(hashTag: e)).toList(),
          ),
          const SizedBox(height: 25),
          infoItem(title: '체중', content: '${dogProfile['weight']}kg'),
          infoItem(title: '중성화', content: dogProfile['neuter'] ? 'O' : 'X'),
          infoItem(title: '예방접종', content: dogProfile['vaccine'] ? 'O' : 'X')
        ],
      ),
    );
  }

  Widget hashTagItem({required String hashTag}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: Palette.ghostButton1
      ),
      margin: const EdgeInsets.only(left: 4, right: 4),
      padding: const EdgeInsets.only(left: 13, right: 13, top: 7, bottom: 6),
      child: Text(
        hashTag,
        style: const TextStyle(
          color: Palette.darkFont2,
          fontSize: 12,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget dogNote() {
    return Container(
      margin: EdgeInsets.only(top: deviceHeight * 0.51),
      height: deviceHeight * 0.49,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)),
          color: Colors.white
      ),
      padding: const EdgeInsets.only(top: 70, left: 39, right: 39),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 2),
            child: Text(
              '특이사항',
              style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Container(
            height: 1,
            color: Palette.outlinedButton3,
            margin: const EdgeInsets.only(top: 14, bottom: 14),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              dogProfile['note'],
              style: const TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dogProfileFront() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(imageUrl: dogProfile['imgUrl'], height: deviceHeight * 0.51, fit: BoxFit.fitHeight),
        Stack(
          alignment: Alignment.center,
          children: [
            additionalInfo(),
            miniProfile(),
          ],
        )
      ],
    );
  }

  Widget dogProfileBack() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(imageUrl: dogProfile['imgUrl'], height: deviceHeight * 0.51, fit: BoxFit.fitHeight),
        Stack(
          alignment: Alignment.center,
          children: [
            dogNote(),
            Container(
              width: deviceWidth / 375 * 187,
              height: deviceWidth / 375 * 187,
              margin: EdgeInsets.only(bottom: deviceWidth / 375 * 187 * 0.35),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 4, color: Colors.white)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: CachedNetworkImage(imageUrl: dogProfile['imgUrl'], fit: BoxFit.cover)
              )
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: const PopHeader(title: '프로필', useBackButton: true),
        body: TabBarView(
          controller: _tabController,
          children: [
            dogProfileFront(),
            dogProfileBack()
          ],
        ),
      ),
    );
  }
}
