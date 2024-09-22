import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/dog_profile_dto.dart';
import 'package:dog/src/dto/my_walk_board_content_dto.dart';
import 'package:dog/src/dto/my_walk_schedule_content_dto.dart';
import 'package:dog/src/dto/my_walk_schedule_dto.dart';
import 'package:dog/src/dto/my_walking_dto.dart';
import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/repository/my_walk_repository.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/horizontal_divider.dart';
import 'package:dog/src/util/loading_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/profile/dog_profile_detail_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:transition/transition.dart';

class MyWalkBody extends StatefulWidget {
  const MyWalkBody({super.key});

  @override
  State<MyWalkBody> createState() => _MyWalkBodyState();
}

class _MyWalkBodyState extends State<MyWalkBody> with SingleTickerProviderStateMixin {
  final double deviceWidth = GlobalVariables.width;
  final MyWalkRepository myWalkRepository = MyWalkRepository();

  late TabController _tabController;
  late final Future<MyWalkingDto> myWalkList;
  late final Future<MyWalkScheduleDTO> myWalkSchedule;

  Future<MyWalkScheduleDTO> getMyWalkSchedule() async {
    final Response response = await myWalkRepository.myWalkScheduleList(context: context);
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final MyWalkScheduleDTO result = MyWalkScheduleDTO.fromJson(jsonData);
    return result;
  }

  Future<MyWalkingDto> getMyWalkList() async {
    final Response response = await myWalkRepository.myWalkList(context: context);
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final MyWalkingDto result = MyWalkingDto.fromJson(jsonData);
    return result;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget ownerMyWalk() {
    return Column(
      children: [
        topInfo(text: '산책일정'),
        Expanded(
          child: Container(
              color: const Color(0xFFF2F2F2),
              child: FutureBuilder<MyWalkScheduleDTO>(
                  future: getMyWalkSchedule(),
                  builder: (BuildContext context, AsyncSnapshot<MyWalkScheduleDTO> snapshot) {
                    if (snapshot.hasData) {
                      final MyWalkScheduleDTO? data = snapshot.data;
          
                      if (data!.content.isNotEmpty) {
                        return ListView.builder(
                            padding: const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18),
                            itemCount: data.content.length,
                            itemBuilder: (context, index) {
                              return myWalkScheduleItem(profile: data.content[index]);
                            }
                        );
                      } else {
                        return Text('산책 일정이 없어요');
                      }
                    } else {
                      return const LoadingUtil();
                    }
                  }
              ),
          ),
        ),
      ],
    );
  }

  Widget myWalkScheduleItem({required MyWalkScheduleContentDTO profile}) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     Transition(
        //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
        //         child: DogProfileDetailTemplate(profile: profile)
        //     )
        // );
      },
      child: Container(
        width: 343.w,
        height: 142.h,
        margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
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
        padding: EdgeInsets.only(left: 23.w, top: 18.h, right: 12.w, bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  width: 53.w,
                  height: 53.h,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: CachedNetworkImage(imageUrl: profile.matePhotoUrl, fit: BoxFit.cover)
                  ),
                ),
                Container(
                  width: deviceWidth - (deviceWidth - 28) / 347 * 53 - 80,
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${profile.statrTime} - ${profile.endTime}',
                            style: TextStyle(
                                color: Palette.darkFont4,
                                fontSize: 12.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Container(
                            height: 22.h,
                            width: 44.w,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Palette.green6),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '프로필',
                              style: TextStyle(
                                  color: Palette.green6,
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        profile.pickUpDay,
                        style: TextStyle(
                          color: Palette.darkFont4,
                          fontSize: 12.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            profile.mateNickname,
                            style: TextStyle(
                              color: Palette.darkFont2,
                              fontSize: 12.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${profile.feeType}: ${profile.fee}원',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Palette.darkFont2,
                              fontSize: 12.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            horizontalDivider(margin: 7.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                profile.matchStatus,
                style: TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ownerMatchWalk() {
    return Column(
      children: [
        topInfo(text: '내가 쓴 글'),
        Expanded(
          child: Container(
            color: const Color(0xFFF2F2F2),
            child: FutureBuilder<MyWalkingDto>(
                future: getMyWalkList(),
                builder: (BuildContext context, AsyncSnapshot<MyWalkingDto> snapshot) {
                  if (snapshot.hasData) {
                    final MyWalkingDto? data = snapshot.data;

                    if (data!.content.isNotEmpty) {
                      return ListView.builder(
                          padding: const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18),
                          itemCount: data.content.length,
                          itemBuilder: (context, index) {
                            return wroteMyWalkItem(profile: data.content[index]);
                          }
                      );
                    } else {
                      return Text('산책 일정이 없어요');
                    }
                  } else {
                    return const LoadingUtil();
                  }
                }
            ),
          ),
        ),
      ],
    );
  }

  Widget wroteMyWalkItem({required MyWalkBoardContentDTO profile}) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     Transition(
        //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
        //         child: DogProfileDetailTemplate(profile: profile)
        //     )
        // );
      },
      child: Container(
        width: 343.w,
        height: 220.h,
        margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
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
        padding: EdgeInsets.only(left: 23.w, top: 28.h, right: 23.w, bottom: 22.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              profile.title,
              style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 16.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              profile.pickUpDay,
              style: TextStyle(
                color: const Color(0xFF818181),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  profile.pickupLocation1,
                  style: TextStyle(
                    color: const Color(0xFF818181),
                    fontSize: 12.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '매칭하기',
                  style: TextStyle(
                    color: Palette.green6,
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            horizontalDivider(margin: 12),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  width: 70.w,
                  height: 70.h,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: CachedNetworkImage(imageUrl: 'profile.이게머시여!', fit: BoxFit.cover)
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      profile.name,
                      style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 13.h),
                    Text(
                      '${profile.dogGender} | ${profile.age}살 | ${profile.dogType} | ${profile.breed}',
                      style: TextStyle(
                        color: const Color(0xFF818181),
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget walkerMyWalk() {
    return Column(
      children: [
        topInfo(text: '산책일정'),
        Expanded(
          child: Container(
            color: const Color(0xFFF2F2F2),
            child: FutureBuilder(
                future: myWalkList,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final List<DogProfileDTO> data = snapshot.data;

                    if (data.isNotEmpty) {
                      return ListView.builder(
                          padding: const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            // return walkScheduleItem(profile: data[index]);
                            return SizedBox();
                          }
                      );
                    } else {
                      return Text('산책 일정이 없어요');
                    }
                  } else {
                    return const LoadingUtil();
                  }
                }
            ),
          ),
        ),
      ],
    );
  }

  Widget topInfo({
    required String text
  }) {
    return Container(
        width: 1.sw,
        height: 50.h,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.w),
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFF222222),
            fontSize: 14.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MYLOG build MyWalkBody');

    return Consumer(
      builder: (context, ref, _) {
        final mode = ref.watch(modeProvider);
        return CommonScaffoldUtil(
          appBar: const PopHeader(title: '내 산책', useBackButton: false),
          body: mode ?
              TabBarView(
                  controller: _tabController,
                  children: [
                    ownerMyWalk(),
                    ownerMatchWalk(),
                  ],
              ) :
          walkerMyWalk(),
        );
      }
    );
  }
}