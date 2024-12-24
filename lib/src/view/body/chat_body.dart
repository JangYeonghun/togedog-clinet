import 'dart:async';
import 'dart:convert';

import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/chat_room_dto.dart';
import 'package:dog/src/repository/chat_repository.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/loading_util.dart';
import 'package:dog/src/view/component/chat/chat_room_list_item.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/chat_template.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:transition/transition.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final ChatRepository chatRepository = ChatRepository();
  late final StreamSubscription fcmStream;
  late Future<List<ChatRoomDTO>> fetchChatList;

  Future<List<ChatRoomDTO>> getChatList() async {
    final Response response = await chatRepository.chatList();
    final List<dynamic> list = jsonDecode(response.body);
    final List<ChatRoomDTO> chatRoomList = list.map((e) => ChatRoomDTO.fromJson(e)).toList();
    chatRoomList.sort((a, b) => b.lastTime.compareTo(a.lastTime));
    return chatRoomList;
  }

  @override
  void initState() {
    fcmStream = FirebaseMessaging.onMessage.listen((message) async {
      debugPrint('테스트다 테스트');

      if (message.data.isEmpty) return;

      final int roomId = int.parse(message.data['roomId']);
      final Response response = await chatRepository.chatRoom(roomId: roomId);
      final ChatRoomDTO dto = ChatRoomDTO.fromJson(jsonDecode(response.body));
      (await fetchChatList).removeWhere((e) => e.roomId == roomId);
      (await fetchChatList).insert(0, dto);
      setState(() {

      });
    });
    fetchChatList = getChatList();
    super.initState();
  }

  @override
  void dispose() {
    fcmStream.cancel();
    super.dispose();
  }

  Widget emptyChat() {
    return Center(
      child: Text(
        '아직 받은 메시지가 없어요',
        style: TextStyle(
            color: Palette.darkFont2,
            fontSize: 14.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget chatListBuilder() {
    return FutureBuilder(
      future: fetchChatList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingUtil();
        }

        if (!snapshot.hasData || snapshot.data.isEmpty) {
          return emptyChat();
        }

        final List<ChatRoomDTO> chatListData = snapshot.data;

        return ListView.builder(
            itemCount: chatListData.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  fcmStream.pause();
                  final ChatRoomDTO dto = chatListData[index];
                  Navigator.push(
                      context,
                      Transition(
                          transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
                          child: ChatTemplate(roomId: dto.roomId, profileImage: dto.senderImage)
                      )
                  ).whenComplete(() {
                    setState(() {
                      fetchChatList = getChatList();
                    });
                    fcmStream.resume();
                  });
                },
                child: ChatRoomListItem(chatRoomDto: chatListData[index])
              );
            }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      appBar: const PopHeader(title: '채팅', useBackButton: true),
      body: chatListBuilder()
    );
  }
}
